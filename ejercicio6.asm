; Se ingresa N. La computadora muestra los primeros N términos de la Secuencia de Connell.
                global main              ; ETIQUETAS QUE MARCAN EL PUNTO DE INICIO DE LA EJECUCION
        global _start

        extern printf            ;
        extern scanf             ; FUNCIONES DE C (IMPORTADAS)
        extern exit              ;
        extern gets              ; GETS ES MUY PELIGROSA. SOLO USARLA EN EJERCICIOS BASICOS, JAMAS EN EL TRABAJO!!!



section .bss                     ; SECCION DE LAS VARIABLES

numero:
        resd    1                ; 1 dword (4 bytes)
        
reservaEax:
        resd    1 
reservaEbx:
        resd    1               
reservaEcx:
        resd    1
reservaEdx:
        resd    1        
        
section .data                    ; SECCION DE LAS CONSTANTES

fmtInt:
        db    "%d", 0            ; FORMATO PARA NUMEROS ENTEROS
        
fmtString:
        db    "%s", 0            ; FORMATO PARA NUMEROS ENTEROS        
        
espacio:
        db     " ",0
        
section .text                    ; SECCION DE LAS INSTRUCCIONES
 
leerNumero:                      ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push numero
        push fmtInt
        call scanf
        add esp, 8
        ret
        
mostrarNumero:                   ; RUTINA PARA MOSTRAR UN NUMERO ENTERO USANDO PRINTF
        mov [reservaEax] , eax
        mov [reservaEbx] , ebx
        mov [reservaEcx] , ecx
        mov [reservaEdx] , edx
        push dword [numero]
        push fmtInt
        call printf
        add esp, 8
        
        push espacio
        push fmtString
        call printf
        add esp, 8
        
        mov eax , [reservaEax] 
        mov ebx , [reservaEbx]
        mov ecx , [reservaEcx]
        mov edx , [reservaEdx]
        
        ret
        
salirPrograma:
        push 0
        call exit          
        
_start:
main:
        mov ebp, esp; for correct debugging 
        call leerNumero
        mov eax, [numero]       ;en eax guardo N
        cmp eax,1
        jl main
        mov ebx, 1              ;ebx voy poniendo los numeros pares/impares
        mov ecx, 1              ;ecx determina la cantidad de veces que hay que escribir los siguientes numeros pares/impares
        mov edx, 0              ;edx es la cantidad efectiva de veces que mostre los siguientes numeros pares/impares
        
inicioBucle:        
        mov [numero], ebx
        call mostrarNumero
        inc edx
        
        ;disminuyo N hasta llegar a 1 y corto el programa
        cmp eax,1               
        je salirPrograma
        dec eax
        
        ;sigo iterando hasta que edx = ecx
        cmp edx,ecx
        jl inicioBucle
        add ebx, 1               ;transformo el impar a par
        
        inc ecx
        mov edx,0               ;reinicio el contador

avanzarPar:            
        mov [numero], ebx
        call mostrarNumero
        inc edx
        
        ;disminuyo N hasta llegar a 1 y corto el programa
        cmp eax,1               
        je salirPrograma
        dec eax
        
        ;sigo iterando hasta que edx = ecx
        add ebx, 2               ;siguiente numero par. Si no debo ir al siguiente par(xq deberia ir al siguiente impar), esto se ejecuta igual. Lo compenso en la linea del sub eax,1
        cmp edx,ecx
        jl avanzarPar
        
reinicioBucle:        
        sub ebx, 1              ;transformo el par a impar
        inc ecx
        mov edx,0               ;reinicio el contador
        
avanzarImpar:
                
        mov [numero], ebx
        call mostrarNumero
        inc edx
        
        ;disminuyo N hasta llegar a 1 y corto el programa
        cmp eax,1               
        je salirPrograma
        dec eax
        
        ;sigo iterando hasta que edx = ecx
        add ebx, 2               ;siguiente numero impar
        cmp edx,ecx
        jl avanzarImpar
        jmp reinicioBucle
        
        