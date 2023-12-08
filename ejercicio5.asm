;Se ingresan 100 caracteres. La computadora los muestra ordenados sin repeticiones.
global main              ; ETIQUETAS QUE MARCAN EL PUNTO DE INICIO DE LA EJECUCION
global _start

extern printf            ;
extern scanf             ; FUNCIONES DE C (IMPORTADAS)
extern exit              ;

section .bss

caracter:
        resb    1
        resb    3
        
cadena:
        resb 101
        
acumulador:
        resd    1
        
posicionPrimerCaracter:
        resd    1
        
posicionSegundoCaracter:
        resd    1                                
            
section .data

fmtChar:
        db    "%c", 0            ; FORMATO PARA CARACTERES
        
fmtString:
        db    "%s", 0            ; FORMATO PARA CADENAS        

       
section .text                      
        
mostrarCadena:   
        push cadena
        push fmtString
        call printf
        add esp, 8
        ret       

_start:
main:
        mov ebp, esp; for correct debugging
        mov edi,0
        mov esi,0
        
leerChar:                      ; RUTINA PARA LEER UNA CADENA USANDO GETS
        push caracter
        push fmtChar
        call scanf
        add esp, 8
        
cargarCadena:
        mov al, byte [caracter]
        cmp al,10                                       ;si hay un enter ('\n' = 10), lo salteo y no lo cargo a cadena
        je saltear
        cmp al,32
        je saltear                                      ;idem con el espacio (' ' = 32)
        mov [esi+cadena] , al
        inc esi

saltear:        
        inc edi
        cmp edi,15
        jl leerChar
        
        ;arranco a ordenar la cadena (hago bubble sort, o sea recorro la cadena 100 veces pasando por cada caracter)
        
        mov ebx,0                                       ;limpio ebx
        mov dword[acumulador],0                                              
        
bucleInicial:

        mov ecx, 1                                      ;acumulador de veces que recorrí la cadena
        mov edx,0
        
bucleSecundario:
        mov al, [edx + cadena] ;edx
        mov bl, [ecx + cadena] ;ecx
        
        cmp al, bl
        jbe sinCambio
        
        ;intercambio caracteres
        mov [edx + cadena], bl
        mov [ecx + cadena], al
        
sinCambio:
        inc ecx
        inc edx
        
        cmp ecx, esi
        jl bucleSecundario
        
        inc dword[acumulador]
        mov ecx, dword[acumulador]
        cmp ecx, esi
        
        jl bucleInicial       
                
;Vuelvo a recorrer la cadena ordenada para eliminar duplicados
                               
        mov edx,0
        mov ecx, 1 

inicioEliminar:
                 
        mov al, [edx + cadena] 
        mov bl, [ecx + cadena] 
        
        cmp al, bl
        jne avanzarSinEliminar
        mov [posicionPrimerCaracter],edx          ;me guardo las posiciones en la que estoy antes de iniciar el proceso de eliminación
        mov [posicionSegundoCaracter],ecx
bucleInterno:        
        inc edx
        inc ecx
        ;hago el swap
        mov al, [edx + cadena] 
        mov bl, [ecx + cadena]
        mov [edx + cadena], bl
        mov [ecx + cadena], al
        cmp ecx,esi
        jl bucleInterno
        mov dword [esi + cadena],0
        dec esi
        mov edx, [posicionPrimerCaracter]
        mov ecx, [posicionSegundoCaracter]
        dec ecx                                    ;si eliminé, debo revertir el inc de la linea 137 y 138 ya que NO quiero avanzar sino vovler a comparar.
        dec edx
        
avanzarSinEliminar:                
        inc ecx
        inc edx
        cmp ecx, esi
        jl inicioEliminar
        
        call mostrarCadena 
        push 0
        call exit
             
                                
        