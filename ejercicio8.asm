;Se ingresa una matriz de NxN componentes enteras. La computadora muestra la matriz transpuesta
global main              ; ETIQUETAS QUE MARCAN EL PUNTO DE INICIO DE LA EJECUCION
        global _start

        extern printf            ;
        extern scanf             ; FUNCIONES DE C (IMPORTADAS)
        extern exit              ;
        extern gets              ; GETS ES MUY PELIGROSA. SOLO USARLA EN EJERCICIOS BASICOS, JAMAS EN EL TRABAJO!!!



section .bss                     ; SECCION DE LAS VARIABLES

numero:
        resd    1                ; 1 dword (4 bytes)

contador:
        resd    1                

cadena:
        resb    0x0100           ; 256 bytes

caracter:
        resb    1                ; 1 byte (dato)
        resb    3                ; 3 bytes (relleno)

matriz:
	resd	100		 ;  matriz como maximo de 10x10

matrizTras:
        resd    100
        
distancia:
        resd    1        
		
n:
	resd	1		 ;  lado de la matriz (cuadrada)

f:
	resd	1		 ; fila
		
c:
	resd	1		 ; columna

posInicial:
        resd    1

section .data                    ; SECCION DE LAS CONSTANTES

fmtInt:
        db    "%d", 0            ; FORMATO PARA NUMEROS ENTEROS

fmtString:
        db    "%s", 0            ; FORMATO PARA CADENAS

fmtChar:
        db    "%c", 0            ; FORMATO PARA CARACTERES
        
fmtTab:
        db 0x09, 0               ; espacio en ASCII ('32')        

fmtLF:
        db    0xA, 0             ; SALTO DE LINEA (LF)

nStr:
	db    "N: ", 0		 ; Cadena "N: "

filaStr:
	db    "Fila:", 0	 ;  Cadena "Fila:"
	
columnaStr:
	db    " Columna:", 0	 ;  Cadena "Columna:"

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
        
mostrarValorDeMatrizTras:
        push dword [matrizTras+esi]
        push fmtInt
        call printf
        add esp, 8
        add esi, 4
        push fmtTab
        call printf
        add esp, 4
        ret        

salirDelPrograma:                ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit

_start:
main:
    mov ebp, esp; for correct debugging                            ; PUNTO DE INICIO DEL PROGRAMA
	mov esi, 0
	mov ebx, 0
copiaAcadena1:
	mov al, [ebx+nStr]         ;copio lo que hay en nStr+0 , nStr+1, etc hasta leer un 0 (o sea fin de la cadena)
	mov [ebx+cadena], al
	inc ebx
	cmp al, 0
	jne copiaAcadena1
	call mostrarCadena         ;una vez copiada, la muestro y leo el numero maximo de la matriz NxN
	call leerNumero
		
	mov eax, [numero]
	cmp eax, 0
	jg seguir1                 ;si lo leido no es un cero, entonces avanzo
	jmp main
seguir1:
	cmp eax, 11
	jl seguir2                 ;verifico que no sea mayor a 10 tampoco
	jmp main
seguir2:		
	mov [n], eax               ;
		
	mov [f], dword 0
proximoF:
	mov [c], dword 0
proximoC:
	mov ebx, 0
copiaAcadena2:
	mov al, [ebx+filaStr]
	mov [ebx+cadena], al
	inc ebx
	cmp al, 0
	jne copiaAcadena2
	call mostrarCadena
		
	mov eax, [f]
	mov [numero], eax
	call mostrarNumero
	
	mov ebx, 0
copiaAcadena3:
	mov al, [ebx+columnaStr]
	mov [ebx+cadena], al
	inc ebx
	cmp al, 0
	jne copiaAcadena3
	call mostrarCadena

	mov eax, [c]
	mov [numero], eax
	call mostrarNumero

	mov eax, 32
	mov [caracter], eax
	call mostrarCaracter
	call mostrarCaracter
	call leerNumero
	mov eax, [numero]
	mov [esi+matriz], eax
	add esi, 4
		
	inc dword [c]
	mov eax, [c]
	cmp eax, [n]
	jb proximoC
		
	inc dword [f]
	mov eax, [f]
	cmp eax, [n]
	jb proximoF

	call mostrarSaltoDeLinea
	
	;arranco a cargar la matriz traspuesta
        mov eax, [n]
        imul eax, 4
        mov [distancia], eax
        
        mov dword [posInicial],0
        
        mov eax, 0
        
        mov esi, 0
        mov ebx, 0
        mov ecx, 0
        
avanzar:
        mov edx, [matriz+eax]
        mov [matrizTras+esi], edx
        add eax, [distancia]            ;para el proximo bucle
        add esi,4
        inc ebx
        cmp ebx, [n]
        jl avanzar
        mov ebx, 0
        inc ecx
        mov eax, [posInicial]
        add eax, 4
        mov [posInicial], eax
        cmp ecx, [n]
        jl avanzar
        
        ;muestro la matriz
        mov esi,0
        mov dword [contador], 0
        call mostrarSaltoDeLinea
        mov dword [numero], 0        ;reciclo variables
mostrar:        
        call mostrarValorDeMatrizTras
        inc dword [numero]
      	mov eax, [n]
        cmp [numero], eax
        jl mostrar
        call mostrarSaltoDeLinea
        inc dword [contador]
        mov eax, [n]
        cmp [contador], eax
        mov  dword [numero], 0

        jl mostrar
        	
        jmp salirDelPrograma
        
                
        
        
        