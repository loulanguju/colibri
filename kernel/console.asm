;;; name: console.asm
;;; author: loulanguju
;;; time: 2013-7-28

        bits 32

        global putch
        global puts
        global clear_screen
        global move_cursor

VIDEO_OFFSET    EQU 0xb8000
ROWS            EQU 25
COLS            EQU 80
CHAR_ATTRIB     EQU 14

curx db 0
cury db 0

;;; ---------------------------------------------
;;; void putch(char ch)
;;; print a char on the screen
;;; ---------------------------------------------
putch:
        push ebp
        mov ebp, esp
        pusha
        mov edi, VIDEO_OFFSET
        xor eax, eax
        mov ecx, COLS * 2
        mov al, byte [cury]
        mul ecx
        push eax

        mov al, byte [curx]
        mov cl, 2
        mul cl
        pop ecx
        add eax, ecx

        xor ecx, ecx
        add edi, eax

        mov ebx, [ebp + 8]
        cmp bl, 10
        je do_putch_new_line

        mov dl, bl
        mov dh, CHAR_ATTRIB
        mov word [edi], dx

        inc byte [curx]
        mov al, [curx]
        cmp al, COLS
        je do_putch_new_line
        jmp do_putch_done

do_putch_new_line:
        mov byte[curx], 0
        inc byte[cury]

do_putch_done:
        popa
        pop ebp
        ret

;;; ---------------------------------------------
;;; void puts(char *str);
;;; ---------------------------------------------
puts:
        push ebp
        mov ebp, esp
        pusha
        mov edi, [ebp + 8]
do_puts_loop:
        mov bl, byte [edi]
        cmp bl, 0
        je do_puts_done
        push ebx
        call putch
        pop ebx
        inc edi
        jmp do_puts_loop
do_puts_done:
        mov eax, [curx]
        push eax
        mov eax,  [cury]
        push eax
        call move_cursor
        add esp, 8
        popa
        pop ebp
        ret

;;; ---------------------------------------------
;;; void clear_screen();
;;; ---------------------------------------------
clear_screen:
        pusha
        cld
        mov edi, VIDEO_OFFSET
        mov cx, 2000
        mov ah, CHAR_ATTRIB
        mov al, ' '
        rep stosw

        mov byte [curx], 0
        mov byte [cury], 0
        push 0
        push 0
        call move_cursor
        add esp, 8
        popa
        ret

;;; ---------------------------------------------
;;; void move_cursor(int x, int y)
;;; ---------------------------------------------
move_cursor:
        push ebp
        mov ebp, esp

        pusha
        mov bl, [ebp + 8]
        mov bh, [ebp + 12]
        xor eax, eax
        mov ecx, COLS
        mov al, bh
        mul ecx
        add al, bl
        mov ebx, eax

        mov al, 0x0f
        mov dx, 0x03d4
        out dx, al

        mov al, bl
        mov dx, 0x03d5
        out dx, al

        xor eax, eax
        mov al, 0x0e
        mov dx, 0x03d4
        out dx, al

        mov al, bh
        mov dx, 0x03d5
        out dx, al

        popa
        pop ebp
        ret
