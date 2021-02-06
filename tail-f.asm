
;to compile: nasm -f elf -o tail-f.o tail-f.asm && ld -m elf_i386 -s -o tail-f tail-f.o

section .text
global _start:
_start:

%macro          __write 3
        mov edx,%3
        mov ecx,%2
        mov ebx,%1
        mov eax,0x4
        int 0x80
%endmacro

%macro          __read 3
        mov edx,%3
        mov ecx,%2
        mov ebx,%1
        mov eax,0x3
        int 0x80
%endmacro

%macro          __brk 0-1
        mov ebx,%1
        mov eax,0x2d
        int 0x80
%endmacro

%macro          __open  1
        xor ecx,ecx
        mov ebx,%1
        mov eax,5
        int 0x80
%endmacro

%macro          __exit 1
        mov ebx,%1
        mov eax,0x1
        int 0x80
%endmacro

%macro          __lseek 2
        mov edx,%2
        xor ecx,ecx
        mov ebx,%1
        mov eax,0x13
        int 0x80
%endmacro

%macro          __nanosleep 1
        mov ebx,%1
        mov eax,162
        int 0x80
%endmacro

        pop ebp

        cmp ebp,0x1
        jle exit

        pop ebp
        pop ebp

        __open ebp
        mov ebp,eax
        __lseek eax, 0x2
        __brk 0x0
        mov esi,eax
        add eax,0x1000
        __brk eax
main:
        __nanosleep tv_sec
        __read ebp, esi, 0x1000
        cmp eax,0x0
        je short main
        __write 0x1, esi, eax
        jmp short main
exit:
        __exit 0x1

section .data

tv_sec          dq              0x1
tv_nsec         dq              0x0
