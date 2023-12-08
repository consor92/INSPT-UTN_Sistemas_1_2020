; Se ingresa un año. La computadora indica si es bisiesto.

        global main              ; ETIQUETAS QUE MARCAN EL PUNTO DE INICIO DE LA EJECUCION
        global _start

        extern printf            ;
        extern scanf             ; FUNCIONES DE C (IMPORTADAS)
        extern exit              ;
        extern gets              ; GETS ES MUY PELIGROSA. SOLO USARLA EN EJERCICIOS BASICOS, JAMAS EN EL TRABAJO!!!

section .bss                     ; SECCION DE LAS VARIABLES

numero:
        resd    1                ; 1 dword (4 bytes)

cadena:
        resb    0x0100           ; 256 bytes

caracter:
        resb    1                ; 1 byte (dato)
        resb    3                ; 3 bytes (relleno)


section .data                    ; SECCION DE LAS CONSTANTES

fmtInt:
        db    "%d", 0            ; FORMATO PARA NUMEROS ENTEROS

fmtString:
        db    "%s", 0            ; FORMATO PARA CADENAS

fmtChar:
        db    "%c", 0            ; FORMATO PARA CARACTERES

fmtLF:
        db    0xA, 0             ; SALTO DE LINEA (LF)



section .text                    ; SECCION DE LAS INSTRUCCIONES
 
leerCadena:                      ; RUTINA PARA LEER UNA CADENA USANDO GETS
        push cadena
        call gets
        add esp, 4
        ret

leerNumero:                      ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push numero
        push fmtInt
        call scanf
        add esp, 8
        ret
    
mostrarCadena:                   ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push cadena
        push fmtString
        call printf
        add esp, 8
        ret

mostrarNumero:                   ; RUTINA PARA MOSTRAR UN NUMERO ENTERO USANDO PRINTF
        push dword [numero]
        push fmtInt
        call printf
        add esp, 8
        ret

mostrarCaracter:                 ; RUTINA PARA MOSTRAR UN CARACTER USANDO PRINTF
        push dword [caracter]
        push fmtChar
        call printf
        add esp, 8
        ret

mostrarSaltoDeLinea:             ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        push fmtLF
        call printf
        add esp, 4
        ret

salirDelPrograma:                ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit

_start:
main:                            ; PUNTO DE INICIO DEL PROGRAMA
	call leerNumero
        mov eax, [numero]
dividirPor4:        
        mov ebx, 4
        xor edx, edx
        div ebx
        cmp edx, 0
        jne imprimirNo
        jmp dividirPor100
dividirPor100:
        mov eax, [numero]
        mov ebx, 100
        xor edx, edx
        div ebx
        cmp edx, 0
        jne imprimirSi
        jmp dividirPor400
dividirPor400:
        mov eax, [numero]
        mov ebx, 400
        xor edx, edx
        div ebx
        cmp edx, 0
        jne imprimirNo
        jmp imprimirSi
imprimirNo:
        mov al, 'N'
        mov [caracter], al
        call mostrarCaracter
        mov al, 'O' 
        mov [caracter], al
        call mostrarCaracter
        jmp finPrograma
imprimirSi:
        mov al, 'S'
        mov [caracter], al
        call mostrarCaracter
        mov al, 'I'
        mov [caracter], al
        call mostrarCaracter
        jmp finPrograma 
finPrograma:
        call mostrarSaltoDeLinea
        jmp salirDelPrograma