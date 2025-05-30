section .data
    msj_pedir_num1 db "Ingrese el primer numero (16 bits): ", 0
    msj_pedir_num2 db "Ingrese el segundo numero (16 bits): ", 0
    msj_pedir_num3 db "Ingrese el tercer numero (16 bits): ", 0
    msj_resultado db "El resultado es: ", 0
    nueva_linea db 0ah, 0dh, 0 ; Salto de linea

section .bss
    buffer_entrada resb 6 ; Para leer la entrada del usuario (max 5 digitos + CR)
    num1 dw 0
    num2 dw 0
    num3 dw 0
    resultado dw 0

section .text
    global _start

_start:
    ; Pedir y leer el primer numero
    mov dx, msj_pedir_num1
    call imprimir_cadena
    mov dx, buffer_entrada
    mov cx, 5 ; Maximo 5 digitos
    call leer_numero_entrada
    call ascii_a_binario
    mov [num1], ax

    ; Pedir y leer el segundo numero
    mov dx, msj_pedir_num2
    call imprimir_cadena
    mov dx, buffer_entrada
    mov cx, 5
    call leer_numero_entrada
    call ascii_a_binario
    mov [num2], ax

    ; Pedir y leer el tercer numero
    mov dx, msj_pedir_num3
    call imprimir_cadena
    mov dx, buffer_entrada
    mov cx, 5
    call leer_numero_entrada
    call ascii_a_binario
    mov [num3], ax

    ; Realizar la resta: num1 - num2 - num3
    mov ax, [num1]
    sub ax, [num2]
    sub ax, [num3]
    mov [resultado], ax

    ; Mostrar el mensaje "El resultado es: "
    mov dx, msj_resultado
    call imprimir_cadena

    ; Mostrar el resultado (convertir a ASCII y imprimir)
    mov ax, [resultado]
    call binario_a_ascii
    mov dx, buffer_entrada ; buffer_entrada ahora contiene el numero ASCII
    call imprimir_cadena
    mov dx, nueva_linea
    call imprimir_cadena

    ; Salir del programa (DOS)
    mov ah, 4ch
    int 21h

; --- Subrutinas ---

; imprimir_cadena: Imprime una cadena terminada en 0
; Entrada: dx = direccion de la cadena
imprimir_cadena:
    push ax
    push dx
    push si
    mov ah, 09h ; Funcion DOS para imprimir cadena
    int 21h
    pop si
    pop dx
    pop ax
    ret

; leer_numero_entrada: Lee una cadena de entrada del usuario
; Entrada: dx = buffer para almacenar la entrada, cx = longitud maxima
; Salida: buffer_entrada contiene la cadena de entrada
leer_numero_entrada:
    push ax
    push bx
    push cx
    push dx
    mov ah, 0Ah ; Funcion DOS para leer cadena con longitud
    mov byte [dx], cl ; long maxima
    int 21h
    ; Ajustar el puntero para que apunte al inicio de los caracteres leidos
    mov bl, byte [dx+1] ; Numero real de caracteres leidos
    xor bh, bh
    add dx, 2 ; Saltar bytes de longitud y caracteres leidos
    mov byte [dx+bx], 0 ; Terminar la cadena leida con nulo
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; ascii_a_binario: Convierte una cadena ASCII de digitos a un numero binario (16 bits)
; Entrada: dx = puntero a la cadena ASCII
; Salida: ax = valor binario convertido
ascii_a_binario:
    push bx
    push cx
    push dx
    xor ax, ax     ; ax = 0 (resultado)
    xor cx, cx     ; cx = 0 (contador de digitos)
    mov bx, 10     ; bx = 10 (base para multiplicacion)

.loop_conversion:
    mov cl, [dx]   ; cl = caracter actual
    cmp cl, 0      ; Si es nulo, hemos terminado
    je .fin_conversion
    sub cl, '0'    ; Convertir caracter a digito (ej. '5' -> 5)
    xor ch, ch     ; Limpiar ch (para usar cx como 16 bits)
    mul bx         ; ax = ax * 10
    add ax, cx     ; ax = ax + digito
    inc dx         ; Siguiente caracter
    jmp .loop_conversion

.fin_conversion:
    pop dx
    pop cx
    pop bx
    ret

; binario_a_ascii: Convierte un numero binario (16 bits) a una cadena ASCII
; Entrada: ax = numero binario
; Salida: buffer_entrada contiene la cadena ASCII del numero
binario_a_ascii:
    push bx
    push cx
    push dx
    push si
    mov cx, 0      ; Contador de digitos
    mov bx, 10     ; Divisor

    mov si, buffer_entrada + 5 ; Empezar a escribir desde el final del buffer (para los digitos)
    mov byte [si], 0 ; Terminador nulo

.loop_division:
    xor dx, dx     ; Limpiar dx para div (dx:ax / bx)
    div bx         ; ax = ax / 10, dx = ax % 10 (resto)
    add dl, '0'    ; Convertir resto a caracter ASCII
    dec si         ; Mover puntero hacia el inicio
    mov [si], dl   ; Guardar caracter
    inc cx         ; Incrementar contador de digitos
    cmp ax, 0      ; Si ax es 0, terminamos
    jnz .loop_division

    ; Mover los digitos al inicio del buffer si no se escribio desde ahi
    mov di, buffer_entrada
    mov al, byte [si] ; Si el primer digito es '0' y es el unico, dejarlo
    cmp al, '0'
    je .skip_copy_single_zero
    ; Solo copiar si no es un unico '0'
    mov cx, 0FFFFh ; Contar hasta que se encuentre el nulo
    xor ax, ax
    cld            ; Direccion hacia adelante
    repne scasb    ; Buscar el nulo
    not cx         ; cx = longitud de la cadena
    dec cx         ; Excluir el nulo
    mov si, si     ; si ya apunta al inicio de los digitos validos
    mov di, buffer_entrada
    mov ax, cx
    mov cx, 0      ; Limpiar cx para movsw
    mov cl, al     ; cx = longitud para copiar
    rep movsb      ; Copiar los digitos al inicio del buffer

.skip_copy_single_zero:
    mov byte [di], 0 ; Asegurar que el buffer esta terminado con nulo
    pop si
    pop dx
    pop cx
    pop bx
    ret