list p=16F887 ;Indica el tipo de Microcontrolador a utilizar
INCLUDE "p16F887.inc" ;Incluye en el programa el fichero de las definiciones del microcontrolador
__CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_OFF & _FCMEN_ON & _LVP_ON
__CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
;ORIGEN
ORG 0x00
;VARIABLES
    V1 equ 0x20; OCUPADA CON CICLOS DE PARPADEO
    V2 equ 0x21
    V3 equ 0x22; preguntas
    V4 equ 0x23
    V5 equ 0x24
    V6 equ 0x25
    V7 equ 0x26
;;;;;;;;;;;;;;;CONFIGURACIÓN DE PUERTOS;;;;;;;;;;;;;;;;;;;;;;;
BANKSEL OSCCON
MOVLW 0x71
MOVWF OSCCON
CLRW
BANKSEL PORTA
CLRF PORTA
BANKSEL ANSEL
CLRF ANSEL
BANKSEL TRISA
MOVLW 0xFF ;SE CONFIGURA PUERTO A COMO ENTRADAS DIGITALES
MOVWF TRISA
BANKSEL PORTB
CLRF PORTB
BANKSEL TRISB
MOVLW 0x00 ;SE CONFIGURA PUERTO B COMO SALIDAS
MOVWF TRISB
BANKSEL PORTC
CLRF PORTC
BANKSEL TRISC
MOVLW 0x00 ;SE CONFIGURA PUERTO C COMO SALIDAS
MOVWF TRISC
BANKSEL PORTC
;;;;;;;;;;;;;;;INICIO PROGRAMA;;;;;;;;;;;;;;;;;;;
INICIO
    BANKSEL PORTA
    CALL RETARDO3
    MOVF PORTA,0 ;LEE VALOR DE PORTA Y ASIGNA AL REGISTRO W
    ANDLW 0x03 ; REALIZA UNA OPERACIÓN AND ENTRE EL VALOR Y EL REGISTRO W
    MOVWF V3 ; MUEVE EL VALOR AL REGISTRO INDICADO
    CALL PREGUNTA0
    CALL PREGUNTA1
    CALL PREGUNTA2
    CALL SEMAFOROSOLO
    GOTO INICIO
;;;;;;;;;;;;;BUCLE SEMAFORO SIN PULSOS;;;;;;;;;;;;
SEMAFOROSOLO
    ;PRENDIDO VERDE 1 Y ROJO2 POR 10S
    MOVLW 0X01
    MOVWF PORTB
    MOVLW 0X04
    MOVWF PORTC
    CALL RETARDO1
    ; 4 PARPADEOS VERDE1 Y PRENDIDO ROJO2
    MOVLW 0X03
    MOVWF V1
    CICLOPARPADEO
        CALL PARPADEO1
        DECFSZ V1,1 ;DECREMENTA VALOR F EN 1 HASTA CERO
        GOTO CICLOPARPADEO
    ;PRENDIDO AMARILLO1 Y ROJO2 3S
    MOVLW 0X02
    MOVWF PORTB
    MOVLW 0X04
    MOVLW PORTC
    CALL RETARDO3
    ;PRENDIDO ROJO1 Y VERDE2 10S
    MOVLW 0X04
    MOVWF PORTB
    MOVLW 0X01
    MOVWF PORTC
    CALL RETARDO1
    ; PARPADEO VERDE2 Y PRENDIDO ROJO1
    MOVLW 0X03
    MOVWF V1
    CICLOP2
        CALL PARPADEO2
        DECFSZ V1,1 ;DECREMENTA VALOR F EN 1 HASTA CERO
        GOTO CICLOP2
    ;PRENDIDO AMARILLO2 Y ROJO1 3S
    MOVLW 0X02
    MOVWF PORTC
    MOVLW 0X04
    MOVLW PORTB
    CALL RETARDO3
    ;BUCLE
    GOTO INICIO
;;;;;;;;;;;;;;PREGUNTA 0;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PREGUNTA0
    MOVLW 0x03
    SUBWF V3,0 ;SUBSTRAE W DE F
    BTFSS STATUS,2 ;ZERO BIT, 1 RESULTADO ARITMETICO DE UNA OPERACIÓN ES CERO
    RETURN; ZERO BIT, 0 RESULTADO ARIMETICO DE UNA OPERACIÓN IGUAL NO ES CERO
    GOTO SEMAFOROSOLO
;;;;;;;;;;;;;;PREGUNTA 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PREGUNTA1
    BTFSS V3,0 ;ANALIZA F, SALTA LA SIGUIENTE OPERACIÓN SI ES UNO
    RETURN
    CALL PVERDE1
    RETURN
;;;;;;;;;;;;;;PREGUNTA 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PREGUNTA2
    BTFSS V3,1 ;ANALIZA F, SALTA LA SIGUIENTE OPERACIÓN SI ES UNO
    RETURN
    CALL PVERDE2
    RETURN
;;;;;;;;;;;;;;;PAUSA VERDE 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PVERDE1
    MOVLW 0X01
    MOVWF PORTB
    MOVLW 0X04
    MOVWF PORTC
    GOTO INICIO
;;;;;;;;;;;;;;;PAUSA VERDE 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PVERDE2
    MOVLW 0X04
    MOVWF PORTB
    MOVLW 0X01
    MOVWF PORTC
    GOTO INICIO
;;;;;;;;;;;;;;PARPADEO VERDE 1;;;;;;;;;;;;;;;;;;;;;;;;;
PARPADEO1
    MOVLW 0X00
    MOVWF PORTB
    MOVLW 0X04
    MOVWF PORTC
    CALL RETARDO2
    MOVLW 0X01
    MOVWF PORTB
    MOVLW 0X04
    MOVFW PORTC
    CALL RETARDO2
    RETURN
;;;;;;;;;;;;PARPADEO VERDE 2;;;;;;;;;;;;;;;;;;;;;;;;;;;
PARPADEO2
    MOVLW 0X00
    MOVWF PORTC
    MOVLW 0X04
    MOVWF PORTB
    CALL RETARDO2
    MOVLW 0X01
    MOVWF PORTC
    MOVLW 0X04
    MOVWF PORTB
    CALL RETARDO2
    RETURN
;;;;;;;;;;;;;;;RETARDO 1 10S ;;;;;;;;;;;;;;;;;;;;;;;;;;
RETARDO1
    MOVLW 0x2F
    MOVWF V5
    MOVLW 0xFF;FC
    MOVWF V6
    MOVLW 0xFF;FC
    MOVWF V7
    PrimerDec1
        DECFSZ V6,1
        GOTO PrimerDec1
            SegundoDec1
                MOVLW 0xFF;FC
                MOVWF V6
                DECFSZ V7,1
                GOTO PrimerDec1
                    TercerDec1
                        MOVLW 0xFF;FC
                        MOVWF V7
                        DECFSZ V5,1
                        GOTO SegundoDec1
                        RETURN
;;;;;;;;;;;;;;;;;;;;;;;RETARDO 2 1 SEGUNDO;;;;;;;;;;;;;;;;;;;;;;;;;
RETARDO2
    MOVLW 0x05
    MOVWF V5
    MOVLW 0xFF;FC
    MOVWF V6
    MOVLW 0xFF;FC
    MOVWF V7
    PrimerDec2
        DECFSZ V6,1
        GOTO PrimerDec2
            SegundoDec2
                MOVLW 0xFF;FC
                MOVWF V6
                DECFSZ V7,1
                GOTO PrimerDec2
                    TercerDec2
                        MOVLW 0xFF;FC
                        MOVWF V7
                        DECFSZ V5,1
                        GOTO SegundoDec2
                        RETURN
;;;;;;;;;;;;;;;;;;;;;;;RETARDO 3 3 SEGUNDOS;;;;;;;;;;;;;;;;;;;;;;;;;
RETARDO3
    MOVLW 0x10
    MOVWF V5
    MOVLW 0xFF;FC
    MOVWF V6
    MOVLW 0xFF;FC
    MOVWF V7
    PrimerDec3
        DECFSZ V6,1
        GOTO PrimerDec3
            SegundoDec3
                MOVLW 0xFF;FC
                MOVWF V6
                DECFSZ V7,1
                GOTO PrimerDec3
                    TercerDec3
                        MOVLW 0xFF;FC
                        MOVWF V7
                        DECFSZ V5,1
                        GOTO SegundoDec3
                        RETURN
END