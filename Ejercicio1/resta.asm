section .data
    msg1 db 'Escriba primer numero: ', 0
    msg2 db 'Escriba segundo numero: ', 0
    msg3 db 'Escriba tercer numero: ', 0
    res_msg db 'Resultado: ', 0
    newline db 10, 0

section .bss
    buffer resb 5
    num1 resw 1
    num2 resw 1
    num3 resw 1
    result resw 1

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 24
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 5
    int 0x80
    call atoi
    mov [num1], ax

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 25
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 5
    int 0x80
    call atoi
    mov [num2], ax

    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, 24
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 5
    int 0x80
    call atoi
    mov [num3], ax

    mov ax, [num1]
    sub ax, [num2]
    sub ax, [num3]
    mov [result], ax

    mov eax, 4
    mov ebx, 1
    mov ecx, res_msg
    mov edx, 10
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
.next:
    mov bl, [esi]
    cmp bl, 10
    je .done
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    jmp .next
.done:
    ret

itoa:
    mov edi, buffer
    add edi, 4
    mov byte [edi], 0
    mov ax, [result]
    mov bx, 10
.reverse:
    dec edi
    xor dx, dx
    div bx
    add dl, '0'
    mov [edi], dl
    test ax, ax
    jnz .reverse
    ret