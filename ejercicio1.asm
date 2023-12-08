;Dado un entero N, la computadora lo muestra descompuesto en sus factores primos. Ej: 132 = 2 × 2 × 3 × 11
global main
global _start
extern printf 
extern scanf
extern exit

section .bss

numero:
    resd    1                ; 1 dword (4 bytes)

antesDivision:
    resd    1        
        
contadorImpresiones:
    resd 1
         
contadorExponentes:
    resd 1 


primo:
    resd 1
    
caracter:
    resb 1
    resb 3    
    
section .data

fmtInt:
        db    "%d", 0            ; FORMATO PARA NUMEROS ENTEROS

fmtChar:
    db "%c", 0
  
    
section .text

leerNumero:                      ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push numero				;pongo numero en la pila
        push fmtInt				;pongo el "%d" en la pila
        call scanf
        add esp, 8
        ret
        
mostrarNumero: ; RUTINA PARA MOSTRAR UN NUMERO ENTERO USANDO PRINTF
        push dword [numero]
        push fmtInt
        call printf
        add esp, 8
        ret
    
mostrarNumeroPrimo:
    push dword [primo] ;es el contenido en la direccion numero
    push fmtInt
    call printf
    add esp,8
    ret     
    
mostrarCaracter:
    push dword [caracter] ;es el contenido en la direcc caracter        
    push fmtChar
    call printf
    add esp,8
    ret
    
salirDelPrograma:
    push 0
    call exit   

descomponerEnPrimos:
    mov dword [primo], 2     ; inicializo el divisor en 2 (primer numero primo)
    mov ebx,2
    mov dword [caracter], 'x'
    mov ecx, 0              ; inicializo el contador de exponentes en 0

   bucle_division:
    mov ebx, [primo]
    cmp eax, ebx            ; comparo el numero con el divisor
    jge  segunda_parte   ; si el numero es menor que el divisor, termina el bucle
    ret 
segunda_parte:    
    mov edx, 0              ; limpio el registro de residuo
    mov [antesDivision] , eax ; me guardo eax porque si la resta tiene residuo, debo revertir el valor divido
    div ebx                 ; eax = eax / ebx, (edx el residuo)

    cmp edx, 0              ; verifico si hay residuo
    jne siguiente_primo     ; si hay residuo, paso al siguiente número primo (ademas revierto la division)

    inc ecx                 ; incremento el contador de exponentes
    jmp bucle_division      ; vuelve a realizar la división con el mismo divisor

siguiente_primo:
    mov eax , [antesDivision] ;revierto la division
    mov ebx, dword [primo]
    cmp ebx,2
    je primo3
    cmp ebx,3  
    je primo5
    cmp ebx,5
    je primo7
    cmp ebx,7
    je primo11
    cmp ebx,11
    je primo13
    cmp ebx,13
    je primo17
    cmp ebx,17
    je primo19
    cmp ebx,19
    je primo23             
    jmp bucle_division     ; dado que no puedo generar los numeros primos, el maximo es 23
   

mostrarCadenaParcial:
    cmp ecx,0 ;si el contador de exponentes es cero, no imprimoo nada
    je fin_bucle_interno
    mov edx,0; edx contador de veces que imprimi PRIMOx
    mov [numero] , eax ;guardo eax porque printf lo borra
    
bucle_interno:
    mov [contadorImpresiones],edx ;guardo edx porque printf lo borra
    mov [contadorExponentes],ecx ;guardo ecx porque printf lo borra
    call mostrarNumeroPrimo
    call mostrarCaracter
    mov edx,[contadorImpresiones];recupero edx
    mov ecx,[contadorExponentes];recupero ecx
    inc edx
    cmp edx,ecx
    jne bucle_interno
   
fin_bucle_interno:    
    mov eax, [numero] ;recupero eax
    ret    
    
primo3:
    call mostrarCadenaParcial
    mov ecx,0 ;reinicio el contador de exponentes
    mov dword [primo] ,3
    jmp bucle_division
    
primo5:
    call mostrarCadenaParcial
    mov ecx,0 ;reinicio el contador de exponentes
    mov dword [primo] ,5
    jmp bucle_division

primo7:
    call mostrarCadenaParcial
    mov ecx,0 ;reinicio el contador de exponentes
     mov dword [primo] ,7
    jmp bucle_division
 
primo11:
    
    call mostrarCadenaParcial
    mov dword [primo] ,11
    jmp bucle_division             

primo13:
    
    call mostrarCadenaParcial
    mov dword [primo] ,13
    jmp bucle_division

primo17:
    
    call mostrarCadenaParcial
    mov dword [primo] ,17
    jmp bucle_division

primo19:
    
    call mostrarCadenaParcial
    mov dword [primo] ,19
    jmp bucle_division

primo23:
    
    call mostrarCadenaParcial
    mov dword [primo] ,23
    jmp bucle_division                 
    
           
_start:
main:
    mov ebp, esp; for correct debugging
    call leerNumero
    mov eax, [numero]
    call descomponerEnPrimos
    call mostrarCadenaParcial
    call salirDelPrograma    