section .data
    msg1 db 'Escriba numero 1 (0-255): ',0
    msg2 db 'Escriba numero 2 (0-255): ',0
    result_msg db 'Resultado: ',0
    newline db 10,0

section .bss
    num1 resb 1
    num2 resb 1
    buffer resb 5

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 27
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 5
    int 0x80
    call atoi
    mov [num1], al

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 27
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 5
    int 0x80
    call atoi
    mov [num2], al

    mov al, [num1]
    mov bl, [num2]
    mul bl
    mov [num1], ax

    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 11
    int 0x80

    call itoa
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 5
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80

atoi:
    xor eax, eax
    xor ebx, ebx
    mov esi, buffer
.convert:
    mov bl, [esi]
    cmp bl, 10
    je .done
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    jmp .convert
.done:
    ret

itoa:
    mov edi, buffer
    add edi, 4
    mov byte [edi], 0
    mov ax, [num1]
    mov bx, 10
.convert_loop:
    dec edi
    xor dx, dx
    div bx
    add dl, '0'
    mov [edi], dl
    test ax, ax
    jnz .convert_loop
    ret