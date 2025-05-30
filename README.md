# PH23011 - Portafolio de ejercicios en ensamblador

Este repositorio contiene tres ejercicios desarrollados en lenguaje ensamblador, enfocados en operaciones aritmeticas utilizando diferentes tamaños de registros.

Cada ejercicio esta organizado en su propia carpeta (`Ejercicio1`, `Ejercicio2`, `Ejercicio3`) y fue probado en entorno Linux usando NASM.

## Ejercicios

### 1. Resta de tres enteros
**Ruta:** `Ejercicio1/`

Este programa solicita al usuario tres numeros enteros y realiza la resta (n1 - n2 - n3). Utiliza registros de 16 bits 

### 2. Multiplicacion
**Ruta:** `Ejercicio2/`

Este programa solicita dos numeros enteros en el rango de 0 a 255, realiza la multiplicacion y muestra el resultado. Utiliza registros de 8 bits 

### 3. Division
**Ruta:** `Ejercicio3/`

Este programa solicita un dividendo y un divisor, realiza una division entera y muestra tanto el cociente como el residuo. Utiliza registros de 32 bits 

## Requisitos

- NASM
- Linux o WSL
- Visual Studio Code o editor de texto

## Compilacion y ejecucion

Para compilar y ejecutar un ejercicio:

```bash
nasm -f elf32 archivo.asm -o archivo.o
ld -m elf_i386 archivo.o -o archivo
./archivo