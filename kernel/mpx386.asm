;;; name: mpx386.asm
;;; author: loulanguju
;;; time: 2013-8-27
        K_STACK_BYTES   EQU 1024
        GDT_SELECTOR    EQU 0x08
        CS_SELECTOR     EQU 0x08
        [section .text]
        extern gdt
        extern gdtr
        extern idt
        extern idtr
        extern irq_hooks
        extern intr_handle
        extern ker_call
        extern cstart
        extern main

        global intr00
        global intr01
        global intr12
        global k_call
        global test
kernel_begin:
kernel_length dw 0
_start:
        jmp _main
_main:
        sgdt [gdtr]
        mov esi, [gdtr + 2]
        mov ebx, gdt
        mov ecx, 3*8
copygdt:
        mov al, [esi]
        mov [ebx], al
        inc esi
        inc ebx
        loop copygdt
        mov eax, [gdt + CS_SELECTOR + 2]
        and eax, 0x00ffffff
        add eax, gdt
        mov [gdtr + 2], eax
        lgdt [gdtr]

        mov ax, ds
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax
        mov esp, k_stktop       ; set sp to point to the kernel stack

        push cs
        push ds
        call cstart
        add esp, 4 * 2

        ;; reload gdtr, idtr and the segment
        mov eax, idt
        mov [idtr+2], eax
        lgdt [gdtr]
        lidt [idtr]

        mov ax, ds
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax
        jmp  main

        jmp $

intr00:
        cld
        pusha
        push ds
        push es
        push fs
        push gs
        mov eax, esp
        push eax
        mov ax, ss
        mov ds, ax
        mov es, ax

        mov eax, irq_hooks + 8 * 0
        push eax
        call intr_handle
        pop ecx

        pop eax
        pop gs
        pop fs
        pop es
        pop ds
        popa
        iret

 intr01:
        cld
        pusha
        push ds
        push es
        push fs
        push gs
        mov eax, esp
        push eax
        mov ax, ss
        mov ds, ax
        mov es, ax

        mov eax, irq_hooks + 8 * 1
        push eax
        call intr_handle
        pop ecx

        pop eax
        pop gs
        pop fs
        pop es
        pop ds
        popa
        iret

 intr12:
        cld
        pusha
        push ds
        push es
        push fs
        push gs
        mov eax, esp
        push eax
        mov ax, ss
        mov ds, ax
        mov es, ax

        mov eax, irq_hooks + 8 * 12
        push eax
        call intr_handle
        pop ecx

        pop eax
        pop gs
        pop fs
        pop es
        pop ds
        popa
        iret

k_call:
        cld
        pusha
        push ds
        push es
        push fs
        push gs
        mov edx, esp
        push edx
        mov ax, ss
        mov ds, ax
        mov es, ax

        push eax
        push ebx
        push ecx
        call ker_call
        add esp, 4 * 3

        pop edx
        pop gs
        pop fs
        pop es
        pop ds
        popa
        iret

test:
        pusha
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        int 0x23
        popa
        ret
        [section .bss]
k_stack:        resb K_STACK_BYTES   ;kernel stac
k_stktop:                                ;top of kernel stack
kernel_end:
