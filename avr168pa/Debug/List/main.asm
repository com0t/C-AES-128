
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega168A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega168A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index0=R4
	.DEF _rx_rd_index0=R3
	.DEF _rx_counter0=R6

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_sbox:
	.DB  0x63,0x7C,0x77,0x7B,0xF2,0x6B,0x6F,0xC5
	.DB  0x30,0x1,0x67,0x2B,0xFE,0xD7,0xAB,0x76
	.DB  0xCA,0x82,0xC9,0x7D,0xFA,0x59,0x47,0xF0
	.DB  0xAD,0xD4,0xA2,0xAF,0x9C,0xA4,0x72,0xC0
	.DB  0xB7,0xFD,0x93,0x26,0x36,0x3F,0xF7,0xCC
	.DB  0x34,0xA5,0xE5,0xF1,0x71,0xD8,0x31,0x15
	.DB  0x4,0xC7,0x23,0xC3,0x18,0x96,0x5,0x9A
	.DB  0x7,0x12,0x80,0xE2,0xEB,0x27,0xB2,0x75
	.DB  0x9,0x83,0x2C,0x1A,0x1B,0x6E,0x5A,0xA0
	.DB  0x52,0x3B,0xD6,0xB3,0x29,0xE3,0x2F,0x84
	.DB  0x53,0xD1,0x0,0xED,0x20,0xFC,0xB1,0x5B
	.DB  0x6A,0xCB,0xBE,0x39,0x4A,0x4C,0x58,0xCF
	.DB  0xD0,0xEF,0xAA,0xFB,0x43,0x4D,0x33,0x85
	.DB  0x45,0xF9,0x2,0x7F,0x50,0x3C,0x9F,0xA8
	.DB  0x51,0xA3,0x40,0x8F,0x92,0x9D,0x38,0xF5
	.DB  0xBC,0xB6,0xDA,0x21,0x10,0xFF,0xF3,0xD2
	.DB  0xCD,0xC,0x13,0xEC,0x5F,0x97,0x44,0x17
	.DB  0xC4,0xA7,0x7E,0x3D,0x64,0x5D,0x19,0x73
	.DB  0x60,0x81,0x4F,0xDC,0x22,0x2A,0x90,0x88
	.DB  0x46,0xEE,0xB8,0x14,0xDE,0x5E,0xB,0xDB
	.DB  0xE0,0x32,0x3A,0xA,0x49,0x6,0x24,0x5C
	.DB  0xC2,0xD3,0xAC,0x62,0x91,0x95,0xE4,0x79
	.DB  0xE7,0xC8,0x37,0x6D,0x8D,0xD5,0x4E,0xA9
	.DB  0x6C,0x56,0xF4,0xEA,0x65,0x7A,0xAE,0x8
	.DB  0xBA,0x78,0x25,0x2E,0x1C,0xA6,0xB4,0xC6
	.DB  0xE8,0xDD,0x74,0x1F,0x4B,0xBD,0x8B,0x8A
	.DB  0x70,0x3E,0xB5,0x66,0x48,0x3,0xF6,0xE
	.DB  0x61,0x35,0x57,0xB9,0x86,0xC1,0x1D,0x9E
	.DB  0xE1,0xF8,0x98,0x11,0x69,0xD9,0x8E,0x94
	.DB  0x9B,0x1E,0x87,0xE9,0xCE,0x55,0x28,0xDF
	.DB  0x8C,0xA1,0x89,0xD,0xBF,0xE6,0x42,0x68
	.DB  0x41,0x99,0x2D,0xF,0xB0,0x54,0xBB,0x16
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0

_0x0:
	.DB  0xD,0xA,0x50,0x6C,0x61,0x69,0x6E,0x74
	.DB  0x20,0x54,0x65,0x78,0x74,0x3A,0x20,0x0
	.DB  0x25,0x58,0x20,0x0,0xD,0xA,0x4B,0x65
	.DB  0x79,0x3A,0x20,0x0,0xD,0xA,0x9,0x57
	.DB  0x61,0x74,0x74,0x69,0x6E,0x67,0x20,0x45
	.DB  0x6E,0x63,0x72,0x79,0x70,0x74,0x20,0x21
	.DB  0x21,0x21,0x0,0xD,0xA,0x43,0x69,0x70
	.DB  0x68,0x65,0x72,0x20,0x54,0x65,0x78,0x74
	.DB  0x3A,0x20,0x0,0xD,0xA,0x9,0x45,0x6E
	.DB  0x64,0x20,0x45,0x6E,0x63,0x72,0x79,0x70
	.DB  0x74,0x20,0x41,0x45,0x53,0x2D,0x31,0x32
	.DB  0x38,0x20,0x21,0x21,0x21,0xD,0xA,0x0
	.DB  0xD,0xA,0x4E,0x55,0x4C,0x4C,0xD,0xA
	.DB  0x0
_0x20003:
	.DB  0x1,0x2,0x4,0x8,0x10,0x20,0x40,0x80
	.DB  0x1B,0x36

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _rcon
	.DW  _0x20003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : AES-128
;Version : 1.0
;Date    : 1/26/2018
;Author  : Khang
;Company : NoTime
;Comments:
;
;
;Chip type               : ATmega168A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega168a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;
;// Declare your global variables here
;
;#define DATA_REGISTER_EMPTY (1<<UDRE0)
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE0 43
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0=0,rx_rd_index0=0;
;#else
;unsigned int rx_wr_index0=0,rx_rd_index0=0;
;#endif
;
;#if RX_BUFFER_SIZE0 < 256
;unsigned char rx_counter0=0;
;#else
;unsigned int rx_counter0=0;
;#endif
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0036 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0037 char status,data;
; 0000 0038 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 0039 data=UDR0;
	LDS  R16,198
; 0000 003A if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 003B    {
; 0000 003C    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 003D #if RX_BUFFER_SIZE0 == 256
; 0000 003E    // special case for receiver buffer size=256
; 0000 003F    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 0040 #else
; 0000 0041    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(43)
	CP   R30,R4
	BRNE _0x4
	CLR  R4
; 0000 0042    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x4:
	INC  R6
	LDI  R30,LOW(43)
	CP   R30,R6
	BRNE _0x5
; 0000 0043       {
; 0000 0044       rx_counter0=0;
	CLR  R6
; 0000 0045       rx_buffer_overflow0=1;
	SBI  0x1E,0
; 0000 0046       }
; 0000 0047 #endif
; 0000 0048    }
_0x5:
; 0000 0049 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0050 {
_getchar:
; .FSTART _getchar
; 0000 0051 char data;
; 0000 0052 while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0x8:
	TST  R6
	BREQ _0x8
; 0000 0053 data=rx_buffer0[rx_rd_index0++];
	MOV  R30,R3
	INC  R3
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 0054 #if RX_BUFFER_SIZE0 != 256
; 0000 0055 if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDI  R30,LOW(43)
	CP   R30,R3
	BRNE _0xB
	CLR  R3
; 0000 0056 #endif
; 0000 0057 #asm("cli")
_0xB:
	cli
; 0000 0058 --rx_counter0;
	DEC  R6
; 0000 0059 #asm("sei")
	sei
; 0000 005A return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 005B }
; .FEND
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;#include <delay.h>
;#include "include/aes.h"
;
;void main(void)
; 0000 0065 {
_main:
; .FSTART _main
; 0000 0066 // Declare your local variables here
; 0000 0067 unsigned char i,ck,hd[44];
; 0000 0068 unsigned char j;
; 0000 0069 unsigned char text[16],key[16],cipher[16];
; 0000 006A // Crystal Oscillator division factor: 1
; 0000 006B #pragma optsize-
; 0000 006C CLKPR=(1<<CLKPCE);
	SBIW R28,63
	SBIW R28,29
;	i -> R17
;	ck -> R16
;	hd -> Y+48
;	j -> R19
;	text -> Y+32
;	key -> Y+16
;	cipher -> Y+0
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 006D CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 006E #ifdef _OPTIMIZE_SIZE_
; 0000 006F #pragma optsize+
; 0000 0070 #endif
; 0000 0071 
; 0000 0072 // Input/Output Ports initialization
; 0000 0073 // Port B initialization
; 0000 0074 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0075 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x4,R30
; 0000 0076 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0077 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x5,R30
; 0000 0078 
; 0000 0079 // Port C initialization
; 0000 007A // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 007B DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x7,R30
; 0000 007C // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 007D PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x8,R30
; 0000 007E 
; 0000 007F // Port D initialization
; 0000 0080 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0081 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0xA,R30
; 0000 0082 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0083 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0xB,R30
; 0000 0084 
; 0000 0085 // USART initialization
; 0000 0086 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0087 // USART Receiver: On
; 0000 0088 // USART Transmitter: On
; 0000 0089 // USART0 Mode: Asynchronous
; 0000 008A // USART Baud Rate: 9600
; 0000 008B UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	STS  192,R30
; 0000 008C UCSR0B=(1<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(152)
	STS  193,R30
; 0000 008D UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 008E UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 008F UBRR0L=0x33;
	LDI  R30,LOW(51)
	STS  196,R30
; 0000 0090 
; 0000 0091 // Global enable interrupts
; 0000 0092 #asm("sei")
	sei
; 0000 0093 for(i=0;i<16;i++)
	LDI  R17,LOW(0)
_0xD:
	CPI  R17,16
	BRSH _0xE
; 0000 0094 {
; 0000 0095 text[i]=0x00;
	MOV  R30,R17
	CALL SUBOPT_0x0
; 0000 0096 key[i]=0x00;
	CALL SUBOPT_0x1
; 0000 0097 cipher[i]=0x00;
	MOVW R26,R28
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0098 }
	SUBI R17,-1
	RJMP _0xD
_0xE:
; 0000 0099 i=0;ck=0;
	LDI  R17,LOW(0)
	LDI  R16,LOW(0)
; 0000 009A while (1)
_0xF:
; 0000 009B     {
; 0000 009C         while(rx_counter0 == 0);
_0x12:
	TST  R6
	BREQ _0x12
; 0000 009D         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 009E         if(rx_counter0>9)
	LDI  R30,LOW(9)
	CP   R30,R6
	BRSH _0x15
; 0000 009F         {
; 0000 00A0         for(i=0;i<44;i++)
	LDI  R17,LOW(0)
_0x17:
	CPI  R17,44
	BRSH _0x18
; 0000 00A1             hd[i]='0';
	CALL SUBOPT_0x2
	LDI  R30,LOW(48)
	ST   X,R30
	SUBI R17,-1
	RJMP _0x17
_0x18:
; 0000 00A2 i=0;
	LDI  R17,LOW(0)
; 0000 00A3         while(rx_counter0>=0)
_0x19:
	LDI  R30,LOW(0)
	CP   R6,R30
	BRLO _0x1B
; 0000 00A4         {
; 0000 00A5             if(rx_counter0==0) break;
	TST  R6
	BREQ _0x1B
; 0000 00A6             hd[i++]=getchar();
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,48
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00A7         }
	RJMP _0x19
_0x1B:
; 0000 00A8         ck=1;
	LDI  R16,LOW(1)
; 0000 00A9         }
; 0000 00AA 
; 0000 00AB 
; 0000 00AC         if((rx_counter0 == 0) && (ck == 1))
_0x15:
	TST  R6
	BRNE _0x1E
	CPI  R16,1
	BREQ _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
; 0000 00AD         {
; 0000 00AE             if(hd[0]=='8'&&hd[1]=='0'&&hd[4]=='0'&&hd[5]=='0'&&hd[6]=='0'&&hd[7]=='0'&&hd[8]=='1'&&hd[9]=='0')
	LDD  R26,Y+48
	CPI  R26,LOW(0x38)
	BRNE _0x21
	LDD  R26,Y+49
	CPI  R26,LOW(0x30)
	BRNE _0x21
	LDD  R26,Y+52
	CPI  R26,LOW(0x30)
	BRNE _0x21
	LDD  R26,Y+53
	CPI  R26,LOW(0x30)
	BRNE _0x21
	LDD  R26,Y+54
	CPI  R26,LOW(0x30)
	BRNE _0x21
	LDD  R26,Y+55
	CPI  R26,LOW(0x30)
	BRNE _0x21
	LDD  R26,Y+56
	CPI  R26,LOW(0x31)
	BRNE _0x21
	LDD  R26,Y+57
	CPI  R26,LOW(0x30)
	BREQ _0x22
_0x21:
	RJMP _0x20
_0x22:
; 0000 00AF             {
; 0000 00B0                 if(hd[2]=='0')
	LDD  R26,Y+50
	CPI  R26,LOW(0x30)
	BREQ PC+2
	RJMP _0x23
; 0000 00B1                 {
; 0000 00B2                     switch(hd[3])
	LDD  R30,Y+51
	LDI  R31,0
; 0000 00B3                     {
; 0000 00B4                         case '2':
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x27
; 0000 00B5                         printf("\r\nPlaint Text: ");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x3
; 0000 00B6                         j=0;
; 0000 00B7                         for(i=10;i<42;i++)
_0x29:
	CPI  R17,42
	BRSH _0x2A
; 0000 00B8                         {
; 0000 00B9                             if((i+1)%2==0)
	CALL SUBOPT_0x4
	BRNE _0x2B
; 0000 00BA                             {
; 0000 00BB                                 text[j]=0x00;
	MOV  R30,R19
	CALL SUBOPT_0x0
; 0000 00BC                                 if(hd[i-1]<='9') text[j]=(hd[i-1]-0x30)*0x10;
	CALL SUBOPT_0x5
	LD   R26,X
	CPI  R26,LOW(0x3A)
	BRSH _0x2C
	CALL SUBOPT_0x6
	LD   R30,X
	SUBI R30,LOW(48)
	RJMP _0x45
; 0000 00BD                                 else text[j]=(hd[i-1]-0x57)*0x10;
_0x2C:
	CALL SUBOPT_0x6
	LD   R30,X
	SUBI R30,LOW(87)
_0x45:
	LDI  R26,LOW(16)
	MULS R30,R26
	MOVW R30,R0
	MOVW R26,R22
	ST   X,R30
; 0000 00BE                                 if(hd[i]<='9') text[j++]+=(hd[i]-0x30);
	CALL SUBOPT_0x2
	LD   R26,X
	CPI  R26,LOW(0x3A)
	BRSH _0x2E
	CALL SUBOPT_0x7
	LD   R30,X
	SUBI R30,LOW(48)
	RJMP _0x46
; 0000 00BF                                 else text[j++]+=(hd[i]-0x57);
_0x2E:
	CALL SUBOPT_0x7
	LD   R30,X
	SUBI R30,LOW(87)
_0x46:
	ADD  R30,R0
	MOVW R26,R22
	ST   X,R30
; 0000 00C0                             }
; 0000 00C1                         }
_0x2B:
	SUBI R17,-1
	RJMP _0x29
_0x2A:
; 0000 00C2                         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 00C3                         for(i=0;i<16;i++)
	LDI  R17,LOW(0)
_0x31:
	CPI  R17,16
	BRSH _0x32
; 0000 00C4                         {
; 0000 00C5                         printf("%X ",text[i]);
	CALL SUBOPT_0x8
	MOVW R26,R28
	ADIW R26,34
	CALL SUBOPT_0x9
; 0000 00C6                         }
	SUBI R17,-1
	RJMP _0x31
_0x32:
; 0000 00C7                         break;
	RJMP _0x26
; 0000 00C8                         case '3':
_0x27:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x33
; 0000 00C9                         printf("\r\nKey: ");
	__POINTW1FN _0x0,20
	CALL SUBOPT_0x3
; 0000 00CA                         j=0;
; 0000 00CB                         for(i=10;i<42;i++)
_0x35:
	CPI  R17,42
	BRSH _0x36
; 0000 00CC                         {
; 0000 00CD                             if((i+1)%2==0)
	CALL SUBOPT_0x4
	BRNE _0x37
; 0000 00CE                             {
; 0000 00CF                                 key[j]=0x00;
	MOV  R30,R19
	LDI  R31,0
	CALL SUBOPT_0x1
; 0000 00D0                                 if(hd[i-1]<='9') key[j]=(hd[i-1]-0x30)*0x10;
	CALL SUBOPT_0x5
	LD   R26,X
	CPI  R26,LOW(0x3A)
	BRSH _0x38
	CALL SUBOPT_0xA
	LD   R30,X
	SUBI R30,LOW(48)
	RJMP _0x47
; 0000 00D1                                 else key[j]=(hd[i-1]-0x57)*0x10;
_0x38:
	CALL SUBOPT_0xA
	LD   R30,X
	SUBI R30,LOW(87)
_0x47:
	LDI  R26,LOW(16)
	MULS R30,R26
	MOVW R30,R0
	MOVW R26,R22
	ST   X,R30
; 0000 00D2                                 if(hd[i]<='9') key[j++]+=(hd[i]-0x30);
	CALL SUBOPT_0x2
	LD   R26,X
	CPI  R26,LOW(0x3A)
	BRSH _0x3A
	CALL SUBOPT_0xB
	LD   R30,X
	SUBI R30,LOW(48)
	RJMP _0x48
; 0000 00D3                                 else key[j++]+=(hd[i]-0x57);
_0x3A:
	CALL SUBOPT_0xB
	LD   R30,X
	SUBI R30,LOW(87)
_0x48:
	ADD  R30,R0
	MOVW R26,R22
	ST   X,R30
; 0000 00D4                             }
; 0000 00D5                         }
_0x37:
	SUBI R17,-1
	RJMP _0x35
_0x36:
; 0000 00D6                         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 00D7                         for(i=0;i<16;i++)
	LDI  R17,LOW(0)
_0x3D:
	CPI  R17,16
	BRSH _0x3E
; 0000 00D8                         {
; 0000 00D9                         printf("%X ",key[i]);
	CALL SUBOPT_0x8
	MOVW R26,R28
	ADIW R26,18
	CALL SUBOPT_0x9
; 0000 00DA                         }
	SUBI R17,-1
	RJMP _0x3D
_0x3E:
; 0000 00DB                         break;
	RJMP _0x26
; 0000 00DC                         case '4':
_0x33:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0x43
; 0000 00DD                         printf("\r\n\tWatting Encrypt !!!");
	__POINTW1FN _0x0,28
	CALL SUBOPT_0xC
; 0000 00DE //                        printf("\r\nPlaint Text: ");
; 0000 00DF //                        for(i=0;i<16;i++)
; 0000 00E0 //                            printf("%X ",text[i]);
; 0000 00E1 //                            printf("\r\nKey: ");
; 0000 00E2 //                        for(i=0;i<16;i++)
; 0000 00E3 //                            printf("%X ",key[i]);
; 0000 00E4                         Encrypt(text,key,cipher);
	MOVW R30,R28
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,18
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,4
	RCALL _Encrypt
; 0000 00E5                         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 00E6                         printf("\r\nCipher Text: ");
	__POINTW1FN _0x0,51
	CALL SUBOPT_0xC
; 0000 00E7                         for(i=0;i<16;i++)
	LDI  R17,LOW(0)
_0x41:
	CPI  R17,16
	BRSH _0x42
; 0000 00E8                             printf("%X ",cipher[i]);
	CALL SUBOPT_0x8
	MOVW R26,R28
	ADIW R26,2
	CALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x41
_0x42:
; 0000 00E9 printf("\r\n\tEnd Encrypt AES-128 !!!\r\n");
	__POINTW1FN _0x0,67
	RJMP _0x49
; 0000 00EA //                        Decrypt(cipher,key,cipher);
; 0000 00EB //                        printf("\r\n\tWatting Decrypt !!!");
; 0000 00EC //                        delay_ms(500);
; 0000 00ED //                        printf("\r\nPlaint Text: ");
; 0000 00EE //                        for(i=0;i<16;i++)
; 0000 00EF //                            printf("%X ",cipher[i]);
; 0000 00F0                         break;
; 0000 00F1                         default: printf("\r\nNULL\r\n");
_0x43:
	__POINTW1FN _0x0,96
_0x49:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 00F2                     }
_0x26:
; 0000 00F3                 }
; 0000 00F4             }
_0x23:
; 0000 00F5             ck = 0;
_0x20:
	LDI  R16,LOW(0)
; 0000 00F6             i=0;
	LDI  R17,LOW(0)
; 0000 00F7         }
; 0000 00F8       }
_0x1D:
	RJMP _0xF
; 0000 00F9 }
_0x44:
	RJMP _0x44
; .FEND
;#include "aes.h"
;
;flash unsigned char sbox[256] =
; {
;    0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76,
;    0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0,
;    0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15,
;    0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75,
;    0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84,
;    0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF,
;    0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8,
;    0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2,
;    0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73,
;    0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB,
;    0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79,
;    0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08,
;    0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A,
;    0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E,
;    0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF,
;    0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16
; };
;
;//flash unsigned char inv_sbox[256] =
;// {
;//    0x52, 0x09, 0x6A, 0xD5, 0x30, 0x36, 0xA5, 0x38, 0xBF, 0x40, 0xA3, 0x9E, 0x81, 0xF3, 0xD7, 0xFB,
;//    0x7C, 0xE3, 0x39, 0x82, 0x9B, 0x2F, 0xFF, 0x87, 0x34, 0x8E, 0x43, 0x44, 0xC4, 0xDE, 0xE9, 0xCB,
;//    0x54, 0x7B, 0x94, 0x32, 0xA6, 0xC2, 0x23, 0x3D, 0xEE, 0x4C, 0x95, 0x0B, 0x42, 0xFA, 0xC3, 0x4E,
;//    0x08, 0x2E, 0xA1, 0x66, 0x28, 0xD9, 0x24, 0xB2, 0x76, 0x5B, 0xA2, 0x49, 0x6D, 0x8B, 0xD1, 0x25,
;//    0x72, 0xF8, 0xF6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xD4, 0xA4, 0x5C, 0xCC, 0x5D, 0x65, 0xB6, 0x92,
;//    0x6C, 0x70, 0x48, 0x50, 0xFD, 0xED, 0xB9, 0xDA, 0x5E, 0x15, 0x46, 0x57, 0xA7, 0x8D, 0x9D, 0x84,
;//    0x90, 0xD8, 0xAB, 0x00, 0x8C, 0xBC, 0xD3, 0x0A, 0xF7, 0xE4, 0x58, 0x05, 0xB8, 0xB3, 0x45, 0x06,
;//    0xD0, 0x2C, 0x1E, 0x8F, 0xCA, 0x3F, 0x0F, 0x02, 0xC1, 0xAF, 0xBD, 0x03, 0x01, 0x13, 0x8A, 0x6B,
;//    0x3A, 0x91, 0x11, 0x41, 0x4F, 0x67, 0xDC, 0xEA, 0x97, 0xF2, 0xCF, 0xCE, 0xF0, 0xB4, 0xE6, 0x73,
;//    0x96, 0xAC, 0x74, 0x22, 0xE7, 0xAD, 0x35, 0x85, 0xE2, 0xF9, 0x37, 0xE8, 0x1C, 0x75, 0xDF, 0x6E,
;//    0x47, 0xF1, 0x1A, 0x71, 0x1D, 0x29, 0xC5, 0x89, 0x6F, 0xB7, 0x62, 0x0E, 0xAA, 0x18, 0xBE, 0x1B,
;//    0xFC, 0x56, 0x3E, 0x4B, 0xC6, 0xD2, 0x79, 0x20, 0x9A, 0xDB, 0xC0, 0xFE, 0x78, 0xCD, 0x5A, 0xF4,
;//    0x1F, 0xDD, 0xA8, 0x33, 0x88, 0x07, 0xC7, 0x31, 0xB1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xEC, 0x5F,
;//    0x60, 0x51, 0x7F, 0xA9, 0x19, 0xB5, 0x4A, 0x0D, 0x2D, 0xE5, 0x7A, 0x9F, 0x93, 0xC9, 0x9C, 0xEF,
;//    0xA0, 0xE0, 0x3B, 0x4D, 0xAE, 0x2A, 0xF5, 0xB0, 0xC8, 0xEB, 0xBB, 0x3C, 0x83, 0x53, 0x99, 0x61,
;//    0x17, 0x2B, 0x04, 0x7E, 0xBA, 0x77, 0xD6, 0x26, 0xE1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0C, 0x7D
;// };
;unsigned char rcon[10] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};

	.DSEG
;
;void Encrypt(unsigned char *in,unsigned char *key,unsigned char *out);
;//void Decrypt(unsigned char *in,unsigned char *key,unsigned char *out);
;
;// OverView Function Encrypt
;void Expankey(unsigned char *key,unsigned char *expkey);
;void SubBytes(unsigned char *state);
;void AddRoundKey(unsigned char *state,unsigned char *expkey,unsigned char n);
;void MixColumns(unsigned char *state);
;void ShiftRows(unsigned char *state);
;
;
;//    OverView Function Decrypt
;//void InvShiftRows(unsigned char *state);
;//void InvSubBytes(unsigned char *state);
;//void InvMixColumns(unsigned char *state);
;
;// function for all
;// function multilply 2 number
;//unsigned char gmul(unsigned char a, unsigned char b) {
;//    unsigned char p = 0; /* the product of the multiplication */
;//    while (a && b) {
;//            if (b & 1) /* if b is odd, then add the corresponding a to p (final product = sum of all a's corresponding ...
;//                p ^= a; /* since we're in GF(2^m), addition is an XOR */
;//
;//            if (a & 0x80) /* GF modulo: if a >= 128, then it will overflow when shifted left, so reduce */
;//                a = (a << 1) ^ 0x11b; /* XOR with the primitive polynomial x^8 + x^4 + x^3 + x + 1 (0b1_0001_1011) – y ...
;//            else
;//                a <<= 1; /* equivalent to a*2 */
;//            b >>= 1; /* equivalent to b // 2 */
;//    }
;//    return p;
;//}
;
;void Expankey(unsigned char *key,unsigned char *expkey)
; 0001 004E {

	.CSEG
_Expankey:
; .FSTART _Expankey
; 0001 004F     unsigned char j,i;
; 0001 0050     for (j=0;j<16;j++)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*key -> Y+4
;	*expkey -> Y+2
;	j -> R17
;	i -> R16
	LDI  R17,LOW(0)
_0x20005:
	CPI  R17,16
	BRSH _0x20006
; 0001 0051     {
; 0001 0052         expkey[j] = key[j];
	MOV  R30,R17
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL SUBOPT_0xD
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0xE
	MOVW R26,R0
	ST   X,R30
; 0001 0053     }
	SUBI R17,-1
	RJMP _0x20005
_0x20006:
; 0001 0054 
; 0001 0055     for (i=1;i<11;i++)
	LDI  R16,LOW(1)
_0x20008:
	CPI  R16,11
	BRLO PC+2
	RJMP _0x20009
; 0001 0056     {
; 0001 0057         for(j=0;j<16;j++)
	LDI  R17,LOW(0)
_0x2000B:
	CPI  R17,16
	BRLO PC+2
	RJMP _0x2000C
; 0001 0058         {
; 0001 0059             if (j>=0&&j<4) {
	CPI  R17,0
	BRLO _0x2000E
	CPI  R17,4
	BRLO _0x2000F
_0x2000E:
	RJMP _0x2000D
_0x2000F:
; 0001 005A                 if (j==3) {
	CPI  R17,3
	BRNE _0x20010
; 0001 005B                     expkey[i*16+j] = sbox[expkey[i*16+j-7]];
	CALL SUBOPT_0xF
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RJMP _0x2002A
; 0001 005C                 } else {
_0x20010:
; 0001 005D                     expkey[i*16+j] = sbox[expkey[i*16+j-3]];
	CALL SUBOPT_0xF
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
_0x2002A:
	CALL __SWAPW12
	CALL SUBOPT_0x10
	LD   R30,X
	LDI  R31,0
	SUBI R30,LOW(-_sbox*2)
	SBCI R31,HIGH(-_sbox*2)
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
; 0001 005E                 }
; 0001 005F                 if (j==0) expkey[i*16+j] ^= expkey[i*16+j-16] ^ rcon[i-1];
	CPI  R17,0
	BRNE _0x20012
	CALL SUBOPT_0x11
	LD   R26,X
	MOV  R30,R16
	LDI  R31,0
	SBIW R30,1
	SUBI R30,LOW(-_rcon)
	SBCI R31,HIGH(-_rcon)
	LD   R30,Z
	EOR  R30,R26
	RJMP _0x2002B
; 0001 0060                 else    expkey[i*16+j] ^= expkey[i*16+j-16];
_0x20012:
	CALL SUBOPT_0x11
	LD   R30,X
_0x2002B:
	EOR  R30,R22
	__GETW2R 23,24
	ST   X,R30
; 0001 0061             } else {
	RJMP _0x20014
_0x2000D:
; 0001 0062                 expkey[i*16+j] = expkey[i*16+j-4] ^ expkey[i*16+j-16];
	LDI  R30,LOW(16)
	MUL  R30,R16
	MOVW R30,R0
	CALL SUBOPT_0x12
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1R 23,24
	MOVW R26,R0
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __SWAPW12
	CALL SUBOPT_0x10
	LD   R22,X
	LDI  R30,LOW(16)
	MUL  R30,R16
	MOVW R30,R0
	MOVW R26,R30
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL __SWAPW12
	CALL SUBOPT_0x10
	LD   R30,X
	EOR  R30,R22
	__GETW2R 23,24
	ST   X,R30
; 0001 0063             }
_0x20014:
; 0001 0064         }
	SUBI R17,-1
	RJMP _0x2000B
_0x2000C:
; 0001 0065     }
	SUBI R16,-1
	RJMP _0x20008
_0x20009:
; 0001 0066 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2060002
; .FEND
;
;void AddRoundKey(unsigned char *state,unsigned char *expkey,unsigned char n)
; 0001 0069 {
_AddRoundKey:
; .FSTART _AddRoundKey
; 0001 006A     unsigned char i;
; 0001 006B     for (i=0;i<16;i++){
	ST   -Y,R26
	ST   -Y,R17
;	*state -> Y+4
;	*expkey -> Y+2
;	n -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x20016:
	CPI  R17,16
	BRSH _0x20017
; 0001 006C         state[i] ^= expkey[n-16+i];
	MOV  R30,R17
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LD   R0,Z
	LDD  R30,Y+1
	LDI  R31,0
	SBIW R30,16
	CALL SUBOPT_0x12
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	EOR  R30,R0
	MOVW R26,R22
	ST   X,R30
; 0001 006D     }
	SUBI R17,-1
	RJMP _0x20016
_0x20017:
; 0001 006E }
	LDD  R17,Y+0
_0x2060002:
	ADIW R28,6
	RET
; .FEND
;
;// Begin function Encrypt
;void Encrypt(unsigned char *in,unsigned char *key,unsigned char *out)
; 0001 0072 {
_Encrypt:
; .FSTART _Encrypt
; 0001 0073     unsigned char expkey[176],i;
; 0001 0074     unsigned char state[16];
; 0001 0075 
; 0001 0076     for (i=0;i<16;i++)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,63
	SBIW R28,63
	SBIW R28,3
	ST   -Y,R17
;	*in -> Y+197
;	*key -> Y+195
;	*out -> Y+193
;	expkey -> Y+17
;	i -> R17
;	state -> Y+1
	LDI  R17,LOW(0)
_0x20019:
	CPI  R17,16
	BRSH _0x2001A
; 0001 0077         state[i] = in[i];
	CALL SUBOPT_0x13
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	__GETW2SX 197
	CALL SUBOPT_0xE
	MOVW R26,R22
	ST   X,R30
	SUBI R17,-1
	RJMP _0x20019
_0x2001A:
; 0001 0079 Expankey(key,expkey);
	__GETW1SX 195
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,19
	RCALL _Expankey
; 0001 007A     AddRoundKey(state,expkey,16);
	CALL SUBOPT_0x14
	RCALL _AddRoundKey
; 0001 007B     for (i=2;i<11;i++)
	LDI  R17,LOW(2)
_0x2001C:
	CPI  R17,11
	BRSH _0x2001D
; 0001 007C     {
; 0001 007D         SubBytes(state);
	CALL SUBOPT_0x15
; 0001 007E         ShiftRows(state);
; 0001 007F         MixColumns(state);
	MOVW R26,R28
	ADIW R26,1
	RCALL _MixColumns
; 0001 0080         AddRoundKey(state,expkey,i*16);
	CALL SUBOPT_0x14
	MULS R17,R26
	MOVW R30,R0
	MOV  R26,R30
	RCALL _AddRoundKey
; 0001 0081     }
	SUBI R17,-1
	RJMP _0x2001C
_0x2001D:
; 0001 0082     SubBytes(state);
	CALL SUBOPT_0x15
; 0001 0083     ShiftRows(state);
; 0001 0084     AddRoundKey(state,expkey,i*16);
	CALL SUBOPT_0x14
	MULS R17,R26
	MOVW R30,R0
	MOV  R26,R30
	RCALL _AddRoundKey
; 0001 0085 
; 0001 0086     for (i=0;i<16;i++)
	LDI  R17,LOW(0)
_0x2001F:
	CPI  R17,16
	BRSH _0x20020
; 0001 0087         out[i] = state[i];
	MOV  R30,R17
	__GETW2SX 193
	CALL SUBOPT_0xD
	CALL SUBOPT_0x13
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	SUBI R17,-1
	RJMP _0x2001F
_0x20020:
; 0001 0088 }
	LDD  R17,Y+0
	ADIW R28,63
	ADIW R28,63
	ADIW R28,63
	ADIW R28,10
	RET
; .FEND
;
;void SubBytes(unsigned char *state)
; 0001 008B {
_SubBytes:
; .FSTART _SubBytes
; 0001 008C     unsigned char i;
; 0001 008D     for (i=0;i<16;i++)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*state -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x20022:
	CPI  R17,16
	BRSH _0x20023
; 0001 008E         state[i] = sbox[state[i]];
	MOV  R30,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL SUBOPT_0xD
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL SUBOPT_0xE
	LDI  R31,0
	SUBI R30,LOW(-_sbox*2)
	SBCI R31,HIGH(-_sbox*2)
	LPM  R30,Z
	MOVW R26,R0
	ST   X,R30
	SUBI R17,-1
	RJMP _0x20022
_0x20023:
; 0001 008F }
	LDD  R17,Y+0
	RJMP _0x2060001
; .FEND
;
;void MixColumns(unsigned char *state)
; 0001 0092 {
_MixColumns:
; .FSTART _MixColumns
; 0001 0093     unsigned char a[16];
; 0001 0094     unsigned char b[16];
; 0001 0095     unsigned char c;
; 0001 0096     unsigned char h;
; 0001 0097     /* The array 'a' is simply a copy of the input array 'r'
; 0001 0098      * The array 'b' is each element of the array 'a' multiplied by 2
; 0001 0099      * in Rijndael's Galois field
; 0001 009A      * a[n] ^ b[n] is element n multiplied by 3 in Rijndael's Galois field */
; 0001 009B     for (c = 0; c < 16; c++) {
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,32
	ST   -Y,R17
	ST   -Y,R16
;	*state -> Y+34
;	a -> Y+18
;	b -> Y+2
;	c -> R17
;	h -> R16
	LDI  R17,LOW(0)
_0x20025:
	CPI  R17,16
	BRSH _0x20026
; 0001 009C         a[c] = state[c];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,18
	CALL SUBOPT_0x16
	MOVW R26,R0
	ST   X,R30
; 0001 009D         /* h is 0xff if the high bit of r[c] is set, 0 otherwise */
; 0001 009E         h = (unsigned char)((signed char)state[c] >> 7); /* arithmetic right shift, thus shifting in either zeros or one ...
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	LDI  R30,LOW(7)
	CALL __ASRB12
	MOV  R16,R30
; 0001 009F         b[c] = state[c] << 1; /* implicitly removes high bit because b[c] is an 8-bit char, so we xor by 0x1b and not 0x ...
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	CALL SUBOPT_0x16
	LSL  R30
	MOVW R26,R0
	ST   X,R30
; 0001 00A0         b[c] ^= 0x1B & h; /* Rijndael's Galois field */
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LD   R26,Z
	MOV  R30,R16
	ANDI R30,LOW(0x1B)
	EOR  R30,R26
	MOVW R26,R0
	ST   X,R30
; 0001 00A1     }
	SUBI R17,-1
	RJMP _0x20025
_0x20026:
; 0001 00A2 
; 0001 00A3     state[0] = b[0] ^ a[3] ^ a[2] ^ b[1] ^ a[1]; /* 2 * a0 + a3 + a2 + 3 * a1 */
	LDD  R30,Y+21
	LDD  R26,Y+2
	EOR  R30,R26
	LDD  R26,Y+20
	EOR  R30,R26
	LDD  R26,Y+3
	EOR  R30,R26
	LDD  R26,Y+19
	EOR  R30,R26
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	ST   X,R30
; 0001 00A4     state[1] = b[1] ^ a[0] ^ a[3] ^ b[2] ^ a[2]; /* 2 * a1 + a0 + a3 + 3 * a2 */
	LDD  R30,Y+18
	LDD  R26,Y+3
	EOR  R30,R26
	LDD  R26,Y+21
	EOR  R30,R26
	LDD  R26,Y+4
	EOR  R30,R26
	LDD  R26,Y+20
	EOR  R30,R26
	__PUTB1SNS 34,1
; 0001 00A5     state[2] = b[2] ^ a[1] ^ a[0] ^ b[3] ^ a[3]; /* 2 * a2 + a1 + a0 + 3 * a3 */
	LDD  R30,Y+19
	LDD  R26,Y+4
	EOR  R30,R26
	LDD  R26,Y+18
	EOR  R30,R26
	LDD  R26,Y+5
	EOR  R30,R26
	LDD  R26,Y+21
	EOR  R30,R26
	__PUTB1SNS 34,2
; 0001 00A6     state[3] = b[3] ^ a[2] ^ a[1] ^ b[0] ^ a[0]; /* 2 * a3 + a2 + a1 + 3 * a0 */
	LDD  R30,Y+20
	LDD  R26,Y+5
	EOR  R30,R26
	LDD  R26,Y+19
	EOR  R30,R26
	LDD  R26,Y+2
	EOR  R30,R26
	LDD  R26,Y+18
	EOR  R30,R26
	__PUTB1SNS 34,3
; 0001 00A7 
; 0001 00A8     state[4] = b[4] ^ a[7] ^ a[6] ^ b[5] ^ a[5];
	LDD  R30,Y+25
	LDD  R26,Y+6
	EOR  R30,R26
	LDD  R26,Y+24
	EOR  R30,R26
	LDD  R26,Y+7
	EOR  R30,R26
	LDD  R26,Y+23
	EOR  R30,R26
	__PUTB1SNS 34,4
; 0001 00A9     state[5] = b[5] ^ a[4] ^ a[7] ^ b[6] ^ a[6];
	LDD  R30,Y+22
	LDD  R26,Y+7
	EOR  R30,R26
	LDD  R26,Y+25
	EOR  R30,R26
	LDD  R26,Y+8
	EOR  R30,R26
	LDD  R26,Y+24
	EOR  R30,R26
	__PUTB1SNS 34,5
; 0001 00AA     state[6] = b[6] ^ a[5] ^ a[4] ^ b[7] ^ a[7];
	LDD  R30,Y+23
	LDD  R26,Y+8
	EOR  R30,R26
	LDD  R26,Y+22
	EOR  R30,R26
	LDD  R26,Y+9
	EOR  R30,R26
	LDD  R26,Y+25
	EOR  R30,R26
	__PUTB1SNS 34,6
; 0001 00AB     state[7] = b[7] ^ a[6] ^ a[5] ^ b[4] ^ a[4];
	LDD  R30,Y+24
	LDD  R26,Y+9
	EOR  R30,R26
	LDD  R26,Y+23
	EOR  R30,R26
	LDD  R26,Y+6
	EOR  R30,R26
	LDD  R26,Y+22
	EOR  R30,R26
	__PUTB1SNS 34,7
; 0001 00AC 
; 0001 00AD     state[8] = b[8] ^ a[11] ^ a[10] ^ b[9] ^ a[9];
	LDD  R30,Y+29
	LDD  R26,Y+10
	EOR  R30,R26
	LDD  R26,Y+28
	EOR  R30,R26
	LDD  R26,Y+11
	EOR  R30,R26
	LDD  R26,Y+27
	EOR  R30,R26
	__PUTB1SNS 34,8
; 0001 00AE     state[9] = b[9] ^ a[8] ^ a[11] ^ b[10] ^ a[10];
	LDD  R30,Y+26
	LDD  R26,Y+11
	EOR  R30,R26
	LDD  R26,Y+29
	EOR  R30,R26
	LDD  R26,Y+12
	EOR  R30,R26
	LDD  R26,Y+28
	EOR  R30,R26
	__PUTB1SNS 34,9
; 0001 00AF     state[10] = b[10] ^ a[9] ^ a[8] ^ b[11] ^ a[11];
	LDD  R30,Y+27
	LDD  R26,Y+12
	EOR  R30,R26
	LDD  R26,Y+26
	EOR  R30,R26
	LDD  R26,Y+13
	EOR  R30,R26
	LDD  R26,Y+29
	EOR  R30,R26
	__PUTB1SNS 34,10
; 0001 00B0     state[11] = b[11] ^ a[10] ^ a[9] ^ b[8] ^ a[8];
	LDD  R30,Y+28
	LDD  R26,Y+13
	EOR  R30,R26
	LDD  R26,Y+27
	EOR  R30,R26
	LDD  R26,Y+10
	EOR  R30,R26
	LDD  R26,Y+26
	EOR  R30,R26
	__PUTB1SNS 34,11
; 0001 00B1 
; 0001 00B2     state[12] = b[12] ^ a[15] ^ a[14] ^ b[13] ^ a[13];
	LDD  R30,Y+33
	LDD  R26,Y+14
	EOR  R30,R26
	LDD  R26,Y+32
	EOR  R30,R26
	LDD  R26,Y+15
	EOR  R30,R26
	LDD  R26,Y+31
	EOR  R30,R26
	__PUTB1SNS 34,12
; 0001 00B3     state[13] = b[13] ^ a[12] ^ a[15] ^ b[14] ^ a[14];
	LDD  R30,Y+30
	LDD  R26,Y+15
	EOR  R30,R26
	LDD  R26,Y+33
	EOR  R30,R26
	LDD  R26,Y+16
	EOR  R30,R26
	LDD  R26,Y+32
	EOR  R30,R26
	__PUTB1SNS 34,13
; 0001 00B4     state[14] = b[14] ^ a[13] ^ a[12] ^ b[15] ^ a[15];
	LDD  R30,Y+31
	LDD  R26,Y+16
	EOR  R30,R26
	LDD  R26,Y+30
	EOR  R30,R26
	LDD  R26,Y+17
	EOR  R30,R26
	LDD  R26,Y+33
	EOR  R30,R26
	__PUTB1SNS 34,14
; 0001 00B5     state[15] = b[15] ^ a[14] ^ a[13] ^ b[12] ^ a[12];
	LDD  R30,Y+32
	LDD  R26,Y+17
	EOR  R30,R26
	LDD  R26,Y+31
	EOR  R30,R26
	LDD  R26,Y+14
	EOR  R30,R26
	LDD  R26,Y+30
	EOR  R30,R26
	__PUTB1SNS 34,15
; 0001 00B6 
; 0001 00B7 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,36
	RET
; .FEND
;
;void ShiftRows(unsigned char *state)
; 0001 00BA {
_ShiftRows:
; .FSTART _ShiftRows
; 0001 00BB     unsigned char tmp[16],i;
; 0001 00BC 
; 0001 00BD     for (i=0;i<16;i++)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,16
	ST   -Y,R17
;	*state -> Y+17
;	tmp -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x20028:
	CPI  R17,16
	BRSH _0x20029
; 0001 00BE         tmp[i]=state[i];
	CALL SUBOPT_0x13
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0xE
	MOVW R26,R0
	ST   X,R30
	SUBI R17,-1
	RJMP _0x20028
_0x20029:
; 0001 00C0 state[0]=tmp[0];
	LDD  R30,Y+1
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ST   X,R30
; 0001 00C1     state[1]=tmp[5];
	LDD  R30,Y+6
	__PUTB1SNS 17,1
; 0001 00C2     state[2]=tmp[10];
	LDD  R30,Y+11
	__PUTB1SNS 17,2
; 0001 00C3     state[3]=tmp[15];
	LDD  R30,Y+16
	__PUTB1SNS 17,3
; 0001 00C4 
; 0001 00C5     state[4]=tmp[4];
	LDD  R30,Y+5
	__PUTB1SNS 17,4
; 0001 00C6     state[5]=tmp[9];
	LDD  R30,Y+10
	__PUTB1SNS 17,5
; 0001 00C7     state[6]=tmp[14];
	LDD  R30,Y+15
	__PUTB1SNS 17,6
; 0001 00C8     state[7]=tmp[3];
	LDD  R30,Y+4
	__PUTB1SNS 17,7
; 0001 00C9 
; 0001 00CA     state[8]=tmp[8];
	LDD  R30,Y+9
	__PUTB1SNS 17,8
; 0001 00CB     state[9]=tmp[13];
	LDD  R30,Y+14
	__PUTB1SNS 17,9
; 0001 00CC     state[10]=tmp[2];
	LDD  R30,Y+3
	__PUTB1SNS 17,10
; 0001 00CD     state[11]=tmp[7];
	LDD  R30,Y+8
	__PUTB1SNS 17,11
; 0001 00CE 
; 0001 00CF     state[12]=tmp[12];
	LDD  R30,Y+13
	__PUTB1SNS 17,12
; 0001 00D0     state[13]=tmp[1];
	LDD  R30,Y+2
	__PUTB1SNS 17,13
; 0001 00D1     state[14]=tmp[6];
	LDD  R30,Y+7
	__PUTB1SNS 17,14
; 0001 00D2     state[15]=tmp[11];
	LDD  R30,Y+12
	__PUTB1SNS 17,15
; 0001 00D3 }
	LDD  R17,Y+0
	ADIW R28,19
	RET
; .FEND
;// End function Encrypt
;
;//Begin function Decrypt
;//void Decrypt(unsigned char *in,unsigned char *key,unsigned char *out)
;//{
;//    unsigned char expkey[176],i,state[16];
;//
;//    for(i=0;i<16;i++)
;//        state[i]=in[i];
;//
;//    Expankey(key,expkey);
;//    AddRoundKey(state,expkey,176);
;//    InvShiftRows(state);
;//    InvSubBytes(state);
;//    for (i=10;i>1;i--)
;//    {
;//        AddRoundKey(state,expkey,i*16);
;//        InvMixColumns(state);
;//        InvShiftRows(state);
;//        InvSubBytes(state);
;//    }
;//    AddRoundKey(state,key,16);
;//    for (i=0;i<16;i++)
;//        out[i] = state[i];
;//
;//}
;//
;//void InvShiftRows(unsigned char *state)
;//{
;//    unsigned char tmp[16],i;
;//    for (i=0;i<16;i++)
;//        tmp[i] = state[i];
;//
;//    state[0] = tmp[0];
;//    state[1] = tmp[13];
;//    state[2] = tmp[10];
;//    state[3] = tmp[7];
;//
;//    state[4] = tmp[4];
;//    state[5] = tmp[1];
;//    state[6] = tmp[14];
;//    state[7] = tmp[11];
;//
;//    state[8] = tmp[8];
;//    state[9] = tmp[5];
;//    state[10] = tmp[2];
;//    state[11] = tmp[15];
;//
;//    state[12] = tmp[12];
;//    state[13] = tmp[9];
;//    state[14] = tmp[6];
;//    state[15] = tmp[3];
;//}
;//
;//void InvSubBytes(unsigned char *state)
;//{
;//    unsigned char i;
;//    for (i=0;i<16;i++)
;//        state[i] = inv_sbox[state[i]];
;//}
;//
;//
;//void InvMixColumns(unsigned char *state)
;//{
;//    unsigned char tmp[16],i;
;//    for (i=0;i<16;i++)
;//        tmp[i] = state[i];
;//
;//    state[0] = gmul(0x09,tmp[3]) ^ gmul(0x0b,tmp[1]) ^ gmul(0x0d,tmp[2]) ^ gmul(0x0e,tmp[0]);
;//    state[1] = gmul(0x09,tmp[0]) ^ gmul(0x0b,tmp[2]) ^ gmul(0x0d,tmp[3]) ^ gmul(0x0e,tmp[1]);
;//    state[2] = gmul(0x09,tmp[1]) ^ gmul(0x0b,tmp[3]) ^ gmul(0x0d,tmp[0]) ^ gmul(0x0e,tmp[2]);
;//    state[3] = gmul(0x09,tmp[2]) ^ gmul(0x0b,tmp[0]) ^ gmul(0x0d,tmp[1]) ^ gmul(0x0e,tmp[3]);
;//
;//    state[4] = gmul(0x09,tmp[7]) ^ gmul(0x0b,tmp[5]) ^ gmul(0x0d,tmp[6]) ^ gmul(0x0e,tmp[4]);
;//    state[5] = gmul(0x09,tmp[4]) ^ gmul(0x0b,tmp[6]) ^ gmul(0x0d,tmp[7]) ^ gmul(0x0e,tmp[5]);
;//    state[6] = gmul(0x09,tmp[5]) ^ gmul(0x0b,tmp[7]) ^ gmul(0x0d,tmp[4]) ^ gmul(0x0e,tmp[6]);
;//    state[7] = gmul(0x09,tmp[6]) ^ gmul(0x0b,tmp[4]) ^ gmul(0x0d,tmp[5]) ^ gmul(0x0e,tmp[7]);
;//
;//    state[8] = gmul(0x09,tmp[11]) ^ gmul(0x0b,tmp[9]) ^ gmul(0x0d,tmp[10]) ^ gmul(0x0e,tmp[8]);
;//    state[9] = gmul(0x09,tmp[8]) ^ gmul(0x0b,tmp[10]) ^ gmul(0x0d,tmp[11]) ^ gmul(0x0e,tmp[9]);
;//    state[10] = gmul(0x09,tmp[9]) ^ gmul(0x0b,tmp[11]) ^ gmul(0x0d,tmp[8]) ^ gmul(0x0e,tmp[10]);
;//    state[11] = gmul(0x09,tmp[10]) ^ gmul(0x0b,tmp[8]) ^ gmul(0x0d,tmp[9]) ^ gmul(0x0e,tmp[11]);
;//
;//    state[12] = gmul(0x09,tmp[15]) ^ gmul(0x0b,tmp[13]) ^ gmul(0x0d,tmp[14]) ^ gmul(0x0e,tmp[12]);
;//    state[13] = gmul(0x09,tmp[12]) ^ gmul(0x0b,tmp[14]) ^ gmul(0x0d,tmp[15]) ^ gmul(0x0e,tmp[13]);
;//    state[14] = gmul(0x09,tmp[13]) ^ gmul(0x0b,tmp[15]) ^ gmul(0x0d,tmp[12]) ^ gmul(0x0e,tmp[14]);
;//    state[15] = gmul(0x09,tmp[14]) ^ gmul(0x0b,tmp[12]) ^ gmul(0x0d,tmp[13]) ^ gmul(0x0e,tmp[15]);
;//
;//}
;// End function Decrypt
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
_0x2000003:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x2000003
	LD   R30,Y
	STS  198,R30
	ADIW R28,1
	RET
; .FEND
_put_usart_G100:
; .FSTART _put_usart_G100
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2060001:
	ADIW R28,3
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000019:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x200001B
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	LDI  R17,LOW(1)
	RJMP _0x2000021
_0x2000020:
	CALL SUBOPT_0x17
_0x2000021:
	RJMP _0x200001E
_0x200001F:
	CPI  R30,LOW(0x1)
	BRNE _0x2000022
	CPI  R18,37
	BRNE _0x2000023
	CALL SUBOPT_0x17
	RJMP _0x20000CF
_0x2000023:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000024
	LDI  R16,LOW(1)
	RJMP _0x200001E
_0x2000024:
	CPI  R18,43
	BRNE _0x2000025
	LDI  R20,LOW(43)
	RJMP _0x200001E
_0x2000025:
	CPI  R18,32
	BRNE _0x2000026
	LDI  R20,LOW(32)
	RJMP _0x200001E
_0x2000026:
	RJMP _0x2000027
_0x2000022:
	CPI  R30,LOW(0x2)
	BRNE _0x2000028
_0x2000027:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000029
	ORI  R16,LOW(128)
	RJMP _0x200001E
_0x2000029:
	RJMP _0x200002A
_0x2000028:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001E
_0x200002A:
	CPI  R18,48
	BRLO _0x200002D
	CPI  R18,58
	BRLO _0x200002E
_0x200002D:
	RJMP _0x200002C
_0x200002E:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001E
_0x200002C:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000032
	CALL SUBOPT_0x18
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x19
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x73)
	BRNE _0x2000035
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x70)
	BRNE _0x2000038
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000036:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x64)
	BREQ _0x200003C
	CPI  R30,LOW(0x69)
	BRNE _0x200003D
_0x200003C:
	ORI  R16,LOW(4)
	RJMP _0x200003E
_0x200003D:
	CPI  R30,LOW(0x75)
	BRNE _0x200003F
_0x200003E:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x58)
	BRNE _0x2000042
	ORI  R16,LOW(8)
	RJMP _0x2000043
_0x2000042:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000074
_0x2000043:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x2000040:
	SBRS R16,2
	RJMP _0x2000045
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000046
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000046:
	CPI  R20,0
	BREQ _0x2000047
	SUBI R17,-LOW(1)
	RJMP _0x2000048
_0x2000047:
	ANDI R16,LOW(251)
_0x2000048:
	RJMP _0x2000049
_0x2000045:
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
_0x2000049:
_0x2000039:
	SBRC R16,0
	RJMP _0x200004A
_0x200004B:
	CP   R17,R21
	BRSH _0x200004D
	SBRS R16,7
	RJMP _0x200004E
	SBRS R16,2
	RJMP _0x200004F
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x2000050
_0x200004F:
	LDI  R18,LOW(48)
_0x2000050:
	RJMP _0x2000051
_0x200004E:
	LDI  R18,LOW(32)
_0x2000051:
	CALL SUBOPT_0x17
	SUBI R21,LOW(1)
	RJMP _0x200004B
_0x200004D:
_0x200004A:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x2000052
_0x2000053:
	CPI  R19,0
	BREQ _0x2000055
	SBRS R16,3
	RJMP _0x2000056
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000057
_0x2000056:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000057:
	CALL SUBOPT_0x17
	CPI  R21,0
	BREQ _0x2000058
	SUBI R21,LOW(1)
_0x2000058:
	SUBI R19,LOW(1)
	RJMP _0x2000053
_0x2000055:
	RJMP _0x2000059
_0x2000052:
_0x200005B:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005D:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005F
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005D
_0x200005F:
	CPI  R18,58
	BRLO _0x2000060
	SBRS R16,3
	RJMP _0x2000061
	SUBI R18,-LOW(7)
	RJMP _0x2000062
_0x2000061:
	SUBI R18,-LOW(39)
_0x2000062:
_0x2000060:
	SBRC R16,4
	RJMP _0x2000064
	CPI  R18,49
	BRSH _0x2000066
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000065
_0x2000066:
	RJMP _0x20000D0
_0x2000065:
	CP   R21,R19
	BRLO _0x200006A
	SBRS R16,0
	RJMP _0x200006B
_0x200006A:
	RJMP _0x2000069
_0x200006B:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x200006C
	LDI  R18,LOW(48)
_0x20000D0:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006D
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x200006E
	SUBI R21,LOW(1)
_0x200006E:
_0x200006D:
_0x200006C:
_0x2000064:
	CALL SUBOPT_0x17
	CPI  R21,0
	BREQ _0x200006F
	SUBI R21,LOW(1)
_0x200006F:
_0x2000069:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x200005C
	RJMP _0x200005B
_0x200005C:
_0x2000059:
	SBRS R16,0
	RJMP _0x2000070
_0x2000071:
	CPI  R21,0
	BREQ _0x2000073
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x19
	RJMP _0x2000071
_0x2000073:
_0x2000070:
_0x2000074:
_0x2000033:
_0x20000CF:
	LDI  R17,LOW(0)
_0x200001E:
	RJMP _0x2000019
_0x200001B:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_rx_buffer0:
	.BYTE 0x2B
_rcon:
	.BYTE 0xA

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,32
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	MOVW R26,R28
	ADIW R26,16
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,48
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	LDI  R19,LOW(0)
	LDI  R17,LOW(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5:
	SBIW R30,1
	MOVW R26,R28
	ADIW R26,48
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,32
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOV  R30,R17
	LDI  R31,0
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	MOV  R30,R19
	SUBI R19,-1
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,32
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LD   R0,Z
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	__POINTW1FN _0x0,16
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9:
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,16
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOV  R30,R17
	LDI  R31,0
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	MOV  R30,R19
	SUBI R19,-1
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,16
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LD   R0,Z
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(16)
	MUL  R30,R16
	MOVW R30,R0
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOVW R26,R0
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	SUB  R30,R26
	SBC  R31,R27
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(16)
	MUL  R30,R16
	MOVW R30,R0
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1R 23,24
	LD   R22,Z
	MOVW R26,R0
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL __SWAPW12
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x14:
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	MOVW R26,R28
	ADIW R26,1
	CALL _SubBytes
	MOVW R26,R28
	ADIW R26,1
	JMP  _ShiftRows

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x17:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ASRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __ASRB12R
__ASRB12L:
	ASR  R30
	DEC  R0
	BRNE __ASRB12L
__ASRB12R:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
