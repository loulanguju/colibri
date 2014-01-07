;;; name: klib.asm
;;; author: loulanguju
;;; time: 2013-8-28
        global io_hlt
        global mem_read8
        global mem_write8
        global outb
        global int81

;;; ---------------------------------------------
;;; void io_hlt()
;;; hlt the computer
;;; ---------------------------------------------
io_hlt:
        hlt
        ret

int81:
        int 0x40
        ret

;;; ---------------------------------------------
;;; u8_t mem_read8(u16_t segment, u16_t *offset)
;;; read a byte from segment : offset
;;; ---------------------------------------------
mem_read8:
        push ecx
        mov cx, ds
        mov ds, [esp+4]
        mov eax, [esp+8]
        xor eax, eax
        mov al, [eax]
        mov ds, cx
        pop ecx
        ret

;;; ---------------------------------------------
;;; void mem_write8(u16_t segment, u16_t *offset, u8_t data)
;;; write a byte to segment : offset
;;; ---------------------------------------------
mem_write8:
        push ebp
        mov ebp, esp
        push ecx
        push ebx
        mov cx, ds
        mov ds, [ebp+8]
        mov eax, [ebp+12]
        mov bl, [ebp+16]
        mov [eax], bl
        mov ds, cx
        pop ebx
        pop ecx
        pop ebp
        ret

;;; ---------------------------------------------
;;; void outb(int port, int data)
;;;----------------------------------------------
outb:
        mov edx, [esp + 4]
        mov al, [esp + 8]
        out dx, al
        ret
