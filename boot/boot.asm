;;; name: boot.asm
;;; author: Loulanguju
;;; time: 2013-8-26
        BOOT_SEG        EQU 0x7c00
        MONITOR_SEG     EQU 0x8000
        MONITOR_SECTOR  EQU 1
        bits 16

        org BOOT_SEG
start:
        mov ax, cs
        mov ds, ax
        mov ss, ax
        mov es, ax
        mov sp, BOOT_SEG

        call clear_screen
        ;; mov si, welcome
        ;; call puts

        mov esi, MONITOR_SECTOR
        mov di, MONITOR_SEG
        call load_module

        ;; mov si, monitor_msg
        ;; call puts

        jmp MONITOR_SEG + 2

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

welcome:        db "Welcome to Falcon System!", 0x0
monitor_msg:    db 13, 10, "Load the monitor module", 0x0
times   510-($-$$) db  0
end     dw 0xAA55
