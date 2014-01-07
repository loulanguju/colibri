;;; name: bootmonitor.asm
;;; author: Loulanguju
;;; time: 2013-8-26
        KERNEL_SECTOR   EQU 10
        BOOT_SEG        EQU 0x7c00
        MONITOR_SEG     EQU 0x8000
        KERNEL_SEG      EQU 0x9000
        CODE_SEG        EQU 0x0008
        DATA_SEG        EQU 0x0010
;;; ---------------------------------------------
;;; 16-bits world entry
;;; ---------------------------------------------
        [section .text]
        bits 16

     org MONITOR_SEG
monitor_begin:

monitor_length  dw (monitor_end - monitor_begin)
_start:
        jmp main

        ;;---------------------------------------------
        ;; gdt
        ;;---------------------------------------------
gdt:
        dd      0x00000000     ; null descriptor
        dd      0x00000000

        dw      0x0ffff         ; code descriptor
        dw      0x0000
        db      0x00
        db      10011010b
        db      11001111b
        db      0x00

        dw      0x0ffff         ; data descriptor
        dw      0x0000
        db      0x00
        db      10010010b
        db      11001111b
        db      0x00
gdtend:
gdtdesc:
        dw      gdtend - gdt - 1
        dd      gdt

monitor_msg                db 13, 10, "success: load monitor module from floopy.", 0x0
kernel_loadding_mag        db 13, 10, "Running: load kernel module from floopy", 0x0
kernel_jump_msg            db 13, 10, "success: Jump to kernel", 0x0

main:
        cli
        xor ax, ax
        mov ds, ax
        mov es, ax
        mov ss, ax
        mov sp, BOOT_SEG
        sti

        ;; mov si, kernel_loadding_mag
        ;; call puts

        ;; Load kernel module
        mov esi, KERNEL_SECTOR
        mov di, KERNEL_SEG
        call load_module

        ;; mov si, kernel_jump_msg
        ;; call puts

        ;; clear the screen
        ;; call clear_screen

        ;; load gdt
        cli
        lgdt [gdtdesc]
        sti

        ;; enable a20 address line
        mov eax, cr0
        or  eax, 0x0001
        mov cr0, eax

        ;; jump to 32 bits world
        jmp dword CODE_SEG : kstart

clear_screen:
        pusha
        mov ax, 0x0600
        xor cx, cx
        xor bh, 0x0f
        mov dh, 24
        mov dl, 79
        int 0x10

	mov ah, 02
	mov bh, 0
	mov dx, 0
	int 0x10
        popa
        ret

;;; ---------------------------------------------
;;; putc(char ch)
;;; print a char on the real mode
;;; ch: si
;;; ---------------------------------------------
putc:
        pusha
        xor bh, bh
        mov ax, si
        mov ah, 0x0e
        int 0x10
        popa
        ret
;;; ---------------------------------------------
;;; puts(char* str)
;;; print the string on the real mode
;;; str: si(input)
;;; ---------------------------------------------
puts:
        pusha
        mov ah, 0x0e
        xor bh, bh
do_puts_loop:
        lodsb
        test al, al
        jz do_puts_done
        int 0x10
        jmp do_puts_loop
do_puts_done:
        popa
        ret

;;; ---------------------------------------------
;;; print_decimal(int deciaml)
;;; print the decimal number
;;; decimal: esi
;;; ---------------------------------------------
print_decimal:
        jmp do_print_decimal
values:  times 20 db 0
do_print_decimal:
        pusha
        mov eax, esi
        mov ecx, 10
        lea esi, [values+19]
do_print_decimal_loop:
        dec esi
        xor edx, edx
        div ecx
        add edx, '0'
        mov [esi], dl
        test eax, eax
        jnz do_print_decimal_loop
do_print_decimal_done:
        call puts
        popa
        ret

;;; ---------------------------------------------
;;; load_module(int module, char *buf)
;;; module: esi(input)
;;; buf: di(input)
;;; ----------------------------------------------
load_module:
        call read_sector
        test ax, ax
        jnz do_load_module_done

        mov cx, [di]
        test cx, cx
        setz al
        jz do_load_module_done
        add cx, 512 - 1
        shr cx, 9
do_load_module_loop:
        dec cx
        jz do_load_module_done
        inc esi
        add di, 0x200
        call read_sector
        test ax, ax
        jz do_load_module_loop
do_load_module_done:
        ret
;;;-----------------------------------------------
;;; read_sector(int sector, char *buf)
;;; read a sector from the floppy
;;; esi: sector(input)
;;; di: buf(input)
;;; ----------------------------------------------
read_sector:
        pusha

        mov ax, si
        mov bx, di
        call lba2chs
        mov dl, 0
        mov ax, 0x201

        int 0x13

        setc al
        jmp do_read_sector_done
do_read_sector_done:
        popa
        movzx ax, al
        ret

;;; ----------------------------------------------
;;; lba2chs(int sector)
;;; lba mode convert to chs
;;;     sector: ax(input)
;;;     cylinder: ch(output)
;;;     sector: cl(output)
;;;     head: dh(output)
;;; ---------------------------------------------
lba2chs:
        mov cl, 18
        div cl
        mov ch, al
        shr ch, 1

        mov dh, al
        and dh, 1

        mov cl, ah
        inc cl
        ret

;; ---------------------------------------------
;; 32-bits world entry
;; ---------------------------------------------
        bits 32
kstart:
        ;; reset the segments
        mov ax, DATA_SEG
        mov ds, ax
        mov es, ax
        mov gs, ax
        mov fs, ax
        mov ss, ax
        mov esp, BOOT_SEG

        ;; Jump to kernel module
        jmp dword CODE_SEG : KERNEL_SEG + 2

        cli
        jmp $
monitor_end:
