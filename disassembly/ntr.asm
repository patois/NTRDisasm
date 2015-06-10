; ---------------------------------------------------------------------------

PLGLOADER_INFO	struc ;	(sizeof=0x114)
plgCount	DCD ?
plgBufferPtr	DCD 32 dup(?)		; XREF:	init_all_plugins+3Cr
					; init_all_plugins+50r
plgSize		DCD 32 dup(?)
arm11BinStart	DCD ?
arm11BinSize	DCD ?
tid		DCD 2 dup(?)		; title	id
PLGLOADER_INFO	ends

; ---------------------------------------------------------------------------

RT_HOOK		struc ;	(sizeof=0xCC)	; XREF:	ROM:rthook_return_C821180Br
					; ROM:rthook_patch_smdhr ...
model		DCD ?
isEnabled	DCD ?			; XREF:	rtEnableHookr
funcAddr	DCD ?			; XREF:	rtEnableHook+18r
bakCode		DCD 16 dup(?)		; XREF:	rtInitHook+34w	rtInitHook+40w
jmpCode		DCD 16 dup(?)		; XREF:	rtInitHook+3Cw	rtInitHook+44w	...
callCode	DCD 16 dup(?)		; XREF:	rtInitHook+50w	rtInitHook+60w	...
RT_HOOK		ends

; ---------------------------------------------------------------------------

RT_LOCK		struc ;	(sizeof=0x4)
value		DCD ?
RT_LOCK		ends

; ---------------------------------------------------------------------------

NS_CONFIG	struc ;	(sizeof=0x238)
initMode	DCD ?			; XREF:	prepare_config_mem+64o
startupCommand	DCD ?			; XREF:	install_ntr+1F4r
hSOCU		DCD ?			; XREF:	handle_reload_packet+24r
					; setup_ntr_network_server+94r
debugBuf	DCD ?			; XREF:	init_debugger+14r
					; dispatch_client_cmd+68r ... ; offset
debugBufSize	DCD ?			; XREF:	init_debugger+Cr
					; setup_ntr_network_server+15Cw
debugPtr	DCD ?			; XREF:	init_debugger+8r
					; init_debugger+20r ...
debugReady	DCD ?			; XREF:	nsDbgPrint+20r
debugBufferLock	DCD ?			; XREF:	dispatch_client_cmd+78o
					; init_config_mem+18o
startupInfo	DCD 32 dup(?)		; XREF:	install_ntr+158r
					; install_ntr+15Cr
allowDirectScreenAccess	DCD ?
exitFlag	DCD ?			; XREF:	check_plugin_exit_flag+8r
sharedFunc	DCD 100	dup(?)		; XREF:	initSharedFunc+Cw
					; initSharedFunc+14w ...
NS_CONFIG	ends

; ---------------------------------------------------------------------------

NS_BREAKPOINT	struc ;	(sizeof=0x15C)
type		DCD ?
flag		DCD ?
addr		DCD ?
hook		RT_HOOK	?
stubCode	DCD 32 dup(?)
isEnabled	DCD ?
NS_BREAKPOINT	ends

; Input	MD5   :	83D5AFBB8D2679C587C5FB573A6E51BB
; Input	CRC32 :	AF8DF362

; File Name   :	ntr.bin
; Format      :	Binary file
; Base Address:	0000h Range: 0000h - B08Ch Loaded length: B08Ch

; Processor	  : ARM
; ARM architecture: metaarm
; Target assembler: Generic assembler for ARM
; Byte sex	  : Little endian

; ===========================================================================

; Segment type:	Pure code
		AREA ROM, CODE,	READWRITE, ALIGN=0
		; ORG 0x100100
		CODE32

; =============== S U B	R O U T	I N E =======================================


ntr_base				; DATA XREF: ntr_base+30o ntr_base+34o ...
		B		loc_100124

; ---------------------------------------------------------------------------
dword_100104	DCD 0xE1A00000		; DATA XREF: inject_ntr_into_home_menu+18o
					; ROM:off_101488o ...
cfw_01		DCD 0xE1A00000		; DATA XREF: install_ntr+24r
cfw_02		DCD 0xE1A00000		; DATA XREF: install_ntr+28r
pFunc		DCD 0xE1A00000		; DATA XREF: inject_ntr_into_home_menu+20r
					; ptr to code to inject	into home menu
size		DCD 0xE1A00000		; DATA XREF: inject_ntr_into_home_menu+24r
		DCD 0xE1A00000
		DCD 0xE1A00000
		DCD 0xE1A00000
; ---------------------------------------------------------------------------

loc_100124				; CODE XREF: ntr_basej
		STMFD		SP!, {R0-R12,LR}
		MRS		R0, CPSR
		STMFD		SP!, {R0}
		LDR		R6, =ntr_base
		ADR		R5, ntr_base
		SUB		R5, R5,	R6
		LDR		R6, =offsets_start
		LDR		R7, =offsets_end ; "/usr/lib/ld.so.1"
		ADD		R6, R6,	R5
		ADD		R7, R7,	R5


fixup_reloc				; CODE XREF: ntr_base+6Cj
		LDMIA		R6!, {R3,R4}
		CMP		R4, #0x17
		BNE		loc_100168

		ADD		R3, R3,	R5
		LDR		R4, [R3]
		ADD		R4, R4,	R5
		STR		R4, [R3]


loc_100168				; CODE XREF: ntr_base+54j
		CMP		R6, R7
		BCC		fixup_reloc

		LDR		R0, =0xFFFF8001
		ADR		R1, ntr_base ; argv
		LDR		R2, =offsets_end ; "/usr/lib/ld.so.1"
		SUB		R2, R2,	R1 ; envp
		SVC		0x54 ; 'T' ; FlushProcessDataCache
		NOP
		NOP
		MOV		R0, SP	; argc
		BL		main

		LDMFD		SP!, {R0}
		MSR		CPSR_cf, R0
		LDMFD		SP!, {R0-R12,LR}


locret_1001A0				; DATA XREF: install_ntr+178o
					; install_ntr+184o ...
		BX		LR

; End of function ntr_base

; ---------------------------------------------------------------------------
		NOP
		NOP
		NOP
		MSR		CPSR_cf, R0

; ---------------------------------------------------------------------------
off_1001B4	DCD ntr_base		; DATA XREF: ntr_base+30r
					; ROM:offsets_starto
off_1001B8	DCD offsets_start	; DATA XREF: ntr_base+3Cr
					; ROM:offsets_starto
off_1001BC	DCD offsets_end		; DATA XREF: ntr_base+40r ntr_base+78r ...
					; "/usr/lib/ld.so.1"
dword_1001C0	DCD 0xFFFF8001		; DATA XREF: ntr_base+70r
		ALIGN 0x10

; =============== S U B	R O U T	I N E =======================================


sub_1001D0				; CODE XREF: sub_1001FC+58p
					; sub_1002DC+70p

arg_0		=  0
arg_4		=  4

; FUNCTION CHUNK AT 001017F0 SIZE 00000010 BYTES

		MOV		R12, #0xFFFFFFFD
		ADD		R0, R0,	#1
		MUL		R1, R12, R1
		MOV		R12, #0x2D0
		MLA		R0, R12, R0, R1
		LDR		R1, [SP,#arg_4]
		ADD		R0, R0,	R1
		MOV		R1, R2
		MOV		R2, R3
		LDRB		R3, [SP,#arg_0]
		B		loc_1017F0

; End of function sub_1001D0


; =============== S U B	R O U T	I N E =======================================


sub_1001FC				; CODE XREF: sub_100270+38p
					; sub_100270+5Cp

var_30		= -0x30
var_2C		= -0x2C
arg_0		=  0
arg_4		=  4
arg_8		=  8
arg_C		=  0xC

		STMFD		SP!, {R0-R2,R4-R11,LR}
		MOV		R8, R1
		LDR		R6, [SP,#0x30+arg_4]
		LDR		R7, [SP,#0x30+arg_8]
		LDRB		R11, [SP,#0x30+arg_0]
		MOV		R9, R2
		MOV		R10, R3
		MOV		R4, R0
		ADD		R6, R0,	R6
		ADD		R7, R1,	R7


loc_100224				; CODE XREF: sub_1001FC+68j
		CMP		R4, R6
		BGE		loc_100268

		MOV		R5, R8


loc_100230				; CODE XREF: sub_1001FC+60j
		CMP		R5, R7
		BGE		loc_100260

		LDR		R3, [SP,#0x30+arg_C]
		MOV		R1, R5
		STR		R3, [SP,#0x30+var_2C]
		STR		R11, [SP,#0x30+var_30]
		MOV		R0, R4
		MOV		R2, R9
		MOV		R3, R10
		BL		sub_1001D0

		ADD		R5, R5,	#1
		B		loc_100230

; ---------------------------------------------------------------------------

loc_100260				; CODE XREF: sub_1001FC+38j
		ADD		R4, R4,	#1
		B		loc_100224

; ---------------------------------------------------------------------------

loc_100268				; CODE XREF: sub_1001FC+2Cj
		ADD		SP, SP,	#0xC
		LDMFD		SP!, {R4-R11,PC}

; End of function sub_1001FC


; =============== S U B	R O U T	I N E =======================================


sub_100270				; CODE XREF: display_stuff+34p
					; acquire_video+B0p ...

var_28		= -0x28
var_24		= -0x24

		STMFD		SP!, {R4-R9,LR}
		SUB		SP, SP,	#0x14
		LDR		R5, =pa_N3DS
		MOV		R4, #0xFF
		MOV		R7, R2
		MOV		R6, R3
		STR		R3, [SP,#0x30+var_28]
		LDR		R3, [R5]
		MOV		R2, R4
		STR		R3, [SP,#0x30+var_24]
		STMEA		SP, {R4,R7}
		MOV		R3, R4
		MOV		R9, R0
		MOV		R8, R1
		BL		sub_1001FC

		LDR		R3, [R5]
		STMEA		SP, {R4,R7}
		STR		R3, [SP,#0x30+var_24]
		STR		R6, [SP,#0x30+var_28]
		MOV		R0, R9
		MOV		R1, R8
		MOV		R2, R4
		MOV		R3, R4
		BL		sub_1001FC

		ADD		SP, SP,	#0x14
		LDMFD		SP!, {R4-R9,PC}

; End of function sub_100270

; ---------------------------------------------------------------------------
off_1002D8	DCD pa_N3DS		; DATA XREF: sub_100270+8r
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


sub_1002DC				; CODE XREF: sub_100378+68p

var_40		= -0x40
var_3C		= -0x3C
var_34		= -0x34
var_30		= -0x30
var_2C		= -0x2C
arg_0		=  0
arg_4		=  4
arg_8		=  8

		STMFD		SP!, {R4-R11,LR}
		SUB		SP, SP,	#0x1C
		MOV		R9, R3
		LDRB		R3, [SP,#0x40+arg_0]
		SUB		R0, R0,	#0x20
		MOV		R7, R1
		STR		R3, [SP,#0x40+var_34]
		LDRB		R3, [SP,#0x40+arg_4]
		MOV		R8, R2
		MOV		R4, #0
		STR		R3, [SP,#0x40+var_30]
		LDR		R3, =unk_1092BC
		MOV		R10, #0x80 ; '€'
		ADD		R6, R3,	R0,LSL#3


loc_100314				; CODE XREF: sub_1002DC+8Cj
		LDRB		R11, [R6,R4]
		MOV		R5, #0
		ADD		R12, R4, R8


loc_100320				; CODE XREF: sub_1002DC+80j
		ANDS		R3, R11, R10,ASR R5
		BEQ		loc_100354

		LDR		R3, [SP,#0x40+var_30]
		MOV		R1, R12
		STR		R3, [SP,#0x40+var_40]
		LDR		R3, [SP,#0x40+arg_8]
		ADD		R0, R5,	R7
		STR		R3, [SP,#0x40+var_3C]
		MOV		R2, R9
		LDR		R3, [SP,#0x40+var_34]
		STR		R12, [SP,#0x40+var_2C]
		BL		sub_1001D0

		LDR		R12, [SP,#0x40+var_2C]


loc_100354				; CODE XREF: sub_1002DC+48j
		ADD		R5, R5,	#1
		CMP		R5, #8
		BNE		loc_100320

		ADD		R4, R4,	#1
		CMP		R4, #8
		BNE		loc_100314

		ADD		SP, SP,	#0x1C
		LDMFD		SP!, {R4-R11,PC}

; End of function sub_1002DC

; ---------------------------------------------------------------------------
off_100374	DCD unk_1092BC		; DATA XREF: sub_1002DC+2Cr
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


sub_100378				; CODE XREF: display_stuff+58p
					; display_stuff+7Cp

var_38		= -0x38
var_2C		= -0x2C
arg_0		=  0
arg_4		=  4
arg_8		=  8

		STMFD		SP!, {R4-R11,LR}
		SUB		SP, SP,	#0x1C
		MOV		R8, #0
		LDRB		R10, [SP,#0x40+arg_0]
		LDRB		R11, [SP,#0x40+arg_4]
		MOV		R6, R0
		MOV		R7, R1
		MOV		R9, R3
		MOV		R4, R1
		MOV		R5, R8
		STR		R2, [SP,#0x40+var_2C]


loc_1003A4				; CODE XREF: sub_100378+74j
		MOV		R0, R6	; a1
		BL		strlen_

		CMP		R5, R0
		BCS		loc_1003F0

		LDR		R3, [SP,#0x40+arg_8]
		CMP		R4, #0x138
		ADDGT		R8, R8,	#1
		STR		R3, [SP,#0x40+var_38]
		LDR		R3, [SP,#0x40+var_2C]
		MOVGT		R4, R7
		LDRB		R0, [R6,R5]
		MOV		R1, R4
		ADD		R2, R3,	R8,LSL#3
		STMEA		SP, {R10,R11}
		MOV		R3, R9
		BL		sub_1002DC

		ADD		R4, R4,	#8
		ADD		R5, R5,	#1
		B		loc_1003A4

; ---------------------------------------------------------------------------

loc_1003F0				; CODE XREF: sub_100378+38j
		ADD		SP, SP,	#0x1C
		LDMFD		SP!, {R4-R11,PC}

; End of function sub_100378


; =============== S U B	R O U T	I N E =======================================


display_stuff				; CODE XREF: sub_100484+3Cp
					; sub_1004CC+40p ...

var_30		= -0x30
var_2C		= -0x2C
var_28		= -0x28
arg_0		=  0
arg_4		=  4

		STMFD		SP!, {R0-R10,LR}
		MOV		R5, R1
		MOV		R4, R2
		MOV		R6, R3
		MOV		R7, R0
		BL		strlen_

		LDR		R8, =pa_N3DS
		LDRB		R10, [SP,#0x30+arg_0]
		LDRB		R9, [SP,#0x30+arg_4]
		MOV		R1, R4
		MOV		R3, #0xA
		MOV		R2, R0,LSL#3
		MOV		R0, R5
		BL		sub_100270

		LDR		R3, [R8]
		MOV		R0, R7
		STR		R3, [SP,#0x30+var_28]
		MOV		R1, R5
		MOV		R2, R4
		MOV		R3, R6
		STR		R10, [SP,#0x30+var_30]
		STR		R9, [SP,#0x30+var_2C]
		BL		sub_100378

		LDR		R3, [R8]
		STR		R10, [SP,#0x30+var_30]
		STR		R3, [SP,#0x30+var_28]
		STR		R9, [SP,#0x30+var_2C]
		MOV		R0, R7
		MOV		R1, R5
		MOV		R2, R4
		MOV		R3, R6
		BL		sub_100378

		ADD		SP, SP,	#0x10
		LDMFD		SP!, {R4-R10,PC}

; End of function display_stuff

; ---------------------------------------------------------------------------
off_100480	DCD pa_N3DS		; DATA XREF: display_stuff+18r
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


sub_100484

var_20		= -0x20
var_1C		= -0x1C
var_14		= -0x14
arg_0		=  0
arg_4		=  4

		STMFD		SP!, {R0-R6,LR}
		MOV		R6, R1
		MOV		R5, R2
		ADD		R1, SP,	#0x20+var_14
		MOV		R2, #3
		MOV		R4, R3
		BL		sub_10181C

		LDRB		R3, [SP,#0x20+arg_0]
		ADD		R0, SP,	#0x20+var_14
		MOV		R1, R6
		STR		R3, [SP,#0x20+var_20]
		LDRB		R3, [SP,#0x20+arg_4]
		MOV		R2, R5
		STR		R3, [SP,#0x20+var_1C]
		MOV		R3, R4
		BL		display_stuff

		ADD		SP, SP,	#0x10
		LDMFD		SP!, {R4-R6,PC}

; End of function sub_100484


; =============== S U B	R O U T	I N E =======================================


sub_1004CC

var_30		= -0x30
var_2C		= -0x2C
var_24		= -0x24
arg_0		=  0
arg_4		=  4

		STMFD		SP!, {R4-R6,LR}
		SUB		SP, SP,	#0x20
		MOV		R6, R1
		MOV		R5, R2
		ADD		R1, SP,	#0x30+var_24
		MOV		R2, #0x11
		MOV		R4, R3
		BL		sub_101858

		LDRB		R3, [SP,#0x30+arg_0]
		ADD		R0, SP,	#0x30+var_24
		MOV		R1, R6
		STR		R3, [SP,#0x30+var_30]
		LDRB		R3, [SP,#0x30+arg_4]
		MOV		R2, R5
		STR		R3, [SP,#0x30+var_2C]
		MOV		R3, R4
		BL		display_stuff

		ADD		SP, SP,	#0x20
		LDMFD		SP!, {R4-R6,PC}

; End of function sub_1004CC


; =============== S U B	R O U T	I N E =======================================


sub_100518
		STMFD		SP!, {R4-R8,LR}
		MOV		R8, R1
		MOV		R7, R0
		BL		read_tid_and_pid_reg

		MOV		R3, #0x10000
		STR		R3, [R0]
		LDR		R3, =0x800002
		MOV		R4, R0
		LDR		R6, [R0,#0x100]
		LDR		R5, [R0,#0x104]
		STR		R3, [R0,#0x100]
		STR		R8, [R0,#0x104]
		MOV		R0, R7
		BL		SendSyncRequest

		CMP		R0, #0
		STREQ		R6, [R4,#0x100]
		STREQ		R5, [R4,#0x104]
		LDREQ		R0, [R4,#4]
		LDMFD		SP!, {R4-R8,PC}

; End of function sub_100518

; ---------------------------------------------------------------------------
dword_100564	DCD 0x800002		; DATA XREF: sub_100518+18r

; =============== S U B	R O U T	I N E =======================================


sub_100568
		STMFD		SP!, {R3-R9,LR}
		MOV		R5, R1
		MOV		R9, R2
		MOV		R8, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0x260042
		STMIA		R0, {R3,R9}
		LDR		R3, =0x800002
		MOV		R4, R0
		LDR		R7, [R0,#0x100]
		LDR		R6, [R0,#0x104]
		STR		R3, [R0,#0x100]
		STR		R5, [R0,#0x104]
		STR		R3, [R0,#8]
		STR		R5, [R0,#0xC]
		MOV		R0, R8
		BL		SendSyncRequest

		CMP		R0, #0
		STREQ		R7, [R4,#0x100]
		STREQ		R6, [R4,#0x104]
		LDREQ		R0, [R4,#4]
		LDMFD		SP!, {R3-R9,PC}

; End of function sub_100568

; ---------------------------------------------------------------------------
dword_1005C0	DCD 0x260042		; DATA XREF: sub_100568+14r
dword_1005C4	DCD 0x800002		; DATA XREF: sub_100568+1Cr

; =============== S U B	R O U T	I N E =======================================


_get_wifi_status			; CODE XREF: get_wifi_status+2Cp
		STMFD		SP!, {R4-R6,LR}
		MOV		R5, R1
		MOV		R6, R0
		BL		read_tid_and_pid_reg

		MOV		R3, #0xD0000
		MOV		R4, R0
		STR		R3, [R0]
		MOV		R0, R6
		BL		SendSyncRequest

		CMP		R0, #0
		LDREQ		R3, [R4,#8]
		STREQ		R3, [R5]
		LDREQ		R0, [R4,#4]
		LDMFD		SP!, {R4-R6,PC}

; End of function _get_wifi_status


; =============== S U B	R O U T	I N E =======================================


get_wifi_status

var_10		= -0x10
var_C		= -0xC

		STMFD		SP!, {R0,R1,R4,LR}
		MOV		R0, #0
		MOV		R1, SP
		LDR		R2, =aAcU ; "ac:u"
		STR		R0, [SP,#0x10+var_10]
		STR		R0, [SP,#0x10+var_C]
		BL		get_service_session_handle

		CMP		R0, #0
		BNE		loc_100650


loc_100624				; CODE XREF: get_wifi_status+34j
					; get_wifi_status+40j
		LDR		R0, [SP,#0x10+var_10]
		ADD		R1, SP,	#0x10+var_C
		BL		_get_wifi_status

		SUBS		R4, R0,	#0
		BNE		loc_100624

		LDR		R3, [SP,#0x10+var_C]
		CMP		R3, #1
		BNE		loc_100624

		LDR		R0, [SP,#0x10+var_10]
		BL		CloseHandle

		MOV		R0, R4


loc_100650				; CODE XREF: get_wifi_status+20j
		ADD		SP, SP,	#8
		LDMFD		SP!, {R4,PC}

; End of function get_wifi_status

; ---------------------------------------------------------------------------
off_100658	DCD aAcU		; DATA XREF: get_wifi_status+Cr
					; ROM:offsets_starto
					; "ac:u"

; =============== S U B	R O U T	I N E =======================================


; int __cdecl main(int argc, const char	**argv,	const char **envp)
main					; CODE XREF: ntr_base+90p
		LDR		R3, =firmware_version_internal
		LDR		R1, =0x10B18C
		MOV		R0, #0
		LDR		R3, [R3]


loc_10066C				; CODE XREF: main+1Cj
		LDR		R2, [R1]
		CMP		R3, R2
		STRCC		R0, [R3],#4
		BCC		loc_10066C

		B		install_ntr

; End of function main

; ---------------------------------------------------------------------------
off_100680	DCD firmware_version_internal ;	DATA XREF: mainr
					; ROM:offsets_starto
dword_100684	DCD 0x10B18C		; DATA XREF: main+4r
					; ROM:offsets_starto
; ---------------------------------------------------------------------------
		BX		LR


; =============== S U B	R O U T	I N E =======================================


FSUSER_Initialize			; CODE XREF: get_fs_user_handle_0+3Cp
		STMFD		SP!, {R3-R5,LR}
		MOV		R5, R0
		BL		read_tid_and_pid_reg

		LDR		R2, =0x8010002
		MOV		R3, #0x20 ; ' '
		MOV		R4, R0
		STMIA		R0, {R2,R3}
		MOV		R0, R5
		BL		SendSyncRequest

		CMP		R0, #0
		LDREQ		R0, [R4,#4]
		LDMFD		SP!, {R3-R5,PC}

; End of function FSUSER_Initialize

; ---------------------------------------------------------------------------
dword_1006BC	DCD 0x8010002		; DATA XREF: FSUSER_Initialize+Cr
; ---------------------------------------------------------------------------
		SUB		SP, SP,	#8
		STMFD		SP!, {R3-R7,LR}
		MOV		R6, R1
		ADD		R1, SP,	#0x14
		LDR		R5, [SP,#0x34]
		STMIB		R1, {R2,R3}
		MOV		R7, R0
		BL		read_tid_and_pid_reg

		LDR		R2, =0x80201C2
		MOV		R3, #0
		STMIA		R0, {R2,R3}
		LDR		R3, [SP,#0x28]
		STR		R5, [R0,#0x14]
		STR		R3, [R0,#8]
		LDR		R3, [SP,#0x2C]
		MOV		R5, R5,LSL#14
		STR		R3, [R0,#0xC]
		LDRB		R3, [SP,#0x30]
		ORR		R5, R5,	#2
		STR		R5, [R0,#0x20]
		STR		R3, [R0,#0x10]
		LDR		R3, [SP,#0x3C]
		MOV		R4, R0
		STR		R3, [R0,#0x18]
		LDR		R3, [SP,#0x40]
		STR		R3, [R0,#0x1C]
		LDR		R3, [SP,#0x38]
		STR		R3, [R0,#0x24]
		MOV		R0, R7
		BL		SendSyncRequest

		CMP		R0, #0
		BNE		loc_100750

		CMP		R6, #0
		LDRNE		R3, [R4,#0xC]
		STRNE		R3, [R6]
		LDR		R0, [R4,#4]


loc_100750				; CODE XREF: ROM:0010073Cj
		LDMFD		SP!, {R3-R7,LR}
		ADD		SP, SP,	#8
		BX		LR

; ---------------------------------------------------------------------------
dword_10075C	DCD 0x80201C2		; DATA XREF: ROM:001006E0r

; =============== S U B	R O U T	I N E =======================================


openFile_				; CODE XREF: handle_savefile_packet+8Cp
					; handle_reload_packet+8Cp ...

var_C		= -0xC
var_8		= -8
var_4		= -4
arg_0		=  0
arg_4		=  4
arg_10		=  0x10
arg_14		=  0x14
arg_18		=  0x18
arg_1C		=  0x1C
arg_20		=  0x20

		SUB		SP, SP,	#8
		STMFD		SP!, {R4-R8,LR}
		MOV		R8, R1
		ADD		R1, SP,	#0x20+var_C
		LDR		R6, [SP,#0x20+arg_14]
		STMIB		R1, {R2,R3}
		MOV		R7, R0
		LDR		R5, [SP,#0x20+arg_0]
		BL		read_tid_and_pid_reg

		LDR		R2, =0x8030204
		MOV		R3, #0
		STMIA		R0, {R2,R3}
		LDR		R3, [SP,#0x20+var_8]
		STR		R5, [R0,#0x10]
		STR		R3, [R0,#8]
		LDRB		R3, [SP,#0x20+var_4]
		MOV		R5, R5,LSL#14
		STR		R6, [R0,#0x18]
		STR		R3, [R0,#0xC]
		LDRB		R3, [SP,#0x20+arg_10]
		ORR		R5, R5,	#0x800
		MOV		R6, R6,LSL#14
		STR		R3, [R0,#0x14]
		LDR		R3, [SP,#0x20+arg_1C]
		ORR		R5, R5,	#2
		STR		R3, [R0,#0x1C]
		LDR		R3, [SP,#0x20+arg_20]
		ORR		R6, R6,	#2
		STR		R3, [R0,#0x20]
		LDR		R3, [SP,#0x20+arg_4]
		STR		R5, [R0,#0x24]
		STR		R3, [R0,#0x28]
		LDR		R3, [SP,#0x20+arg_18]
		STR		R6, [R0,#0x2C]
		STR		R3, [R0,#0x30]
		MOV		R4, R0
		MOV		R0, R7
		BL		SendSyncRequest

		CMP		R0, #0
		BNE		loc_100810

		CMP		R8, #0
		LDRNE		R3, [R4,#0xC]
		STRNE		R3, [R8]
		LDR		R0, [R4,#4]


loc_100810				; CODE XREF: openFile_+9Cj
		LDMFD		SP!, {R4-R8,LR}
		ADD		SP, SP,	#8
		BX		LR

; End of function openFile_

; ---------------------------------------------------------------------------
dword_10081C	DCD 0x8030204		; DATA XREF: openFile_+24r

; =============== S U B	R O U T	I N E =======================================


FSUSER_OpenArchive_			; CODE XREF: ROM:00101144p
					; load_all_plugins_and_inject_ntr_into_pm+4Cp
		CMP		R1, #0
		BEQ		loc_100898

		STMFD		SP!, {R4-R6,LR}
		MOV		R5, R1
		MOV		R6, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0x80C00C2
		STR		R3, [R0]
		LDR		R3, [R5]
		MOV		R4, R0
		STR		R3, [R0,#4]
		LDRB		R3, [R5,#4]
		STR		R3, [R0,#8]
		LDR		R3, [R5,#8]
		STR		R3, [R0,#0xC]
		LDR		R3, [R5,#8]
		MOV		R3, R3,LSL#14
		ORR		R3, R3,	#2
		STR		R3, [R0,#0x10]
		LDR		R3, [R5,#0xC]
		STR		R3, [R0,#0x14]
		MOV		R0, R6
		BL		SendSyncRequest

		CMP		R0, #0
		LDREQ		R3, [R4,#8]
		STREQ		R3, [R5,#0x10]
		LDREQ		R3, [R4,#0xC]
		STREQ		R3, [R5,#0x14]
		LDREQ		R0, [R4,#4]
		LDMFD		SP!, {R4-R6,PC}

; ---------------------------------------------------------------------------

loc_100898				; CODE XREF: FSUSER_OpenArchive_+4j
		MOV		R0, #0xFFFFFFFE
		BX		LR

; End of function FSUSER_OpenArchive_

; ---------------------------------------------------------------------------
dword_1008A0	DCD 0x80C00C2		; DATA XREF: FSUSER_OpenArchive_+18r

; =============== S U B	R O U T	I N E =======================================


FSUSER_OpenDirectory_			; CODE XREF: sub_100F48+88p
					; find_files_+64p

var_C		= -0xC
arg_8		=  8
arg_C		=  0xC
arg_10		=  0x10
arg_14		=  0x14
arg_18		=  0x18

		SUB		SP, SP,	#8
		STMFD		SP!, {R3-R7,LR}
		MOV		R6, R1
		ADD		R1, SP,	#0x20+var_C
		LDR		R5, [SP,#0x20+arg_14]
		STMIB		R1, {R2,R3}
		MOV		R7, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0x80B0102
		STR		R3, [R0]
		LDR		R3, [SP,#0x20+arg_8]
		STR		R5, [R0,#0x10]
		STR		R3, [R0,#4]
		LDR		R3, [SP,#0x20+arg_C]
		MOV		R5, R5,LSL#14
		STR		R3, [R0,#8]
		LDRB		R3, [SP,#0x20+arg_10]
		ORR		R5, R5,	#2
		STR		R5, [R0,#0x14]
		STR		R3, [R0,#0xC]
		LDR		R3, [SP,#0x20+arg_18]
		MOV		R4, R0
		STR		R3, [R0,#0x18]
		MOV		R0, R7
		BL		SendSyncRequest

		CMP		R0, #0
		BNE		loc_100920

		CMP		R6, #0
		LDRNE		R3, [R4,#0xC]
		STRNE		R3, [R6]
		LDR		R0, [R4,#4]


loc_100920				; CODE XREF: FSUSER_OpenDirectory_+68j
		LDMFD		SP!, {R3-R7,LR}
		ADD		SP, SP,	#8
		BX		LR

; End of function FSUSER_OpenDirectory_

; ---------------------------------------------------------------------------
dword_10092C	DCD 0x80B0102		; DATA XREF: FSUSER_OpenDirectory_+20r

; =============== S U B	R O U T	I N E =======================================


sub_100930				; CODE XREF: ROM:0010118Cp
		CMP		R1, #0
		BEQ		loc_100978

		STMFD		SP!, {R4-R6,LR}
		MOV		R5, R1
		MOV		R6, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0x80E0080
		STR		R3, [R0]
		LDR		R3, [R5,#0x10]
		MOV		R4, R0
		STR		R3, [R0,#4]
		LDR		R3, [R5,#0x14]
		STR		R3, [R0,#8]
		MOV		R0, R6
		BL		SendSyncRequest

		CMP		R0, #0
		LDREQ		R0, [R4,#4]
		LDMFD		SP!, {R4-R6,PC}

; ---------------------------------------------------------------------------

loc_100978				; CODE XREF: sub_100930+4j
		MOV		R0, #0xFFFFFFFE
		BX		LR

; End of function sub_100930

; ---------------------------------------------------------------------------
dword_100980	DCD 0x80E0080		; DATA XREF: sub_100930+18r

; =============== S U B	R O U T	I N E =======================================


FSFile_Close				; CODE XREF: j_FSFile_Closej
					; ROM:00107568p
		STMFD		SP!, {R3-R5,LR}
		MOV		R5, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0x8080000
		MOV		R4, R0
		STR		R3, [R0]
		MOV		R0, R5
		BL		SendSyncRequest

		CMP		R0, #0
		LDREQ		R0, [R4,#4]
		LDMFD		SP!, {R3-R5,PC}

; End of function FSFile_Close

; ---------------------------------------------------------------------------
dword_1009B0	DCD 0x8080000		; DATA XREF: FSFile_Close+Cr

; =============== S U B	R O U T	I N E =======================================


FSFILE_Read				; CODE XREF: handle_reload_packet+110p
					; rtLoadFileToBuffer+F0p ...

arg_0		=  0
arg_4		=  4

		STMFD		SP!, {R3-R9,LR}
		MOV		R9, R2
		MOV		R8, R3
		LDR		R5, [SP,#0x20+arg_4]
		MOV		R7, R0
		MOV		R6, R1
		BL		read_tid_and_pid_reg

		LDR		R3, =0x80200C2
		STR		R5, [R0,#0xC]
		STMIA		R0, {R3,R9}
		MOV		R5, R5,LSL#4
		LDR		R3, [SP,#0x20+arg_0]
		ORR		R5, R5,	#0xC
		STR		R8, [R0,#8]
		STR		R5, [R0,#0x10]
		STR		R3, [R0,#0x14]
		MOV		R4, R0
		MOV		R0, R7
		BL		SendSyncRequest

		CMP		R0, #0
		LDMNEFD		SP!, {R3-R9,PC}

		CMP		R6, #0
		LDRNE		R3, [R4,#8]
		STRNE		R3, [R6]
		LDR		R0, [R4,#4]
		LDMFD		SP!, {R3-R9,PC}

; End of function FSFILE_Read

; ---------------------------------------------------------------------------
dword_100A1C	DCD 0x80200C2		; DATA XREF: FSFILE_Read+1Cr

; =============== S U B	R O U T	I N E =======================================


_FSFile_Write				; CODE XREF: handle_savefile_packet+FCp
					; dump_process_to_file+16Cp ...

arg_0		=  0
arg_4		=  4
arg_8		=  8

		STMFD		SP!, {R3-R9,LR}
		MOV		R9, R2
		MOV		R8, R3
		LDR		R5, [SP,#0x20+arg_4]
		MOV		R7, R0
		MOV		R6, R1
		BL		read_tid_and_pid_reg

		LDR		R3, =0x8030102
		STMIA		R0, {R3,R9}
		LDR		R3, [SP,#0x20+arg_8]
		STR		R5, [R0,#0xC]
		STR		R3, [R0,#0x10]
		MOV		R5, R5,LSL#4
		LDR		R3, [SP,#0x20+arg_0]
		ORR		R5, R5,	#0xA
		STR		R8, [R0,#8]
		STR		R5, [R0,#0x14]
		STR		R3, [R0,#0x18]
		MOV		R4, R0
		MOV		R0, R7
		BL		SendSyncRequest

		CMP		R0, #0
		LDMNEFD		SP!, {R3-R9,PC}

		CMP		R6, #0
		LDRNE		R3, [R4,#8]
		STRNE		R3, [R6]
		LDR		R0, [R4,#4]
		LDMFD		SP!, {R3-R9,PC}

; End of function _FSFile_Write

; ---------------------------------------------------------------------------
dword_100A90	DCD 0x8030102		; DATA XREF: _FSFile_Write+1Cr

; =============== S U B	R O U T	I N E =======================================


FSFILE_GetSize_				; CODE XREF: handle_reload_packet+A8p
					; get_file_size+98p ...
		STMFD		SP!, {R4-R6,LR}
		MOV		R6, R0
		MOV		R5, R1
		BL		read_tid_and_pid_reg

		LDR		R3, =0x8040000
		MOV		R4, R0
		STR		R3, [R0]
		MOV		R0, R6
		BL		SendSyncRequest

		CMP		R0, #0
		LDMNEFD		SP!, {R4-R6,PC}

		CMP		R5, #0
		LDRNED		R2, [R4,#8]
		STRNED		R2, [R5]
		LDR		R0, [R4,#4]
		LDMFD		SP!, {R4-R6,PC}

; End of function FSFILE_GetSize_

; ---------------------------------------------------------------------------
dword_100AD4	DCD 0x8040000		; DATA XREF: FSFILE_GetSize_+10r
; ---------------------------------------------------------------------------
		STMFD		SP!, {R3-R7,LR}
		MOV		R7, R2
		MOV		R6, R3
		MOV		R5, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0x8050080
		MOV		R4, R0
		STMIA		R0, {R3,R7}
		STR		R6, [R0,#8]
		MOV		R0, R5
		BL		SendSyncRequest

		CMP		R0, #0
		LDREQ		R0, [R4,#4]
		LDMFD		SP!, {R3-R7,PC}

; ---------------------------------------------------------------------------
dword_100B10	DCD 0x8050080		; DATA XREF: ROM:00100AECr

; =============== S U B	R O U T	I N E =======================================


sub_100B14				; CODE XREF: sub_100F48+CCp
					; find_files_+CCp
		STMFD		SP!, {R4-R8,LR}
		MOV		R6, R2
		MOV		R8, R3
		MOV		R7, R0
		MOV		R5, R1
		BL		read_tid_and_pid_reg

		MOV		R12, #0x228
		LDR		R3, =0x8010042
		MUL		R2, R12, R6
		MOV		R2, R2,LSL#4
		ORR		R2, R2,	#0xC
		STMIA		R0, {R3,R6}
		STR		R2, [R0,#8]
		STR		R8, [R0,#0xC]
		MOV		R4, R0
		MOV		R0, R7
		BL		SendSyncRequest

		CMP		R0, #0
		LDMNEFD		SP!, {R4-R8,PC}

		CMP		R5, #0
		LDRNE		R3, [R4,#8]
		STRNE		R3, [R5]
		LDR		R0, [R4,#4]
		LDMFD		SP!, {R4-R8,PC}

; End of function sub_100B14

; ---------------------------------------------------------------------------
dword_100B74	DCD 0x8010042		; DATA XREF: sub_100B14+1Cr

; =============== S U B	R O U T	I N E =======================================


sub_100B78				; CODE XREF: sub_100F48+190p
					; find_files_+ECp
		STMFD		SP!, {R3-R5,LR}
		MOV		R5, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0x8020000
		MOV		R4, R0
		STR		R3, [R0]
		MOV		R0, R5
		BL		SendSyncRequest

		CMP		R0, #0
		LDREQ		R0, [R4,#4]
		LDMFD		SP!, {R3-R5,PC}

; End of function sub_100B78

; ---------------------------------------------------------------------------
dword_100BA4	DCD 0x8020000		; DATA XREF: sub_100B78+Cr

; =============== S U B	R O U T	I N E =======================================

; bypass cart updates

callback_return_C821180B		; DATA XREF: thread_NTR_home_injectee+24o
					; ROM:off_101358o
		LDR		R0, =0xC821180B
		BX		LR

; End of function callback_return_C821180B

; ---------------------------------------------------------------------------
dword_100BB0	DCD 0xC821180B		; DATA XREF: callback_return_C821180Br

; =============== S U B	R O U T	I N E =======================================

; enable region	free

callback_patch_smdh			; DATA XREF: thread_NTR_home_injectee+Co
					; ROM:callback_addro

ptr_SMDH	=  0
size_SMDH	=  4

		STMFD		SP!, {R0,R1,R4-R6,LR}
		LDR		R5, [SP,#0x18+size_SMDH]
		LDR		R4, [SP,#0x18+ptr_SMDH]
		LDR		R12, =rthook_patch_smdh.callCode
		STMEA		SP, {R4,R5}
		BLX		R12	; calls	original (hooked) function:
					; ---------------------------------
					; 1. executes the two backed up	instructions that have
					;    been overwritten by the function hook mechanism
					;
					; 2. executes a	ldr pc,	orig_func + 8, in order	to execute
					;    the original function
					;
					; 3. waits for the original function to	return (which will
					;    then contain:
					;
					;    R0	= return value of original function
					;    [the following registers are preserved]
					;    R4	= pointer to SMDH
					;    R5	= size of SMDH
					;
					; (for details refer to	the rtInitHook function	in the NTR plugin SDK)

		CMP		R5, #0x36C0 ; size of SMDH
		MOV		R6, R0
		BNE		invalid_smdh

		LDR		R2, [R4]
		LDR		R3, ='HDMS' ; magic
		CMP		R2, R3
		BNE		invalid_smdh

		LDR		R0, =aPatchingSmdh ; "patching smdh\n"
		ADD		R4, R4,	#0x2000
		BL		nsDbgPrint

		MOV		R3, #0x7FFFFFFF	; Nintendo defines region free as 0x7fffffff
		STR		R3, [R4,#0x18] ; patch region lockout (offset 0x2018)


invalid_smdh				; CODE XREF: callback_patch_smdh+20j
					; callback_patch_smdh+30j
		MOV		R0, R6
		ADD		SP, SP,	#8
		LDMFD		SP!, {R4-R6,PC}

; End of function callback_patch_smdh

; ---------------------------------------------------------------------------
off_100C08	DCD rthook_patch_smdh.callCode ; DATA XREF: callback_patch_smdh+Cr
					; ROM:offsets_starto
dword_100C0C	DCD 'HDMS'		; DATA XREF: callback_patch_smdh+28r
off_100C10	DCD aPatchingSmdh	; DATA XREF: callback_patch_smdh+34r
					; ROM:offsets_starto
					; "patching smdh\n"

; =============== S U B	R O U T	I N E =======================================


is_BUTTON_DL_pressed			; CODE XREF: install_ntr+1E4p
					; inject_into_nintendo_home:loc_10378Cp
		STMFD		SP!, {R3,LR}
		BL		read_pad ; #define BUTTON_A	0x00000001
					; #define BUTTON_B     0x00000002
					; #define BUTTON_SE    0x00000004
					; #define BUTTON_ST    0x00000008
					; #define BUTTON_DR	0x00000010
					; #define BUTTON_DL	0x00000020
					; #define BUTTON_DU    0x00000040
					; #define BUTTON_DD    0x00000080
					; #define BUTTON_R    0x00000100
					; #define BUTTON_L    0x00000200
					; #define BUTTON_X     0x00000400
					; #define BUTTON_Y     0x00000800

		MOV		R0, R0,LSR#5
		AND		R0, R0,	#1
		LDMFD		SP!, {R3,PC}

; End of function is_BUTTON_DL_pressed


; =============== S U B	R O U T	I N E =======================================


get_kernel_version_info			; CODE XREF: install_ntr+60p
					; install_ntr+194p
		LDR		R3, =0x1FF80000	; kernel version register
		LDR		R1, =0x22C0600 ; kernel	ver x
		LDR		R2, =0x22E0000 ; kernel	ver y
		LDR		R3, [R3]
		CMP		R3, R1
		CMPNE		R3, R2
		LDR		R2, =firmware_version_internal
		MOVEQ		R1, #1	; is supported
		MOVEQ		R1, #0x5C ; '\'
		STREQ		R1, [R2]
		LDREQ		R1, =process_manager_patch_addr
		LDREQ		R0, =p_some_code
		MOVNE		R1, #0
		STRNE		R1, [R2]
		STREQ		R0, [R1]
		LDR		R1, =0x22D0500
		CMP		R3, R1
		MOVEQ		R3, #0x51 ; 'Q'
		STREQ		R3, [R2]
		LDREQ		R3, =process_manager_patch_addr
		LDREQ		R1, =loc_10308C
		LDR		R0, [R2]
		STREQ		R1, [R3]
		BX		LR

; End of function get_kernel_version_info

; ---------------------------------------------------------------------------
dword_100C88	DCD 0x1FF80000		; DATA XREF: get_kernel_version_infor
dword_100C8C	DCD 0x22C0600		; DATA XREF: get_kernel_version_info+4r
dword_100C90	DCD 0x22E0000		; DATA XREF: get_kernel_version_info+8r
off_100C94	DCD firmware_version_internal ;	DATA XREF: get_kernel_version_info+18r
					; ROM:offsets_starto
off_100C98	DCD process_manager_patch_addr ; DATA XREF: get_kernel_version_info+28r
					; get_kernel_version_info+4Cr ...
off_100C9C	DCD p_some_code		; DATA XREF: get_kernel_version_info+2Cr
dword_100CA0	DCD 0x22D0500		; DATA XREF: get_kernel_version_info+3Cr
off_100CA4	DCD loc_10308C		; DATA XREF: get_kernel_version_info+50r

; =============== S U B	R O U T	I N E =======================================


get_nintendo_home_version_info		; CODE XREF: install_ntr+5Cp
					; install_ntr+190p

size		= -0x18
home_ver	= -0x10
hSrc		= -0xC

		STMFD		SP!, {R0-R4,LR}
		MOV		R3, #0
		LDR		R4, =firmware_version_internal
		STR		R3, [SP,#0x18+home_ver]
		ADD		R0, SP,	#0x18+hSrc
		STR		R3, [R4,#(nintendo_home_version	- 0x10A924)]
		LDR		R3, =pid_of_home_menu
		LDR		R1, [R3]
		BL		OpenProcess

		MOV		R3, #4
		STR		R3, [SP,#0x18+size] ; size
		LDR		R2, [SP,#0x18+hSrc] ; hSrc
		MOV		R3, #0x200000 ;	src_addr
		LDR		R0, =0xFFFF8001	; hDst
		ADD		R1, SP,	#0x18+home_ver ; dst_addr
		BL		inter_process_dma_copy

		LDR		R3, [SP,#0x18+home_ver]
		LDR		R2, =0xE59F80F4
		CMP		R3, R2
		BNE		loc_100D2C

		MOV		R3, #0x5C ; '\'
		STR		R3, [R4,#(nintendo_home_version	- 0x10A924)]
		LDR		R3, =nintendo_home_FlushDataCache_addr
		LDR		R2, =0x131208
		STR		R2, [R3]
		LDR		R3, =nintendo_home_FSFile_Read_addr ; FSFile:Read
		LDR		R2, =0x12F6EC
		STR		R2, [R3] ; FSFile:Read
		LDR		R3, =nintendo_home_nss_CardUpdateInitialize_addr ; nss:CardUpdateInitialize
		LDR		R2, =0x139900
		STR		R2, [R3] ; nss:CardUpdateInitialize
		LDR		R2, =0x2F0EFC
		B		loc_100D68

; ---------------------------------------------------------------------------

loc_100D2C				; CODE XREF: get_nintendo_home_version_info+4Cj
		LDR		R2, =0xE28DD008
		CMP		R3, R2
		BNE		loc_100D78

		MOV		R3, #0x5B ; '['
		STR		R3, [R4,#(nintendo_home_version	- 0x10A924)]
		LDR		R3, =nintendo_home_FlushDataCache_addr
		LDR		R2, =0x131208
		STR		R2, [R3]
		LDR		R3, =nintendo_home_FSFile_Read_addr ; FSFile:Read
		LDR		R2, =0x12F6EC
		STR		R2, [R3] ; FSFile:Read
		LDR		R3, =nintendo_home_nss_CardUpdateInitialize_addr ; nss:CardUpdateInitialize
		LDR		R2, =0x139900
		STR		R2, [R3] ; nss:CardUpdateInitialize
		LDR		R2, =0x2F1EFC


loc_100D68				; CODE XREF: get_nintendo_home_version_info+80j
		LDR		R3, =nintendo_home_ptr_fsuser_handle
		STR		R2, [R3]
		LDR		R2, =0x131C98
		B		loc_100E0C

; ---------------------------------------------------------------------------

loc_100D78				; CODE XREF: get_nintendo_home_version_info+8Cj
		LDR		R2, =0xE1B03F02
		CMP		R3, R2
		BNE		loc_100DC4

		MOV		R3, #0x5A ; 'Z'
		STR		R3, [R4,#(nintendo_home_version	- 0x10A924)]
		LDR		R3, =nintendo_home_FlushDataCache_addr
		LDR		R2, =0x130CFC
		STR		R2, [R3]
		LDR		R3, =nintendo_home_FSFile_Read_addr ; FSFile:Read
		LDR		R2, =0x12F224
		STR		R2, [R3] ; FSFile:Read
		LDR		R3, =nintendo_home_nss_CardUpdateInitialize_addr ; nss:CardUpdateInitialize
		LDR		R2, =0x1393F4
		STR		R2, [R3] ; nss:CardUpdateInitialize
		LDR		R3, =nintendo_home_ptr_fsuser_handle
		LDR		R2, =0x2EFEFC
		STR		R2, [R3]
		LDR		R2, =0x13178C
		B		loc_100E0C

; ---------------------------------------------------------------------------

loc_100DC4				; CODE XREF: get_nintendo_home_version_info+D8j
		LDR		R2, =0xE28F2E19
		CMP		R3, R2
		BNE		loc_100E14

		MOV		R3, #0x51 ; 'Q'
		STR		R3, [R4,#(nintendo_home_version	- 0x10A924)]
		LDR		R3, =nintendo_home_FlushDataCache_addr
		LDR		R2, =0x129098
		STR		R2, [R3]
		LDR		R3, =nintendo_home_FSFile_Read_addr ; FSFile:Read
		LDR		R2, =0x11AAB8
		STR		R2, [R3] ; FSFile:Read
		LDR		R3, =nintendo_home_nss_CardUpdateInitialize_addr ; nss:CardUpdateInitialize
		LDR		R2, =0x13339C
		STR		R2, [R3] ; nss:CardUpdateInitialize
		LDR		R3, =nintendo_home_ptr_fsuser_handle
		LDR		R2, =0x278E4C
		STR		R2, [R3]
		LDR		R2, =0x129BFC


loc_100E0C				; CODE XREF: get_nintendo_home_version_info+CCj
					; get_nintendo_home_version_info+118j
		LDR		R3, =nintendo_home_applet_start_hook_addr
		STR		R2, [R3]


loc_100E14				; CODE XREF: get_nintendo_home_version_info+124j
		LDR		R0, [SP,#0x18+hSrc]
		BL		CloseHandle

		LDR		R0, [R4,#4]
		ADD		SP, SP,	#0x10
		LDMFD		SP!, {R4,PC}

; End of function get_nintendo_home_version_info

; ---------------------------------------------------------------------------
off_100E28	DCD firmware_version_internal ;	DATA XREF: get_nintendo_home_version_info+8r
					; ROM:offsets_starto
off_100E2C	DCD pid_of_home_menu	; DATA XREF: get_nintendo_home_version_info+18r
					; ROM:offsets_starto
; unsigned int hDst
hDst		DCD 0xFFFF8001		; DATA XREF: get_nintendo_home_version_info+34r
dword_100E34	DCD 0xE59F80F4		; DATA XREF: get_nintendo_home_version_info+44r
off_100E38	DCD nintendo_home_FlushDataCache_addr
					; DATA XREF: get_nintendo_home_version_info+58r
					; get_nintendo_home_version_info+98r ...
dword_100E3C	DCD 0x131208		; DATA XREF: get_nintendo_home_version_info+5Cr
					; get_nintendo_home_version_info+9Cr
off_100E40	DCD nintendo_home_FSFile_Read_addr
					; DATA XREF: get_nintendo_home_version_info+64r
					; get_nintendo_home_version_info+A4r ...
					; FSFile:Read
dword_100E44	DCD 0x12F6EC		; DATA XREF: get_nintendo_home_version_info+68r
					; get_nintendo_home_version_info+A8r
off_100E48	DCD nintendo_home_nss_CardUpdateInitialize_addr
					; DATA XREF: get_nintendo_home_version_info+70r
					; get_nintendo_home_version_info+B0r ...
					; nss:CardUpdateInitialize
dword_100E4C	DCD 0x139900		; DATA XREF: get_nintendo_home_version_info+74r
					; get_nintendo_home_version_info+B4r
dword_100E50	DCD 0x2F0EFC		; DATA XREF: get_nintendo_home_version_info+7Cr
dword_100E54	DCD 0xE28DD008		; DATA XREF: get_nintendo_home_version_info:loc_100D2Cr
dword_100E58	DCD 0x2F1EFC		; DATA XREF: get_nintendo_home_version_info+BCr
off_100E5C	DCD nintendo_home_ptr_fsuser_handle
					; DATA XREF: get_nintendo_home_version_info:loc_100D68r
					; get_nintendo_home_version_info+108r ...
dword_100E60	DCD 0x131C98		; DATA XREF: get_nintendo_home_version_info+C8r
dword_100E64	DCD 0xE1B03F02		; DATA XREF: get_nintendo_home_version_info:loc_100D78r
dword_100E68	DCD 0x130CFC		; DATA XREF: get_nintendo_home_version_info+E8r
dword_100E6C	DCD 0x12F224		; DATA XREF: get_nintendo_home_version_info+F4r
dword_100E70	DCD 0x1393F4		; DATA XREF: get_nintendo_home_version_info+100r
dword_100E74	DCD 0x2EFEFC		; DATA XREF: get_nintendo_home_version_info+10Cr
dword_100E78	DCD 0x13178C		; DATA XREF: get_nintendo_home_version_info+114r
dword_100E7C	DCD 0xE28F2E19		; DATA XREF: get_nintendo_home_version_info:loc_100DC4r
dword_100E80	DCD 0x129098		; DATA XREF: get_nintendo_home_version_info+134r
dword_100E84	DCD 0x11AAB8		; DATA XREF: get_nintendo_home_version_info+140r
dword_100E88	DCD 0x13339C		; DATA XREF: get_nintendo_home_version_info+14Cr
dword_100E8C	DCD 0x278E4C		; DATA XREF: get_nintendo_home_version_info+158r
dword_100E90	DCD 0x129BFC		; DATA XREF: get_nintendo_home_version_info+160r
off_100E94	DCD nintendo_home_applet_start_hook_addr
					; DATA XREF: get_nintendo_home_version_info:loc_100E0Cr
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


lcd_solid_fill				; CODE XREF: thread_setup_ntr_network_server+Cp
					; thread_setup_ntr_network_server+1Cp ...
		STMFD		SP!, {R3-R7,LR}
		MOV		R5, R0
		LDR		R7, =pid_of_home_menu
		MOV		R6, R1
		MOV		R4, #0


loc_100EAC				; CODE XREF: lcd_solid_fill+34j
		CMP		R4, R5
		BEQ		loc_100ED0

		LDR		R3, [R7,#(va_mapped_io_LCD - 0x10833C)]
		LDR		R0, =0x4C4B40
		MOV		R1, #0
		STR		R6, [R3,#0x204]	; offs 0x204 = REG_LCDCOLORFILLMAIN
		BL		SleepThread

		ADD		R4, R4,	#1
		B		loc_100EAC

; ---------------------------------------------------------------------------

loc_100ED0				; CODE XREF: lcd_solid_fill+18j
		LDR		R3, =pid_of_home_menu
		MOV		R2, #0
		LDR		R3, [R3,#(va_mapped_io_LCD - 0x10833C)]
		STR		R2, [R3,#0x204]
		LDMFD		SP!, {R3-R7,PC}

; End of function lcd_solid_fill

; ---------------------------------------------------------------------------
off_100EE4	DCD pid_of_home_menu	; DATA XREF: lcd_solid_fill+8r
					; lcd_solid_fill:loc_100ED0r ...
dword_100EE8	DCD 0x4C4B40		; DATA XREF: lcd_solid_fill+20r

; =============== S U B	R O U T	I N E =======================================

; Attributes: noreturn

thread_setup_ntr_network_server		; DATA XREF: install_ntr+21Co
					; ROM:off_1017E4o
		STMFD		SP!, {R3,LR}
		MOV		R0, #0x64 ; 'd'
		LDR		R1, =0x1FF0000
		BL		lcd_solid_fill

		BL		setup_ntr_network_server

		MOV		R0, #0x64 ; 'd'
		LDR		R1, =0x10000FF
		BL		lcd_solid_fill

		MOV		R0, #0
		LDMFD		SP!, {R3,LR}
		B		ExitThread

; End of function thread_setup_ntr_network_server

; ---------------------------------------------------------------------------
dword_100F18	DCD 0x1FF0000		; DATA XREF: thread_setup_ntr_network_server+8r
dword_100F1C	DCD 0x10000FF		; DATA XREF: thread_setup_ntr_network_server+18r

; =============== S U B	R O U T	I N E =======================================


fatal_LR
		STMFD		SP!, {R4,LR}
		MOV		R4, R0
		BL		acquire_video

		MOV		R1, R4
		LDR		R0, =aFatal_Lr08x ; "fatal. LR: %08x"
		MOV		R2, #0
		BL		showDbg

		LDMFD		SP!, {R4,LR}
		B		release_video

; End of function fatal_LR

; ---------------------------------------------------------------------------
off_100F44	DCD aFatal_Lr08x	; DATA XREF: fatal_LR+10r
					; ROM:offsets_starto
					; "fatal. LR: %08x"

; =============== S U B	R O U T	I N E =======================================


sub_100F48				; CODE XREF: sub_100F48+184p
					; ROM:00101180p

var_6450	= -0x6450
var_6448	= -0x6448
var_6434	= -0x6434
var_6430	= -0x6430
var_642C	= -0x642C
var_6428	= -0x6428
var_6424	= -0x6424
var_6420	= -0x6420
var_5FD8	= -0x5FD8
var_5F38	= -0x5F38
var_5058	= -0x5058
var_58		= -0x58

		SUB		SP, SP,	#0x10
		STMFD		SP!, {R4-R10,LR}
		SUB		SP, SP,	#0x6400
		SUB		SP, SP,	#0x28
		ADD		R4, SP,	#0x6458+var_58
		ADD		R4, R4,	#0x48
		ADD		R6, SP,	#0x6458+var_5058
		STMIA		R4, {R0-R3}
		ADD		R3, SP,	#0x6458+var_58
		ADD		R3, R3,	#0x60
		LDR		R9, [R3]
		ADD		R6, R6,	#0x28
		MOV		R3, #3
		MOV		R5, #0
		MOV		R0, R9	; a1
		STRB		R3, [SP,#0x6458+var_642C]
		STRB		R5, [R6]
		BL		strlen_

		ADD		R2, SP,	#0x6458+var_642C
		STR		R9, [SP,#0x6458+var_6424]
		ADD		R3, SP,	#0x6458+var_6448
		STR		R5, [SP,#0x6458+var_6434]
		ADD		R0, R0,	#1
		STR		R0, [SP,#0x6458+var_6428]
		LDMIA		R2, {R0-R2}
		STMIA		R3, {R0-R2}
		ADD		R3, SP,	#0x6458+var_58
		ADD		R3, R3,	#0x50
		LDMIA		R3, {R0-R3}
		STMEA		SP, {R0-R3}
		LDR		R1, =firmware_version_internal
		LDMIA		R4, {R2,R3}
		LDR		R0, [R1,#(hFSUser - 0x10A924)]
		ADD		R1, SP,	#0x6458+var_6434
		BL		FSUSER_OpenDirectory_

		SUBS		R2, R0,	#0
		BEQ		loc_100FF0

		MOV		R0, R6
		LDR		R1, =aFsuser_opendir ; "FSUSER_OpenDirectory failed, ret=%08x"
		BL		xsprintf

		MOV		R0, R6
		B		loc_101078

; ---------------------------------------------------------------------------

loc_100FF0				; CODE XREF: sub_100F48+90j
		MOV		R5, R2
		MOV		R7, R2
		MOV		R10, R2
		ADD		R8, SP,	#0x6458+var_6420


loc_101000				; CODE XREF: sub_100F48+120j
		MOV		R3, R8
		LDR		R0, [SP,#0x6458+var_6434]
		ADD		R1, SP,	#0x6458+var_6430
		MOV		R2, #1
		STR		R10, [SP,#0x6458+var_6430]
		BL		sub_100B14

		LDR		R3, [SP,#0x6458+var_6430]
		CMP		R3, #0
		BEQ		loc_10106C

		ADD		R2, SP,	#0x6458+var_5F38
		ADD		R2, R2,	#8
		SUB		R2, R2,	#0xA0
		ADD		R3, R6,	R7
		STR		R3, [R2,R5,LSL#2]
		MOV		R3, #0


loc_10103C				; CODE XREF: sub_100F48+110j
		LDRH		R2, [R8,R3]
		CMP		R2, #0
		BEQ		loc_10105C

		ADD		R3, R3,	#2
		CMP		R3, #0x450
		STRB		R2, [R6,R7]
		ADD		R7, R7,	#1
		BNE		loc_10103C


loc_10105C				; CODE XREF: sub_100F48+FCj
		STRB		R10, [R6,R7]
		ADD		R5, R5,	#1
		ADD		R7, R7,	#1
		B		loc_101000

; ---------------------------------------------------------------------------

loc_10106C				; CODE XREF: sub_100F48+D8j
		CMP		R5, #0
		BNE		loc_101080

		LDR		R0, =aNoFileFound_ ; "no file found."


loc_101078				; CODE XREF: sub_100F48+A4j
		BL		invoke_osd_wait_for_input

		B		loc_1010DC

; ---------------------------------------------------------------------------

loc_101080				; CODE XREF: sub_100F48+128j
					; sub_100F48+188j
		ADD		R2, SP,	#0x6458+var_5FD8
		MOV		R0, R9
		MOV		R1, R5
		ADD		R2, R2,	#8
		BL		get_process_list_action	; returns
					; 0 - dump
					; 1 - info

		CMN		R0, #1
		BEQ		loc_1010D4

		ADD		R3, R6,	R0,LSL#2
		MOV		R2, R9
		MOV		R0, R8
		LDR		R1, =aSS ; "%s%s"
		LDR		R3, [R3,#-0xFA0]
		BL		xsprintf

		ADD		R3, SP,	#0x6458+var_58
		ADD		R3, R3,	#0x58
		STR		R8, [SP,#0x6458+var_6450]
		LDMIA		R3, {R0,R1}
		STMEA		SP, {R0,R1}
		LDMIA		R4, {R0-R3}
		BL		sub_100F48

		B		loc_101080

; ---------------------------------------------------------------------------

loc_1010D4				; CODE XREF: sub_100F48+150j
		LDR		R0, [SP,#0x6458+var_6434]
		BL		sub_100B78


loc_1010DC				; CODE XREF: sub_100F48+134j
		ADD		SP, SP,	#0x6400
		ADD		SP, SP,	#0x28
		LDMFD		SP!, {R4-R10,LR}
		ADD		SP, SP,	#0x10
		BX		LR

; End of function sub_100F48

; ---------------------------------------------------------------------------
off_1010F0	DCD firmware_version_internal ;	DATA XREF: sub_100F48+78r
					; ROM:offsets_starto
off_1010F4	DCD aFsuser_opendir	; DATA XREF: sub_100F48+98r
					; ROM:offsets_starto
					; "FSUSER_OpenDirectory failed, ret=%08x"
off_1010F8	DCD aNoFileFound_	; DATA XREF: sub_100F48+12Cr
					; ROM:offsets_starto
					; "no file found."
off_1010FC	DCD aSS			; DATA XREF: sub_100F48+160r
					; ROM:offsets_starto
					; "%s%s"
; ---------------------------------------------------------------------------
		STMFD		SP!, {R4,R5,LR}
		SUB		SP, SP,	#0xF4
		ADD		R4, SP,	#0x10
		MOV		R2, #0x18
		MOV		R1, #0
		MOV		R0, R4
		BL		memset_

		LDR		R3, =0x567890AB
		LDR		R5, =firmware_version_internal
		STR		R3, [SP,#0x10]
		MOV		R3, #1
		STRB		R3, [SP,#0x14]
		STR		R3, [SP,#0x18]
		LDR		R3, =(aWillListenAtPortD+0x18)
		LDR		R0, [R5,#(hFSUser - 0x10A924)]
		MOV		R1, R4
		STR		R3, [SP,#0x1C]
		BL		FSUSER_OpenArchive_

		SUBS		R2, R0,	#0
		BEQ		loc_101168

		ADD		R0, SP,	#0x28
		LDR		R1, =aOpenarchiveFai ; "openArchive failed, ret=%08x"
		BL		xsprintf

		ADD		R0, SP,	#0x28
		BL		invoke_osd_wait_for_input

		B		loc_101190

; ---------------------------------------------------------------------------

loc_101168				; CODE XREF: ROM:0010114Cj
		LDR		R3, =asc_109BB8	; "/"
		STR		R3, [SP,#8]
		ADD		R3, SP,	#0x20
		LDMIA		R3, {R0,R1}
		STMEA		SP, {R0,R1}
		LDMIA		R4, {R0-R3}
		BL		sub_100F48

		LDR		R0, [R5,#(hFSUser - 0x10A924)]
		MOV		R1, R4
		BL		sub_100930


loc_101190				; CODE XREF: ROM:00101164j
		ADD		SP, SP,	#0xF4
		LDMFD		SP!, {R4,R5,PC}

; ---------------------------------------------------------------------------
dword_101198	DCD 0x567890AB		; DATA XREF: ROM:0010111Cr
off_10119C	DCD firmware_version_internal ;	DATA XREF: ROM:00101120r
					; ROM:offsets_starto
off_1011A0	DCD aWillListenAtPortD+0x18 ; DATA XREF: ROM:00101134r
					; ROM:offsets_starto
off_1011A4	DCD aOpenarchiveFai	; DATA XREF: ROM:00101154r
					; ROM:offsets_starto
					; "openArchive failed, ret=%08x"
off_1011A8	DCD asc_109BB8		; DATA XREF: ROM:loc_101168r
					; ROM:offsets_starto
					; "/"

; =============== S U B	R O U T	I N E =======================================


check_plugin_exit_flag			; CODE XREF: handle_network_client:loc_102EB4p
					; handle_network_client:loc_102F94p
		LDR		R3, =p_config_memory
		LDR		R3, [R3]
		LDR		R3, [R3,#NS_CONFIG.exitFlag]
		CMP		R3, #0
		BXEQ		LR

		B		ExitThread

; End of function check_plugin_exit_flag

; ---------------------------------------------------------------------------
off_1011C4	DCD p_config_memory	; DATA XREF: check_plugin_exit_flagr
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================

; purpose?

; int __cdecl set_KProcess_refcount_to_1(unsigned int pid)
set_KProcess_refcount_to_1		; CODE XREF: thread_NTR_home_injectee+C8p

hProcess	= -0x18
var_14		= -0x14
var_10		= -0x10

		STMFD		SP!, {R0-R2,R4,R5,LR}
		MOV		R1, R0
		MOV		R0, SP
		BL		OpenProcess

		SUBS		R5, R0,	#0
		BEQ		loc_1011F4

		LDR		R0, =aOpenFailed08x ; "open failed: %08x"
		MOV		R1, R5
		MOV		R2, #0
		BL		showDbg

		B		loc_101238

; ---------------------------------------------------------------------------

loc_1011F4				; CODE XREF: set_KProcess_refcount_to_1+14j
		LDR		R0, [SP,#0x18+hProcess]	; handle
		BL		arm11k_get_kernel_object ; get address of KProcess object by process handle

		ADD		R4, SP,	#0x18+var_10
		MOV		R2, #4	; count
		STR		R5, [R4,#-4]! ;	init var_14
		ADD		R5, R0,	#4 ; ptr to ref	count
		MOV		R1, R5	; src
		MOV		R0, R4	; dst
		BL		arm11k_memcpy

		MOV		R3, #1	; set ref count	to 1
		MOV		R0, R5	; dst
		MOV		R1, R4	; src
		MOV		R2, #4	; count
		STR		R3, [SP,#0x18+var_14]
		BL		arm11k_memcpy

		LDR		R0, [SP,#0x18+hProcess]
		BL		CloseHandle


loc_101238				; CODE XREF: set_KProcess_refcount_to_1+28j
		ADD		SP, SP,	#0xC
		LDMFD		SP!, {R4,R5,PC}

; End of function set_KProcess_refcount_to_1

; ---------------------------------------------------------------------------
off_101240	DCD aOpenFailed08x	; DATA XREF: set_KProcess_refcount_to_1+18r
					; ROM:offsets_starto
					; "open failed: %08x"

; =============== S U B	R O U T	I N E =======================================

; runs within context of nintendo's home menu
; Attributes: noreturn

thread_NTR_home_injectee		; DATA XREF: install_ntr+1C4o
					; ROM:off_1017D8o
		LDR		R3, =nintendo_home_FSFile_Read_addr ; FSFile:Read
		STMFD		SP!, {R4,LR}
		LDR		R1, [R3] ; funcaddr
		LDR		R2, =callback_patch_smdh ; callback_addr
		LDR		R0, =rthook_patch_smdh ; hook
		BL		rtInitHook ; hook FSFile:Read (statically linked into homemenu)	in order to disable region lock

		LDR		R0, =rthook_patch_smdh ; rthook
		BL		rtEnableHook

		LDR		R3, =nintendo_home_nss_CardUpdateInitialize_addr ; nss:CardUpdateInitialize
		LDR		R2, =callback_return_C821180B ;	callback_addr
		LDR		R0, =rthook_return_C821180B ; hook
		LDR		R1, [R3] ; funcaddr
		BL		rtInitHook ; hook nss:CardUpdateInitialize (statically linked into homemenu) in	order to bypass	mandatory cart updates

		LDR		R0, =rthook_return_C821180B ; rthook
		BL		rtEnableHook

		LDR		R3, =nintendo_home_ptr_fsuser_handle
		LDR		R4, =dword_108364
		MOV		R1, #0
		LDR		R3, [R3]
		MOV		R0, R4
		LDR		R2, [R3]
		LDR		R3, =firmware_version_internal
		STR		R2, [R3,#(hFSUser - 0x10A924)]
		MOV		R2, #0x18
		BL		memset_

		MOV		R3, #9
		STR		R3, [R4]
		MOV		R3, #1
		STRB		R3, [R4,#(dword_108368 - 0x108364)]
		STR		R3, [R4,#(dword_10836C - 0x108364)]
		LDR		R3, =(aWillListenAtPortD+0x18)
		STR		R3, [R4,#(dword_108370 - 0x108364)]
		BL		assign_rwx_to_0x1F000000

		CMP		R0, #0
		BEQ		loc_1012DC

		MOV		R0, #0x64 ; 'd'
		LDR		R1, =0x10000FF
		BL		lcd_solid_fill


loc_1012DC				; CODE XREF: thread_NTR_home_injectee+88j
		LDR		R3, =p_config_memory
		MOV		R2, #0
		LDR		R4, =is_NTR_OSD_requested
		LDR		R3, [R3]
		STR		R2, [R3]
		BL		get_srv_handle

		BL		init_config_mem

		BL		setup_ntr_network_server

		MOV		R1, #0
		LDR		R0, =0x3B9ACA00
		BL		SleepThread

		MOV		R0, #0x27 ; '''	; pid 0x27
		BL		set_KProcess_refcount_to_1 ; purpose?

		BL		load_all_plugins_and_inject_ntr_into_pm

		BL		init_builtin_screenshot_plugin


check_hotkey_loop			; CODE XREF: thread_NTR_home_injectee+100j
		BL		read_pad ; #define BUTTON_A	0x00000001
					; #define BUTTON_B     0x00000002
					; #define BUTTON_SE    0x00000004
					; #define BUTTON_ST    0x00000008
					; #define BUTTON_DR	0x00000010
					; #define BUTTON_DL	0x00000020
					; #define BUTTON_DU    0x00000040
					; #define BUTTON_DD    0x00000080
					; #define BUTTON_R    0x00000100
					; #define BUTTON_L    0x00000200
					; #define BUTTON_X     0x00000400
					; #define BUTTON_Y     0x00000800

		AND		R0, R0,	#0xC00
		CMP		R0, #0xC00 ; X & Y pressed?
		BNE		skip_NTR_OSD

		LDR		R3, [R4]
		CMP		R3, #0
		BEQ		skip_NTR_OSD

		BL		display_OSD_menu


skip_NTR_OSD				; CODE XREF: thread_NTR_home_injectee+E0j
					; thread_NTR_home_injectee+ECj
		LDR		R0, =100000000
		MOV		R1, #0
		BL		SleepThread

		B		check_hotkey_loop

; End of function thread_NTR_home_injectee

; ---------------------------------------------------------------------------
off_101348	DCD nintendo_home_FSFile_Read_addr ; DATA XREF:	thread_NTR_home_injecteer
					; ROM:offsets_starto
					; FSFile:Read
; void *callback_addr
callback_addr	DCD callback_patch_smdh	; DATA XREF: thread_NTR_home_injectee+Cr
					; ROM:offsets_starto
					; enable region	free
; RT_HOOK *rthook
rthook		DCD rthook_patch_smdh	; DATA XREF: thread_NTR_home_injectee+10r
					; thread_NTR_home_injectee+18r	...
off_101354	DCD nintendo_home_nss_CardUpdateInitialize_addr
					; DATA XREF: thread_NTR_home_injectee+20r
					; ROM:offsets_starto
					; nss:CardUpdateInitialize
; void *off_101358
off_101358	DCD callback_return_C821180B ; DATA XREF: thread_NTR_home_injectee+24r
					; ROM:offsets_starto
					; bypass cart updates
; RT_HOOK *off_10135C
off_10135C	DCD rthook_return_C821180B ; DATA XREF:	thread_NTR_home_injectee+28r
					; thread_NTR_home_injectee+34r	...
off_101360	DCD nintendo_home_ptr_fsuser_handle
					; DATA XREF: thread_NTR_home_injectee+3Cr
					; ROM:offsets_starto
off_101364	DCD dword_108364	; DATA XREF: thread_NTR_home_injectee+40r
					; ROM:offsets_starto
off_101368	DCD firmware_version_internal ;	DATA XREF: thread_NTR_home_injectee+54r
					; ROM:offsets_starto
off_10136C	DCD aWillListenAtPortD+0x18 ; DATA XREF: thread_NTR_home_injectee+78r
					; ROM:offsets_starto
dword_101370	DCD 0x10000FF		; DATA XREF: thread_NTR_home_injectee+90r
off_101374	DCD p_config_memory	; DATA XREF: thread_NTR_home_injectee:loc_1012DCr
					; ROM:offsets_starto
off_101378	DCD is_NTR_OSD_requested ; DATA	XREF: thread_NTR_home_injectee+A0r
					; ROM:offsets_starto
dword_10137C	DCD 0x3B9ACA00		; DATA XREF: thread_NTR_home_injectee+BCr
dword_101380	DCD 100000000		; DATA XREF: thread_NTR_home_injectee:skip_NTR_OSDr

; =============== S U B	R O U T	I N E =======================================


prepare_config_mem			; CODE XREF: install_ntr+148p

operation	= -0x20
permissions	= -0x1C
outaddr		= -0x14

		STMFD		SP!, {R4,R5,LR}
		MOV		R5, #0x6000000
		LDR		R4, =p_config_memory
		SUB		SP, SP,	#0x14
		MOV		R0, R5	; addr
		MOV		R1, #0x1000 ; size
		STR		R5, [R4]
		BL		protectMemory ;	assigns	RWX to addr : addr+size

		CMP		R0, #0
		BEQ		loc_1013F8

; on failure, fall back	to RW only

		MOV		R3, #3	; MEMPERM_READ | MEMPERM_WRITE
		STR		R3, [SP,#0x20+operation] ; operation
		STR		R3, [SP,#0x20+permissions] ; permissions
		MOV		R1, R5	; addr0
		ADD		R0, SP,	#0x20+outaddr ;	outaddr
		MOV		R2, #0	; addr1
		MOV		R3, #0x1000 ; size
		BL		ControlMemory

		SUBS		R5, R0,	#0
		BEQ		loc_1013E0

		LDR		R0, =aInitCfgMemoryF ; "init cfg memory failed"
		BL		invoke_osd_wait_for_input

		B		loc_1013F8

; ---------------------------------------------------------------------------

loc_1013E0				; CODE XREF: prepare_config_mem+4Cj
		LDR		R0, [R4]
		MOV		R1, R5
		MOV		R2, #sizeof(NS_CONFIG)
		BL		memset_

		LDR		R3, [R4]
		STR		R5, [R3]


loc_1013F8				; CODE XREF: prepare_config_mem+24j
					; prepare_config_mem+58j
		ADD		SP, SP,	#0x14
		LDMFD		SP!, {R4,R5,PC}

; End of function prepare_config_mem

; ---------------------------------------------------------------------------
off_101400	DCD p_config_memory	; DATA XREF: prepare_config_mem+8r
					; ROM:offsets_starto
off_101404	DCD aInitCfgMemoryF	; DATA XREF: prepare_config_mem+50r
					; ROM:offsets_starto
					; "init cfg memory failed"

; =============== S U B	R O U T	I N E =======================================

; injects code into home menu

inject_ntr_into_home_menu		; CODE XREF: install_ntr+134p

handle		= -0x244
buf		= -0x240
var_8		= -8

		STMFD		SP!, {R4,LR}
		SUB		SP, SP,	#0x240
		MOV		R1, #0
		ADD		R0, SP,	#0x248+buf
		MOV		R2, #0x238
		BL		memset_

		LDR		R3, =dword_100104
		LDR		R4, =arm11BinStart
		LDR		R2, [R3,#(pFunc	- 0x100104)] ; offs 0x0C = func	*
		LDR		R0, [R3,#(size - 0x100104)]
		STR		R2, [R4]
		BL		round_to_pagesize_

		LDR		R3, =arm11BinSize
		STR		R0, [R3]
		ADD		R0, SP,	#0x248+var_8
		MOV		R3, #0
		STR		R3, [R0,#-0x23C]!
		LDR		R3, =pid_of_home_menu
		LDR		R1, [R3]
		BL		OpenProcess

		LDR		R3, [R4]
		MOV		R2, #1
		STR		R2, [R3,#4]
		LDR		R3, =nintendo_home_FlushDataCache_addr
		ADD		R2, SP,	#0x248+buf ; buf
		LDR		R0, [SP,#0x248+handle] ; handle
		LDR		R1, [R3] ; addr_jmpcode
		BL		inject_ntr_into_remote_process ; if addr is 0, the hook	will be	placed at
					; process' current PC

		LDR		R0, [SP,#0x248+handle]
		BL		CloseHandle

		ADD		SP, SP,	#0x240
		LDMFD		SP!, {R4,PC}

; End of function inject_ntr_into_home_menu

; ---------------------------------------------------------------------------
off_101488	DCD dword_100104	; DATA XREF: inject_ntr_into_home_menu+18r
					; ROM:offsets_starto
off_10148C	DCD arm11BinStart	; DATA XREF: inject_ntr_into_home_menu+1Cr
					; ROM:offsets_starto
off_101490	DCD arm11BinSize	; DATA XREF: inject_ntr_into_home_menu+30r
					; ROM:offsets_starto
off_101494	DCD pid_of_home_menu	; DATA XREF: inject_ntr_into_home_menu+44r
					; ROM:offsets_starto
off_101498	DCD nintendo_home_FlushDataCache_addr
					; DATA XREF: inject_ntr_into_home_menu+5Cr
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


sleep_thread				; CODE XREF: install_ntr+18Cp
		STMFD		SP!, {R4,LR}
		MOV		R4, #0xA


loc_1014A4				; CODE XREF: sleep_thread+18j
		LDR		R0, =10000000
		MOV		R1, #0
		BL		SleepThread

		SUBS		R4, R4,	#1
		BNE		loc_1014A4

		LDMFD		SP!, {R4,PC}

; End of function sleep_thread

; ---------------------------------------------------------------------------
dword_1014BC	DCD 10000000		; DATA XREF: sleep_thread:loc_1014A4r

; =============== S U B	R O U T	I N E =======================================


close_all_srv_handles_			; CODE XREF: install_ntr+114p
		STMFD		SP!, {R4,LR}
		MOV		R4, #0xA


loc_1014C8				; CODE XREF: close_all_srv_handles_+20j
		BL		get_srv_handle

		BL		close_srv_handle

		LDR		R0, =0x989680
		MOV		R1, #0
		BL		SleepThread

		SUBS		R4, R4,	#1
		BNE		loc_1014C8

		LDMFD		SP!, {R4,PC}

; End of function close_all_srv_handles_

; ---------------------------------------------------------------------------
dword_1014E8	DCD 0x989680		; DATA XREF: close_all_srv_handles_+10r
; ---------------------------------------------------------------------------
		LDR		R0, =0x3B9ACA00
		STMFD		SP!, {R3,LR}
		MOV		R1, #0
		BL		SleepThread

		LDMFD		SP!, {R3,PC}

; ---------------------------------------------------------------------------
dword_101500	DCD 0x3B9ACA00		; DATA XREF: ROM:001014ECr

; =============== S U B	R O U T	I N E =======================================


; int install_ntr(void)
install_ntr				; CODE XREF: main+20j

var_1C		= -0x1C

		STMFD		SP!, {R0-R8,LR}
		LDR		R3, =dword_100104
		LDR		R7, =firmware_version_internal
		LDR		R1, [R3]
		MOV		R4, R7
		CMP		R1, #0
		STR		R1, [R7,#(install_state	- 0x10A924)]
		BNE		loc_101640

		LDR		R5, =dword_108364
		LDR		R2, [R3,#(cfw_01 - 0x100104)]
		LDR		R3, [R3,#(cfw_02 - 0x100104)]
		STR		R2, [R7,#(some_callback	- 0x10A924)]
		MOV		R0, R5
		MOV		R2, #0x18
		STR		R3, [R7,#(hFSUser - 0x10A924)]
		BL		memset_

		MOV		R3, #9
		STR		R3, [R5]
		MOV		R3, #1
		STRB		R3, [R5,#(dword_108368 - 0x108364)]
		STR		R3, [R5,#(dword_10836C - 0x108364)]
		LDR		R3, =(aWillListenAtPortD+0x18)
		STR		R3, [R5,#(dword_108370 - 0x108364)]
		BL		get_nintendo_home_version_info

		BL		get_kernel_version_info

		LDR		R3, [R7]
		CMP		R3, #0
		BNE		loc_10157C

		LDR		R0, =aFirmVersionNot ; "firm version not supported"
		BL		invoke_osd_wait_for_input


loc_10157C				; CODE XREF: install_ntr+6Cj
		LDR		R3, [R4,#4]
		CMP		R3, #0
		BNE		loc_101590

		LDR		R0, =aHomemenuVersio ; "homemenu version not supported"
		BL		invoke_osd_wait_for_input


loc_101590				; CODE XREF: install_ntr+80j
		LDR		R3, [R4,#4]
		LDR		R5, =firmware_version_internal
		CMP		R3, #0
		BEQ		loc_1015AC

		LDR		R3, [R5]
		CMP		R3, #0
		BNE		loc_10160C


loc_1015AC				; CODE XREF: install_ntr+98j
		LDR		R0, =aFirmwareVersio ; "firmware version not supported"
		BL		invoke_osd_wait_for_input

		MOV		R0, #0	; pid
		LDR		R1, =aPid0_dmp ; "/pid0.dmp"
		BL		dump_process_to_file

		MOV		R0, #2	; pid
		LDR		R1, =aPid2_dmp ; "/pid2.dmp"
		BL		dump_process_to_file

		MOV		R0, #3	; pid
		LDR		R1, =aPid3_dmp ; "/pid3.dmp"
		BL		dump_process_to_file

		MOV		R0, #0xF ; pid
		LDR		R1, =aPidf_dmp ; "/pidf.dmp"
		BL		dump_process_to_file

		LDR		R0, =0xDFF80000	; va_dumpaddr
		MOV		R1, #0x80000 ; size
		LDR		R2, =aAxiwram_dmp ; "/axiwram.dmp"
		BL		dump_memory_to_file

		LDR		R0, =aCurrentFirmwar ; "current firmware not supported. \npleas"...
		BL		invoke_osd_wait_for_input


loop					; CODE XREF: install_ntr+104j
		LDR		R0, =0x3B9ACA00
		MOV		R1, #0
		BL		SleepThread

		B		loop

; ---------------------------------------------------------------------------

loc_10160C				; CODE XREF: install_ntr+A4j
		BL		arm11k_replacel_svc_6D_handler

		LDR		R0, =aKernelhaxDone ; "kernelhax done"
		BL		invoke_osd_wait_for_input

		BL		close_all_srv_handles_

		LDR		R1, [R5,#(nintendo_home_version	- 0x10A924)]
		MOV		R2, #0
		LDR		R0, =aHomemenuVerD ; "homemenu ver: %d"
		BL		showDbg

		MOV		R0, #0x64 ; 'd'
		LDR		R1, =0x1FF0000
		BL		lcd_solid_fill

		BL		inject_ntr_into_home_menu ; injects code into home menu

		B		leave_func

; ---------------------------------------------------------------------------

loc_101640				; CODE XREF: install_ntr+1Cj
		CMP		R1, #1
		BNE		leave_func

		LDR		R5, =p_config_memory
		BL		prepare_config_mem

		BL		init_config_mem

		LDR		R3, [R5]
		MOV		R1, #8	; size
		LDR		R6, [R3,#NS_CONFIG.startupInfo+8]
		LDR		R2, [R3,#NS_CONFIG.startupInfo]!
		MOV		R0, R6	; addr
		STR		R2, [R6]
		LDR		R2, [R3,#4]
		STR		R2, [R6,#4]
		BL		flush_current_process_data_cache

		MOV		R0, R6	; dst
		LDR		R1, =locret_1001A0 ; src
		BL		rtGenerateJumpCode

		MOV		R1, #8	; size
		LDR		R0, =locret_1001A0 ; addr
		BL		flush_current_process_data_cache

		BL		sleep_thread

		BL		get_nintendo_home_version_info

		BL		get_kernel_version_info

		BL		get_current_process_id

		LDR		R3, =pid_of_home_menu
		MOV		R8, R3
		LDR		R2, [R3]
		LDR		R3, =0x6001000
		CMP		R0, R2	; current pid == pid of	nintendo home menu?
		MOV		R6, R0
		BNE		inject_code_into_nintendo_home

; this will be executed	if we're running from
; within nintendo home menu

		STR		R3, [R7,#(config_mem_offs_1000 - 0x10A924)]
		MOV		R0, #0x10
		MOV		R3, #0xFFFFFFFE
		LDR		R1, =thread_NTR_home_injectee ;	runs within context of nintendo's home menu
		STMEA		SP, {R0,R3}
		MOV		R2, #0
		ADD		R0, SP,	#0x28+var_1C
		LDR		R3, =0x6004FD8
		BL		CreateThread

		B		leave_func

; ---------------------------------------------------------------------------

inject_code_into_nintendo_home		; CODE XREF: install_ntr+1B4j
		STR		R3, [R7,#(config_mem_offs_1000 - 0x10A924)]
		BL		is_BUTTON_DL_pressed

		CMP		R0, #0
		BNE		dl_button_pressed

		LDR		R3, [R5]
		LDR		R2, [R3,#NS_CONFIG.startupCommand]
		LDR		R3, =0x3EA
		CMP		R2, R3
		BNE		check_pm_pid


dl_button_pressed			; CODE XREF: install_ntr+1ECj
		LDR		R3, [R4,#0x14]
		MOV		R1, #0x3F ; '?'
		MOV		R2, #0xFFFFFFFE
		ADD		R3, R3,	#0x3FC0
		STMEA		SP, {R1,R2}
		ADD		R0, SP,	#0x28+var_1C
		LDR		R1, =thread_setup_ntr_network_server
		MOV		R2, #0
		ADD		R3, R3,	#0x18
		BL		CreateThread

		LDR		R0, =0x3B9ACA00
		MOV		R1, #0
		BL		SleepThread


check_pm_pid				; CODE XREF: install_ntr+200j
		LDR		R3, [R8,#8] ; r8+8 = pid of pm (=2)
		CMP		R6, R3	; are we process manager?
		BNE		not_process_manager

; this will be executed	if we're running from
; within the process manager and will be used
; to force it to inject	code into nintendo home	menu

		BL		install_home_injection_hook

		B		leave_func

; ---------------------------------------------------------------------------

not_process_manager			; CODE XREF: install_ntr+240j
		LDR		R3, [R5]
		LDR		R2, [R3,#4]
		LDR		R3, =0x3E9
		CMP		R2, R3
		BNE		leave_func

		MOV		R0, #0x64 ; 'd'
		LDR		R1, =0x100FF00
		BL		lcd_solid_fill

		BL		init_all_plugins


leave_func				; CODE XREF: install_ntr+138j
					; install_ntr+140j ...
		MOV		R0, #0
		ADD		SP, SP,	#0x10
		LDMFD		SP!, {R4-R8,PC}

; End of function install_ntr

; ---------------------------------------------------------------------------
off_101780	DCD dword_100104	; DATA XREF: install_ntr+4r
					; ROM:offsets_starto
off_101784	DCD firmware_version_internal ;	DATA XREF: install_ntr+8r
					; install_ntr+90r ...
off_101788	DCD dword_108364	; DATA XREF: install_ntr+20r
					; ROM:offsets_starto
off_10178C	DCD aWillListenAtPortD+0x18 ; DATA XREF: install_ntr+54r
					; ROM:offsets_starto
off_101790	DCD aFirmVersionNot	; DATA XREF: install_ntr+70r
					; ROM:offsets_starto
					; "firm version not supported"
off_101794	DCD aHomemenuVersio	; DATA XREF: install_ntr+84r
					; ROM:offsets_starto
					; "homemenu version not supported"
off_101798	DCD aFirmwareVersio	; DATA XREF: install_ntr:loc_1015ACr
					; ROM:offsets_starto
					; "firmware version not supported"
; char *filename
filename	DCD aPid0_dmp		; DATA XREF: install_ntr+B4r
					; ROM:offsets_starto
					; "/pid0.dmp"
; char *off_1017A0
off_1017A0	DCD aPid2_dmp		; DATA XREF: install_ntr+C0r
					; ROM:offsets_starto
					; "/pid2.dmp"
; char *off_1017A4
off_1017A4	DCD aPid3_dmp		; DATA XREF: install_ntr+CCr
					; ROM:offsets_starto
					; "/pid3.dmp"
; char *off_1017A8
off_1017A8	DCD aPidf_dmp		; DATA XREF: install_ntr+D8r
					; ROM:offsets_starto
					; "/pidf.dmp"
; unsigned int va_dumpaddr
va_dumpaddr	DCD 0xDFF80000		; DATA XREF: install_ntr+E0r
; char *off_1017B0
off_1017B0	DCD aAxiwram_dmp	; DATA XREF: install_ntr+E8r
					; ROM:offsets_starto
					; "/axiwram.dmp"
off_1017B4	DCD aCurrentFirmwar	; DATA XREF: install_ntr+F0r
					; ROM:offsets_starto
					; "current firmware not supported. \npleas"...
dword_1017B8	DCD 0x3B9ACA00		; DATA XREF: install_ntr:loopr
					; install_ntr+22Cr
off_1017BC	DCD aKernelhaxDone	; DATA XREF: install_ntr+10Cr
					; ROM:offsets_starto
					; "kernelhax done"
off_1017C0	DCD aHomemenuVerD	; DATA XREF: install_ntr+120r
					; ROM:offsets_starto
					; "homemenu ver: %d"
dword_1017C4	DCD 0x1FF0000		; DATA XREF: install_ntr+12Cr
off_1017C8	DCD p_config_memory	; DATA XREF: install_ntr+144r
					; ROM:offsets_starto
; void *addr
addr		DCD locret_1001A0	; DATA XREF: install_ntr+178r
					; install_ntr+184r ...
off_1017D0	DCD pid_of_home_menu	; DATA XREF: install_ntr+19Cr
					; ROM:offsets_starto
dword_1017D4	DCD 0x6001000		; DATA XREF: install_ntr+1A8r
off_1017D8	DCD thread_NTR_home_injectee ; DATA XREF: install_ntr+1C4r
					; ROM:offsets_starto
					; runs within context of nintendo's home menu
dword_1017DC	DCD 0x6004FD8		; DATA XREF: install_ntr+1D4r
dword_1017E0	DCD 0x3EA		; DATA XREF: install_ntr+1F8r
off_1017E4	DCD thread_setup_ntr_network_server ; DATA XREF: install_ntr+21Cr
					; ROM:offsets_starto
dword_1017E8	DCD 0x3E9		; DATA XREF: install_ntr+254r
dword_1017EC	DCD 0x100FF00		; DATA XREF: install_ntr+264r
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_1001D0

loc_1017F0				; CODE XREF: sub_1001D0+28j
		STRB		R3, [R0]
		STRB		R2, [R0,#1]
		STRB		R1, [R0,#2]
		BX		LR

; END OF FUNCTION CHUNK	FOR sub_1001D0
; ---------------------------------------------------------------------------
		STRB		R1, [R0]
		BX		LR


; =============== S U B	R O U T	I N E =======================================


sub_101808				; CODE XREF: sub_10181C+18p
					; sub_10181C+24p ...
		CMP		R0, #9
		ADDLS		R0, R0,	#0x30
		ADDHI		R0, R0,	#0x37
		UXTB		R0, R0
		BX		LR

; End of function sub_101808


; =============== S U B	R O U T	I N E =======================================


sub_10181C				; CODE XREF: sub_100484+18p
		CMP		R2, #2


loc_101820				; DATA XREF: patch_sm+10o
					; ROM:off_104960o
		BLE		locret_101854

		STMFD		SP!, {R3-R5,LR}
		MOV		R5, R0
		AND		R0, R0,	#0xF
		MOV		R4, R1
		BL		sub_101808

		STRB		R0, [R4,#1]
		MOV		R0, R5,LSR#4
		BL		sub_101808

		STRB		R0, [R4]
		MOV		R0, #0
		STRB		R0, [R4,#2]
		LDMFD		SP!, {R3-R5,PC}

; ---------------------------------------------------------------------------

locret_101854				; CODE XREF: sub_10181C:loc_101820j
		BX		LR

; End of function sub_10181C


; =============== S U B	R O U T	I N E =======================================


sub_101858				; CODE XREF: sub_1004CC+1Cp
		CMP		R2, #8
		BLE		locret_1018AC

		STMFD		SP!, {R4-R8,LR}
		MOV		R4, R1
		MOV		R7, R0
		ADD		R8, R1,	#8
		MOV		R5, #0
		MOV		R6, #0xF


loc_101878				; CODE XREF: sub_101858+44j
		AND		R3, R6,	R7
		MOV		R0, R5,LSL#2
		ADD		R5, R5,	#1
		MOV		R0, R3,LSR R0
		MOV		R6, R6,LSL#4
		UXTB		R0, R0
		BL		sub_101808

		CMP		R5, #8
		STRB		R0, [R8,#-1]!
		BNE		loc_101878

		MOV		R0, #0
		STRB		R0, [R4,#8]
		LDMFD		SP!, {R4-R8,PC}

; ---------------------------------------------------------------------------

locret_1018AC				; CODE XREF: sub_101858+4j
		BX		LR

; End of function sub_101858

; ---------------------------------------------------------------------------
		SVC		0xA
		BX		LR


; =============== S U B	R O U T	I N E =======================================


cb_arm11_dispatch			; DATA XREF: ROM:p_cbo
		STMFD		SP!, {R3-R11,LR}
		MRS		R0, CPSR
		ORR		R0, R0,	#0xC0 ;	disable	fiq and	irq
		MSR		CPSR_cf, R0
		BL		dispatch_arm11_kernel_cmd ; cmd	1: memcpy
					; cmd 2: get kernel object by handle
					; cmd 3: get current kprocess
					; cmd 4: set current kprocess
					; cmd 5: ?
					; cmd 6: hook SVC 6D

		LDMFD		SP!, {R3-R11,PC}

; End of function cb_arm11_dispatch


; =============== S U B	R O U T	I N E =======================================


InvalidateEntireInstructionCache	; CODE XREF: install_SVC_6D_hook+80p
					; clean_cache+44p
		MOV		R0, #0
		MCR		p15, 0,	R0,c7,c5, 0
		BX		LR

; End of function InvalidateEntireInstructionCache


; =============== S U B	R O U T	I N E =======================================


CleanEntireDataCache			; CODE XREF: install_SVC_6D_hook+88p
					; clean_cache+4Cp
		MOV		R0, #0
		MCR		p15, 0,	R0,c7,c10, 0
		BX		LR

; End of function CleanEntireDataCache

; ---------------------------------------------------------------------------
		ALIGN 0x10

; =============== S U B	R O U T	I N E =======================================


init_debugger				; DATA XREF: init_config_mem+Co
					; ROM:off_103068o
		LDR		R2, =p_config_memory
		LDR		R3, [R2]
		LDR		R1, [R3,#NS_CONFIG.debugPtr]
		LDR		R12, [R3,#NS_CONFIG.debugBufSize]
		CMP		R1, R12
		LDRCC		R3, [R3,#NS_CONFIG.debugBuf]
		STRCCB		R0, [R3,R1]
		LDRCC		R2, [R2]
		LDRCC		R3, [R2,#NS_CONFIG.debugPtr]
		ADDCC		R3, R3,	#1
		STRCC		R3, [R2,#0x14]
		BX		LR

; End of function init_debugger

; ---------------------------------------------------------------------------
off_101920	DCD p_config_memory	; DATA XREF: init_debuggerr
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


nsDbgPrint				; CODE XREF: callback_patch_smdh+3Cp
					; handle_savefile_packet+11Cp ...

var_1C		= -0x1C
varg_r0		= -0x10
varg_r1		= -0xC
varg_r2		= -8
varg_r3		= -4

		STMFD		SP!, {R0-R3} ; sends str to connected network client
		STMFD		SP!, {R0,R1,R4,LR}
		ADD		R3, SP,	#0x20+varg_r1
		LDR		R4, =p_config_memory
		STR		R3, [SP,#0x20+var_1C]
		LDR		R0, [R4]
		CMP		R0, #0
		BEQ		loc_101970

		LDR		R3, [R0,#NS_CONFIG.debugReady]
		CMP		R3, #0
		BEQ		loc_101970

		ADD		R0, R0,	#0x1C ;	lock
		BL		rtAcquireLock

		LDR		R0, [SP,#0x20+varg_r0]
		LDR		R1, [SP,#0x20+var_1C]
		BL		sub_107614

		LDR		R0, [R4]
		ADD		R0, R0,	#0x1C ;	lock
		BL		rtReleaseLock


loc_101970				; CODE XREF: nsDbgPrint+1Cj
					; nsDbgPrint+28j
		ADD		SP, SP,	#8
		LDMFD		SP!, {R4,LR}
		ADD		SP, SP,	#0x10
		BX		LR

; End of function nsDbgPrint

; ---------------------------------------------------------------------------
off_101980	DCD p_config_memory	; DATA XREF: nsDbgPrint+Cr
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


sub_101984				; CODE XREF: handle_readmem_packet+94p
					; dispatch_client_cmd+54p
		LDR		R3, =dword_10AAF4
		LDR		R3, [R3]
		ADD		R1, R3,	#0x2000
		LDR		R0, [R3,#8]
		LDR		R2, [R1,#0x74]
		ADD		R1, R1,	#0x24
		STR		R2, [R1,#0x54]
		MOV		R2, #0x54 ; 'T'
		B		sub_104C40

; End of function sub_101984

; ---------------------------------------------------------------------------
off_1019A8	DCD dword_10AAF4	; DATA XREF: sub_101984r
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


sub_1019AC				; CODE XREF: handle_readmem_packet+128p
					; dispatch_client_cmd+6Cp
		LDR		R3, =dword_10AAF4
		STMFD		SP!, {R4,LR}
		MOV		R2, R1
		LDR		R12, [R3]
		ADD		LR, R12, #0x2000
		LDR		R1, [LR,#0x78]
		CMP		R1, R2
		BCC		loc_1019E8

		MOV		R4, R0
		RSB		R3, R2,	R1
		STR		R3, [LR,#0x78]
		MOV		R1, R4
		LDR		R0, [R12,#8]
		LDMFD		SP!, {R4,LR}
		B		sub_104C40

; ---------------------------------------------------------------------------

loc_1019E8				; CODE XREF: sub_1019AC+1Cj
		LDR		R0, =aSendRemainSize ; "send remain < size: %08x, %08x"
		BL		showDbg

		MOV		R0, #0xFFFFFFFF
		LDMFD		SP!, {R4,PC}

; End of function sub_1019AC

; ---------------------------------------------------------------------------
off_1019F8	DCD dword_10AAF4	; DATA XREF: sub_1019ACr
					; ROM:offsets_starto
off_1019FC	DCD aSendRemainSize	; DATA XREF: sub_1019AC:loc_1019E8r
					; ROM:offsets_starto
					; "send remain < size: %08x, %08x"

; =============== S U B	R O U T	I N E =======================================


recv_wrapper				; CODE XREF: handle_savefile_packet+28p
					; handle_savefile_packet+D8p ...
		LDR		R3, =dword_10AAF4
		STMFD		SP!, {R4,LR}
		MOV		R2, R1
		LDR		R12, [R3]
		ADD		LR, R12, #0x2000
		LDR		R1, [LR,#0x78]
		CMP		R1, R2
		BCC		loc_101A3C

		MOV		R4, R0
		RSB		R3, R2,	R1
		STR		R3, [LR,#0x78]
		MOV		R1, R4
		LDR		R0, [R12,#8]
		LDMFD		SP!, {R4,LR}
		B		recv_

; ---------------------------------------------------------------------------

loc_101A3C				; CODE XREF: recv_wrapper+1Cj
		LDR		R0, =aRecvRemainSize ; "recv remain < size: %08x, %08x"
		BL		showDbg

		MOV		R0, #0xFFFFFFFF
		LDMFD		SP!, {R4,PC}

; End of function recv_wrapper

; ---------------------------------------------------------------------------
off_101A4C	DCD dword_10AAF4	; DATA XREF: recv_wrapperr
					; ROM:offsets_starto
off_101A50	DCD aRecvRemainSize	; DATA XREF: recv_wrapper:loc_101A3Cr
					; ROM:offsets_starto
					; "recv remain < size: %08x, %08x"

; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame fpd=0x220

handle_savefile_packet			; CODE XREF: dispatch_client_cmd+94p

var_250		= -0x250
var_244		= -0x244
var_240		= -0x240
var_234		= -0x234
var_230		= -0x230
var_22C		= -0x22C
var_228		= -0x228
var_224		= -0x224
var_20		= -0x20

		STMFD		SP!, {R4-R10,LR}
		SUB		SP, SP,	#0x260
		LDR		R6, =dword_10AAF4
		ADD		R7, SP,	#0x40
		MOV		R1, #0x200
		LDR		R3, [R6]
		MOV		R0, R7
		ADD		R3, R3,	#0x2000
		MOV		R8, #0
		LDR		R4, [R3,#0x74]
		BL		recv_wrapper

		MOV		R3, #3
		MOV		R0, R7	; a1
		STRB		R3, [SP,#0x260+var_22C]
		STRB		R8, [SP,#0x260+var_20]
		BL		strlen_

		ADD		R2, SP,	#0x260+var_22C
		STR		R7, [SP,#0x260+var_224]
		ADD		R3, SP,	#0x260+var_250
		LDR		R12, =dword_108364
		SUB		R4, R4,	#0x200
		ADD		R0, R0,	#1
		STR		R0, [SP,#0x260+var_228]
		LDMIA		R2, {R0-R2}
		STMIA		R3, {R0-R2}
		MOV		R3, #7
		STR		R3, [SP,#0x260+var_244]
		ADD		R3, R12, #8
		STR		R8, [SP,#0x260+var_240]
		LDMIA		R3, {R0-R3}
		STMEA		SP, {R0-R3}
		LDR		R1, =hFSUser
		LDMIA		R12, {R2,R3}
		LDR		R0, [R1]
		ADD		R1, SP,	#0x260+var_234
		BL		openFile_

		SUBS		R1, R0,	#0
		MOVEQ		R5, R1
		LDREQ		R10, =0x1FFF
		MOVEQ		R9, R1
		BEQ		loc_101B08

		LDR		R0, =aOpenfileFailed ; "openFile failed: %08x"
		MOV		R2, R8
		BL		showDbg

		B		loc_101B74

; ---------------------------------------------------------------------------

loc_101B08				; CODE XREF: handle_savefile_packet+A0j
					; handle_savefile_packet+108j
		CMP		R4, #0
		BEQ		loc_101B60

		LDR		R0, [R6]
		CMP		R4, R10
		MOVLS		R8, R4
		MOVHI		R8, #0x2000
		ADD		R0, R0,	#0x2040
		MOV		R1, R8
		ADD		R0, R0,	#0x3C
		BL		recv_wrapper

		LDR		R3, [R6]
		MOV		R2, R5
		ADD		R3, R3,	#0x2040
		ADD		R3, R3,	#0x3C
		LDR		R0, [SP,#0x260+var_234]
		STMEA		SP, {R3,R8,R9}
		ADD		R1, SP,	#0x260+var_230
		MOV		R3, #0
		BL		_FSFile_Write

		RSB		R4, R8,	R4
		ADD		R5, R5,	R8
		B		loc_101B08

; ---------------------------------------------------------------------------

loc_101B60				; CODE XREF: handle_savefile_packet+B8j
		LDR		R0, [SP,#0x260+var_234]
		BL		CloseHandle

		LDR		R0, =aSavedToSSucces ; "saved to %s successfully\n"
		MOV		R1, R7
		BL		nsDbgPrint


loc_101B74				; CODE XREF: handle_savefile_packet+B0j
		ADD		SP, SP,	#0x260
		LDMFD		SP!, {R4-R10,PC}

; End of function handle_savefile_packet

; ---------------------------------------------------------------------------
off_101B7C	DCD dword_10AAF4	; DATA XREF: handle_savefile_packet+8r
					; ROM:offsets_starto
off_101B80	DCD dword_108364	; DATA XREF: handle_savefile_packet+4Cr
					; ROM:offsets_starto
off_101B84	DCD hFSUser		; DATA XREF: handle_savefile_packet+7Cr
					; ROM:offsets_starto
dword_101B88	DCD 0x1FFF		; DATA XREF: handle_savefile_packet+98r
off_101B8C	DCD aOpenfileFailed	; DATA XREF: handle_savefile_packet+A4r
					; ROM:offsets_starto
					; "openFile failed: %08x"
off_101B90	DCD aSavedToSSucces	; DATA XREF: handle_savefile_packet+114r
					; ROM:offsets_starto
					; "saved to %s successfully\n"

; =============== S U B	R O U T	I N E =======================================


sub_101B94				; CODE XREF: handle_debugcmd_packet+24p
		LDR		R3, =dword_10AAF4
		MOV		R0, #1
		MOV		R1, #0x15C
		LDR		R2, [R3]


loc_101BA4				; CODE XREF: sub_101B94+30j
		MUL		R3, R1,	R0
		ADD		R3, R3,	#0x6000
		ADD		R3, R3,	#0x94
		LDR		R3, [R2,R3]
		CMP		R3, #0
		BXEQ		LR

		ADD		R0, R0,	#1
		CMP		R0, #0x40 ; '@'
		BNE		loc_101BA4

		MOV		R0, #0xFFFFFFFF
		BX		LR

; End of function sub_101B94

; ---------------------------------------------------------------------------
off_101BD0	DCD dword_10AAF4	; DATA XREF: sub_101B94r
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


debugcmd_enable_breakpoint		; CODE XREF: debugcmd_init_breakpoint+68p
					; handle_debugcmd_packet+A4p
		LDR		R3, =dword_10AAF4
		MOV		R1, R0
		STMFD		SP!, {R4,LR}
		LDR		R0, [R3]
		MOV		R3, #0x15C
		MUL		R3, R3,	R1
		ADD		R2, R0,	R3
		ADD		R12, R2, #0x6100
		ADD		R12, R12, #0xE8
		LDR		LR, [R12,#4]
		CMP		LR, #0
		LDRNE		R0, =aBpDAlreadyEnab ; "bp %d already enabled\n"
		BNE		loc_101C40

		ADD		R2, R2,	#0x6000
		MOV		R4, R1
		LDR		R2, [R2,#0x94]
		MOV		R1, #1
		SUB		R2, R2,	#1
		CMP		R2, R1
		STR		R1, [R12,#4]
		BHI		loc_101C38

		ADD		R3, R3,	#0x6000
		ADD		R0, R0,	R3
		ADD		R0, R0,	#0xA0 ;	rthook
		BL		rtEnableHook


loc_101C38				; CODE XREF: debugcmd_enable_breakpoint+50j
		LDR		R0, =aBpDEnabled ; "bp %d enabled\n"
		MOV		R1, R4


loc_101C40				; CODE XREF: debugcmd_enable_breakpoint+30j
		LDMFD		SP!, {R4,LR}
		B		nsDbgPrint

; End of function debugcmd_enable_breakpoint

; ---------------------------------------------------------------------------
off_101C48	DCD dword_10AAF4	; DATA XREF: debugcmd_enable_breakpointr
					; ROM:offsets_starto
off_101C4C	DCD aBpDAlreadyEnab	; DATA XREF: debugcmd_enable_breakpoint+2Cr
					; ROM:offsets_starto
					; "bp %d already enabled\n"
off_101C50	DCD aBpDEnabled		; DATA XREF: debugcmd_enable_breakpoint:loc_101C38r
					; ROM:offsets_starto
					; "bp %d enabled\n"

; =============== S U B	R O U T	I N E =======================================


debugcmd_disable_breakpoint		; CODE XREF: sub_101CD4+3Cp
					; handle_debugcmd_packet+B8p
		LDR		R3, =dword_10AAF4
		MOV		R1, R0
		STMFD		SP!, {R4,LR}
		LDR		R0, [R3]
		MOV		R3, #0x15C
		MUL		R3, R3,	R1
		ADD		R2, R0,	R3
		ADD		R12, R2, #0x6100
		ADD		R12, R12, #0xE8
		LDR		LR, [R12,#4]
		CMP		LR, #0
		LDREQ		R0, =aBpDAlreadyDisa ; "bp %d already disabled\n"
		BEQ		loc_101CC0

		ADD		R2, R2,	#0x6000
		MOV		R4, R1
		LDR		R2, [R2,#0x94]
		MOV		R1, #0
		SUB		R2, R2,	#1
		CMP		R2, #1
		STR		R1, [R12,#4]
		BHI		loc_101CB8

		ADD		R3, R3,	#0x6000
		ADD		R0, R0,	R3
		ADD		R0, R0,	#0xA0
		BL		disable_breakpoint


loc_101CB8				; CODE XREF: debugcmd_disable_breakpoint+50j
		LDR		R0, =aBpDDisabled ; "bp %d disabled\n"
		MOV		R1, R4


loc_101CC0				; CODE XREF: debugcmd_disable_breakpoint+30j
		LDMFD		SP!, {R4,LR}
		B		nsDbgPrint

; End of function debugcmd_disable_breakpoint

; ---------------------------------------------------------------------------
off_101CC8	DCD dword_10AAF4	; DATA XREF: debugcmd_disable_breakpointr
					; ROM:offsets_starto
off_101CCC	DCD aBpDAlreadyDisa	; DATA XREF: debugcmd_disable_breakpoint+2Cr
					; ROM:offsets_starto
					; "bp %d already disabled\n"
off_101CD0	DCD aBpDDisabled	; DATA XREF: debugcmd_disable_breakpoint:loc_101CB8r
					; ROM:offsets_starto
					; "bp %d disabled\n"

; =============== S U B	R O U T	I N E =======================================


sub_101CD4				; DATA XREF: init_breakpoint_+A0o
					; ROM:off_101EB8o

var_1C		= -0x1C

		STMFD		SP!, {R0-R2,R4-R7,LR}
		MOV		R7, R0
		LDR		R5, =dword_10AAF4
		MOV		R6, R1
		LDR		R4, [R5]
		ADD		R0, R4,	#0x6000
		ADD		R0, R0,	#0x90 ;	lock
		BL		rtAcquireLock

		MOV		R3, #0x15C
		MLA		R3, R3,	R6, R4
		ADD		R3, R3,	#0x6000
		LDR		R3, [R3,#0x94]
		CMP		R3, #2
		BNE		loc_101D14

		MOV		R0, R6
		BL		debugcmd_disable_breakpoint


loc_101D14				; CODE XREF: sub_101CD4+34j
		LDR		R0, [R5]
		ADD		R4, R4,	#0xB000
		ADD		R0, R0,	#0xB700
		ADD		R0, R0,	#0x94 ;	lock
		BL		rtAcquireLock

		LDR		R0, [R5]
		MOV		R3, #0
		ADD		R0, R0,	#0xB700
		STR		R6, [R4,#0x798]
		STR		R7, [R4,#0x79C]
		STR		R3, [R4,#0x7A0]
		ADD		R0, R0,	#0x94 ;	lock
		BL		rtReleaseLock


loc_101D48				; CODE XREF: sub_101CD4+B0j
		LDR		R0, [R5]
		ADD		R0, R0,	#0xB700
		ADD		R0, R0,	#0x94 ;	lock
		BL		rtAcquireLock

		LDR		R0, [R5]
		LDR		R3, [R4,#0x7A0]
		ADD		R0, R0,	#0xB700
		ADD		R0, R0,	#0x94 ;	lock
		STR		R3, [SP,#0x20+var_1C]
		BL		rtReleaseLock

		LDR		R0, =0x5F5E100
		MOV		R1, #0
		BL		SleepThread

		LDR		R3, [SP,#0x20+var_1C]
		CMP		R3, #0
		BEQ		loc_101D48

		MOV		R3, #0
		STR		R3, [R4,#0x798]
		LDR		R3, =dword_10AAF4
		LDR		R0, [R3]
		ADD		R0, R0,	#0x6000
		ADD		R0, R0,	#0x90 ;	lock
		BL		rtReleaseLock

		ADD		SP, SP,	#0xC
		LDMFD		SP!, {R4-R7,PC}

; End of function sub_101CD4

; ---------------------------------------------------------------------------
off_101DAC	DCD dword_10AAF4	; DATA XREF: sub_101CD4+8r
					; sub_101CD4+BCr ...
dword_101DB0	DCD 0x5F5E100		; DATA XREF: sub_101CD4+9Cr

; =============== S U B	R O U T	I N E =======================================


init_breakpoint_			; CODE XREF: debugcmd_init_breakpoint+44p
		STMFD		SP!, {R3-R9,LR}
		MOV		R8, R0
		LDR		R3, =dword_10AAF4
		MOV		R4, #0x15C
		MUL		R4, R4,	R8
		LDR		R6, [R3]
		BL		get_current_process_handle

		ADD		R7, R6,	R4
		ADD		R7, R7,	#0x6000
		ADD		R9, R7,	#0x98
		MOV		R2, #8	; size
		LDR		R1, [R9,#4] ; addr
		BL		rtCheckRemoteMemoryRegionSafeForWrite

		SUBS		R5, R0,	#0
		BEQ		loc_101E04

		LDR		R0, =aRtcheckremotem ; "rtCheckRemoteMemoryRegionSafeForWrite f"...
		MOV		R1, R5
		BL		nsDbgPrint

		MOV		R0, R5
		LDMFD		SP!, {R3-R9,PC}

; ---------------------------------------------------------------------------

loc_101E04				; CODE XREF: init_breakpoint_+38j
		LDR		R3, [R7,#0x94]
		CMP		R3, #1
		ADDEQ		R4, R4,	#0x6100
		ADDEQ		R4, R6,	R4
		ADDEQ		R5, R4,	#0x2C
		BEQ		loc_101E24

		CMP		R3, #2
		LDREQ		R5, [R9,#4]


loc_101E24				; CODE XREF: init_breakpoint_+64j
		MOV		R4, #0x15C
		LDR		R3, =dump_cmd
		MLA		R4, R4,	R8, R6
		ADD		R1, R3,	#0x2C
		ADD		R4, R4,	#0x6100
		ADD		R4, R4,	#0x6C
		MOV		R2, R4


copy_dmp_cmd				; CODE XREF: init_breakpoint_+98j
		LDR		R0, [R3],#4
		CMP		R3, R1
		STR		R0, [R2],#4
		BNE		copy_dmp_cmd

		MOV		R7, #0x15C
		LDR		R2, =sub_101CD4
		MUL		R7, R7,	R8
		MOV		R0, R4	; addr
		ADD		R9, R6,	R7
		ADD		R3, R9,	#0x6100
		MOV		R1, #0x40 ; '@'	; size
		STR		R8, [R3,#0x98]
		STR		R2, [R3,#0x9C]
		STR		R5, [R3,#0xA0]
		BL		flush_current_process_data_cache

		ADD		R9, R9,	#0x6000
		ADD		R3, R7,	#0x6000
		ADD		R0, R6,	R3
		LDR		R1, [R9,#0x9C] ; funcaddr
		MOV		R2, R4	; callback_addr
		ADD		R0, R0,	#0xA0 ;	hook
		BL		rtInitHook

		LDR		R0, =0x5F5E100
		MOV		R1, #0
		BL		SleepThread

		MOV		R0, #0
		LDMFD		SP!, {R3-R9,PC}

; End of function init_breakpoint_

; ---------------------------------------------------------------------------
off_101EAC	DCD dword_10AAF4	; DATA XREF: init_breakpoint_+8r
					; ROM:offsets_starto
off_101EB0	DCD aRtcheckremotem	; DATA XREF: init_breakpoint_+3Cr
					; ROM:offsets_starto
					; "rtCheckRemoteMemoryRegionSafeForWrite f"...
off_101EB4	DCD dump_cmd		; DATA XREF: init_breakpoint_+74r
					; ROM:offsets_starto
off_101EB8	DCD sub_101CD4		; DATA XREF: init_breakpoint_+A0r
					; ROM:offsets_starto
dword_101EBC	DCD 0x5F5E100		; DATA XREF: init_breakpoint_+E4r

; =============== S U B	R O U T	I N E =======================================


debugcmd_init_breakpoint		; CODE XREF: handle_debugcmd_packet+4Cp
					; setup_ntr_network_server+174p
		LDR		R3, =dword_10AAF4
		STMFD		SP!, {R4-R6,LR}
		MOV		R6, R1
		LDR		R5, [R3]
		MOV		R3, #0x15C
		MOV		R12, #0
		MLA		R3, R3,	R0, R5
		MOV		R4, R0
		ADD		R1, R3,	#0x6000
		ADD		R3, R3,	#0x6100
		STR		R12, [R1,#0x98]
		STR		R2, [R1,#0x94]
		STR		R12, [R3,#0xEC]
		SUB		R3, R2,	#1
		CMP		R3, #1
		STR		R6, [R1,#0x9C]
		BHI		loc_101F2C

		BL		init_breakpoint_

		CMP		R0, #0
		BNE		loc_101F2C

		LDR		R0, =aCodeBreakpoint ; "code breakpoint, id: %d, addr: %08x\n"
		MOV		R1, R4
		MOV		R2, R6
		BL		nsDbgPrint

		MOV		R0, R4
		LDMFD		SP!, {R4-R6,LR}
		B		debugcmd_enable_breakpoint

; ---------------------------------------------------------------------------

loc_101F2C				; CODE XREF: debugcmd_init_breakpoint+40j
					; debugcmd_init_breakpoint+4Cj
		MOV		R3, #0x15C
		LDR		R0, =aInitBreakpoint ; "init breakpoint failed.\n"
		MLA		R4, R3,	R4, R5
		MOV		R3, #0
		ADD		R4, R4,	#0x6000
		ADD		R4, R4,	#0x90
		STR		R3, [R4,#4]
		LDMFD		SP!, {R4-R6,LR}
		B		nsDbgPrint

; End of function debugcmd_init_breakpoint

; ---------------------------------------------------------------------------
off_101F50	DCD dword_10AAF4	; DATA XREF: debugcmd_init_breakpointr
					; ROM:offsets_starto
off_101F54	DCD aCodeBreakpoint	; DATA XREF: debugcmd_init_breakpoint+50r
					; ROM:offsets_starto
					; "code breakpoint, id: %d, addr: %08x\n"
off_101F58	DCD aInitBreakpoint	; DATA XREF: debugcmd_init_breakpoint+70r
					; ROM:offsets_starto
					; "init breakpoint failed.\n"

; =============== S U B	R O U T	I N E =======================================


handle_queryhandle_packet		; CODE XREF: dispatch_client_cmd+124p

hProcess	= -0x658
src		= -0x654
copy_of_kprocesshandle_table= -0x650

		LDR		R3, =dword_10AAF4
		STMFD		SP!, {R4,R5,LR}
		SUB		SP, SP,	#0x640
		LDR		R3, [R3]
		SUB		SP, SP,	#0xC
		ADD		R3, R3,	#0x2000
		ADD		R5, SP,	#0x658+copy_of_kprocesshandle_table
		MOV		R2, #0
		SUB		R0, R5,	#8
		LDR		R1, [R3,#0x34]
		STR		R2, [SP,#0x658+hProcess]
		BL		OpenProcess

		SUBS		R4, R0,	#0
		BEQ		loc_101FA0

		LDR		R0, =aOpenprocessFai ; "openprocess failed.\n"
		BL		nsDbgPrint

		B		loc_102014

; ---------------------------------------------------------------------------

loc_101FA0				; CODE XREF: handle_queryhandle_packet+34j
		LDR		R0, [SP,#0x658+hProcess] ; handle
		BL		arm11k_get_kernel_object ; r0 =	handle
					; returns ptr to kernel	object

		LDR		R3, =offs_KProcessHandleTable
		MOV		R2, #4	; count
		LDR		R1, [R3]
		ADD		R1, R0,	R1 ; src
		SUB		R0, R5,	#4 ; dst
		BL		arm11k_memcpy

		MOV		R0, R5	; dst
		LDR		R1, [SP,#0x658+src] ; src
		MOV		R2, #0x640 ; count
		BL		arm11k_memcpy ;	read 0x640 bytes at KProcessHandleTable


print_all_handles			; CODE XREF: handle_queryhandle_packet+A4j
		MOV		R3, R4,LSL#2
		ADD		R2, R5,	R3
		LDR		R2, [R2,#4]
		CMP		R2, #0
		BEQ		loc_101FF8

		LDRH		R3, [R5,R3]
		MOV		R1, R4,LSR#1
		LDR		R0, =aH08xP08x ; "h: %08x, p: %08x\n"
		ORR		R1, R1,	R3,LSL#15
		BL		nsDbgPrint


loc_101FF8				; CODE XREF: handle_queryhandle_packet+84j
		ADD		R4, R4,	#2
		CMP		R4, #0x190
		BNE		print_all_handles

		LDR		R0, =(aKernelhaxDone+0xA)
		BL		nsDbgPrint

		LDR		R0, [SP,#0x658+hProcess]
		BL		CloseHandle


loc_102014				; CODE XREF: handle_queryhandle_packet+40j
		ADD		SP, SP,	#0x640
		ADD		SP, SP,	#0xC
		LDMFD		SP!, {R4,R5,PC}

; End of function handle_queryhandle_packet

; ---------------------------------------------------------------------------
off_102020	DCD dword_10AAF4	; DATA XREF: handle_queryhandle_packetr
					; ROM:offsets_starto
off_102024	DCD aOpenprocessFai	; DATA XREF: handle_queryhandle_packet+38r
					; ROM:offsets_starto
					; "openprocess failed.\n"
off_102028	DCD offs_KProcessHandleTable ; DATA XREF: handle_queryhandle_packet+4Cr
					; ROM:offsets_starto
off_10202C	DCD aH08xP08x		; DATA XREF: handle_queryhandle_packet+90r
					; ROM:offsets_starto
					; "h: %08x, p: %08x\n"
off_102030	DCD aKernelhaxDone+0xA	; DATA XREF: handle_queryhandle_packet+A8r
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================

; breakpoint and resume	cmds

handle_debugcmd_packet			; CODE XREF: dispatch_client_cmd+114p
		STMFD		SP!, {R4-R6,LR}
		LDR		R5, =dword_10AAF4
		LDR		R3, [R5]
		ADD		R3, R3,	#0x2000
		LDR		R4, [R3,#0x34]
		LDR		R6, [R3,#0x38]
		LDR		R3, [R3,#0x3C]
		CMP		R3, #1
		BNE		loc_102088

		BL		sub_101B94

		MOV		R5, R0
		MOV		R1, R5
		LDR		R0, =aFreeidD ;	"freeid: %d\n"
		BL		nsDbgPrint

		CMN		R5, #1
		LDMEQFD		SP!, {R4-R6,PC}

		MOV		R0, R5
		MOV		R1, R6
		MOV		R2, R4
		BL		debugcmd_init_breakpoint

		B		loc_1020F0

; ---------------------------------------------------------------------------

loc_102088				; CODE XREF: handle_debugcmd_packet+20j
		CMP		R3, #4
		BNE		loc_1020B4

		LDR		R0, =aSetResumeFlag ; "set resume flag"
		BL		nsDbgPrint

		LDR		R3, [R5]
		MOV		R2, #1
		ADD		R3, R3,	#0xB000
		STR		R2, [R3,#0x7A0]
		MOV		R2, #0
		STR		R2, [R3,#0x7A4]
		B		loc_1020F0

; ---------------------------------------------------------------------------

loc_1020B4				; CODE XREF: handle_debugcmd_packet+58j
		CMP		R4, #0x3F ; '?'
		BLS		loc_1020C8


loc_1020BC				; CODE XREF: handle_debugcmd_packet+C4j
		LDR		R0, =aInvalidBpid ; "invalid bpid\n"
		LDMFD		SP!, {R4-R6,LR}
		B		nsDbgPrint

; ---------------------------------------------------------------------------

loc_1020C8				; CODE XREF: handle_debugcmd_packet+84j
		CMP		R3, #2
		BNE		loc_1020DC

		MOV		R0, R4
		LDMFD		SP!, {R4-R6,LR}
		B		debugcmd_enable_breakpoint

; ---------------------------------------------------------------------------

loc_1020DC				; CODE XREF: handle_debugcmd_packet+98j
		CMP		R3, #3
		LDMNEFD		SP!, {R4-R6,PC}

		MOV		R0, R4
		LDMFD		SP!, {R4-R6,LR}
		B		debugcmd_disable_breakpoint

; ---------------------------------------------------------------------------

loc_1020F0				; CODE XREF: handle_debugcmd_packet+50j
					; handle_debugcmd_packet+7Cj
		CMP		R4, #0x3F ; '?'
		LDMLSFD		SP!, {R4-R6,PC}

		B		loc_1020BC

; End of function handle_debugcmd_packet

; ---------------------------------------------------------------------------
off_1020FC	DCD dword_10AAF4	; DATA XREF: handle_debugcmd_packet+4r
					; ROM:offsets_starto
off_102100	DCD aFreeidD		; DATA XREF: handle_debugcmd_packet+30r
					; ROM:offsets_starto
					; "freeid: %d\n"
off_102104	DCD aSetResumeFlag	; DATA XREF: handle_debugcmd_packet+5Cr
					; ROM:offsets_starto
					; "set resume flag"
off_102108	DCD aInvalidBpid	; DATA XREF: handle_debugcmd_packet:loc_1020BCr
					; ROM:offsets_starto
					; "invalid bpid\n"

; =============== S U B	R O U T	I N E =======================================


handle_reload_packet			; CODE XREF: dispatch_client_cmd+A4p

var_50		= -0x50
var_44		= -0x44
var_40		= -0x40
outaddr		= -0x34
var_30		= -0x30
var_2C		= -0x2C
var_28		= -0x28
var_1C		= -0x1C
var_18		= -0x18
var_14		= -0x14
var_10		= -0x10

		LDR		R3, =p_config_memory
		STMFD		SP!, {R4-R6,LR}
		MOV		R2, #1
		LDR		R3, [R3]
		LDR		R4, =dword_10AAF4
		SUB		SP, SP,	#0x50 ;	operation
		STR		R2, [R3,#NS_CONFIG]
		LDR		R3, [R4]
		MOV		R6, #3
		LDR		R0, [R3,#NS_CONFIG.hSOCU]
		BL		close

		LDR		R3, [R4]
		MOV		R4, #0
		LDR		R0, [R3,#4]
		BL		close

		MOV		R3, #0xB
		STR		R3, [SP,#0x60+var_18]
		ADD		R2, SP,	#0x60+var_10
		LDR		R3, =aArm11_bin	; "/arm11.bin"
		STRB		R6, [SP,#0x60+var_1C]
		STR		R3, [SP,#0x60+var_14]
		LDMDB		R2, {R0-R2}
		ADD		R3, SP,	#0x60+var_50
		LDR		R12, =dword_108364
		STMIA		R3, {R0-R2}
		MOV		R3, #7
		STR		R3, [SP,#0x60+var_44]
		ADD		R3, R12, #8
		STR		R4, [SP,#0x60+var_40]
		LDMIA		R3, {R0-R3}
		STMEA		SP, {R0-R3}
		LDR		R1, =hFSUser
		LDMIA		R12, {R2,R3}
		LDR		R0, [R1]
		ADD		R1, SP,	#0x60+var_30
		BL		openFile_

		SUBS		R5, R0,	#0
		MOVNE		R1, R5
		LDRNE		R0, =aOpenfileFailed ; "openFile failed: %08x"
		BNE		loc_10224C

		LDR		R0, [SP,#0x60+var_30]
		ADD		R1, SP,	#0x60+var_28
		BL		FSFILE_GetSize_

		SUBS		R4, R0,	#0
		LDRNE		R0, =aFsfile_getsi_0 ; "FSFILE_GetSize failed: %08x"
		MOVNE		R1, R4
		MOVNE		R2, R5
		BNE		loc_102250

		LDR		R0, [SP,#0x60+var_28]
		BL		round_to_pagesize_

		LDR		R3, =0x10003
		MOV		R1, R4	; addr0
		MOV		R2, R4	; addr1
		STMEA		SP, {R3,R6}
		MOV		R5, R0
		MOV		R3, R5	; size
		ADD		R0, SP,	#0x60+outaddr ;	outaddr
		BL		ControlMemory

		SUBS		R6, R0,	#0
		MOVNE		R1, R6
		LDRNE		R0, =aSvc_controlmem ; "svc_controlMemory failed: %08x"
		BNE		loc_10224C

		LDR		R3, [SP,#0x60+outaddr]
		LDR		R0, [SP,#0x60+var_30]
		ADD		R1, SP,	#0x60+var_2C
		STMEA		SP, {R3,R5}
		MOV		R2, #0
		MOV		R3, #0
		BL		FSFILE_Read

		SUBS		R4, R0,	#0
		LDRNE		R0, =aFsfile_readFai ; "FSFILE_Read failed: %08x"
		MOVNE		R1, R4
		MOVNE		R2, R6
		BNE		loc_102250

		MOV		R1, R5	; size
		LDR		R0, [SP,#0x60+outaddr] ; addr
		BL		protectMemory ;	assigns	RWX to addr : addr+size

		SUBS		R1, R0,	#0
		BEQ		loc_102258

		LDR		R0, =aProtectmemoryF ; "protectMemory failed: %08x"


loc_10224C				; CODE XREF: handle_reload_packet+9Cj
					; handle_reload_packet+F4j
		MOV		R2, R4


loc_102250				; CODE XREF: handle_reload_packet+BCj
					; handle_reload_packet+124j
		BL		showDbg

		B		loc_102264

; ---------------------------------------------------------------------------

loc_102258				; CODE XREF: handle_reload_packet+138j
		LDR		R3, [SP,#0x60+outaddr]
		BLX		R3

		BL		ExitThread

; ---------------------------------------------------------------------------

loc_102264				; CODE XREF: handle_reload_packet+148j
		ADD		SP, SP,	#0x50
		LDMFD		SP!, {R4-R6,PC}

; End of function handle_reload_packet

; ---------------------------------------------------------------------------
off_10226C	DCD p_config_memory	; DATA XREF: handle_reload_packetr
					; ROM:offsets_starto
off_102270	DCD dword_10AAF4	; DATA XREF: handle_reload_packet+10r
					; ROM:offsets_starto
off_102274	DCD aArm11_bin		; DATA XREF: handle_reload_packet+48r
					; ROM:offsets_starto
					; "/arm11.bin"
off_102278	DCD dword_108364	; DATA XREF: handle_reload_packet+5Cr
					; ROM:offsets_starto
off_10227C	DCD hFSUser		; DATA XREF: handle_reload_packet+7Cr
					; ROM:offsets_starto
off_102280	DCD aOpenfileFailed	; DATA XREF: handle_reload_packet+98r
					; ROM:offsets_starto
					; "openFile failed: %08x"
off_102284	DCD aFsfile_getsi_0	; DATA XREF: handle_reload_packet+B0r
					; ROM:offsets_starto
					; "FSFILE_GetSize failed: %08x"
dword_102288	DCD 0x10003		; DATA XREF: handle_reload_packet+C8r
off_10228C	DCD aSvc_controlmem	; DATA XREF: handle_reload_packet+F0r
					; ROM:offsets_starto
					; "svc_controlMemory failed: %08x"
off_102290	DCD aFsfile_readFai	; DATA XREF: handle_reload_packet+118r
					; ROM:offsets_starto
					; "FSFILE_Read failed: %08x"
off_102294	DCD aProtectmemoryF	; DATA XREF: handle_reload_packet+13Cr
					; ROM:offsets_starto
					; "protectMemory failed: %08x"

; =============== S U B	R O U T	I N E =======================================


handle_listprocess_packet		; CODE XREF: dispatch_client_cmd+B4p

var_1D8		= -0x1D8
var_1D4		= -0x1D4
var_1CC		= -0x1CC
var_1C8		= -0x1C8
var_1C4		= -0x1C4
var_1C0		= -0x1C0
var_1B4		= -0x1B4
var_1A0		= -0x1A0

		STMFD		SP!, {R4,R5,LR}
		SUB		SP, SP,	#0x1CC
		ADD		R5, SP,	#0x1D8+var_1A0
		MOV		R1, R5
		ADD		R0, SP,	#0x1D8+var_1CC
		MOV		R2, #0x64 ; 'd'
		BL		GetProcessList

		SUBS		R1, R0,	#0
		MOVEQ		R4, R1
		BEQ		loc_102318

		LDR		R0, =aGetprocesslist ; "getProcessList failed: %08x\n"
		BL		nsDbgPrint

		B		loc_10232C

; ---------------------------------------------------------------------------

loc_1022CC				; CODE XREF: handle_listprocess_packet+88j
		ADD		R1, SP,	#0x1D8+var_1B4
		LDR		R0, [R5,R4,LSL#2]
		ADD		R2, SP,	#0x1D8+var_1C4
		ADD		R3, SP,	#0x1D8+var_1C8
		BL		get_process_name

		SUBS		R1, R0,	#0
		BEQ		loc_1022F0

		LDR		R0, =aGetprocessinfo ; "getProcessInfo failed: %08x\n"
		BL		nsDbgPrint


loc_1022F0				; CODE XREF: handle_listprocess_packet+4Cj
		LDR		R3, [SP,#0x1D8+var_1C4]
		LDR		R0, =aPid0x08xPname8 ; "pid: 0x%08x, pname: %8s, tid: %08x%08x,"...
		STR		R3, [SP,#0x1D8+var_1D8]
		LDR		R3, [SP,#0x1D8+var_1C8]
		ADD		R2, SP,	#0x1D8+var_1B4
		STR		R3, [SP,#0x1D8+var_1D4]
		LDR		R3, [SP,#0x1D8+var_1C0]
		LDR		R1, [R5,R4,LSL#2]
		BL		nsDbgPrint

		ADD		R4, R4,	#1


loc_102318				; CODE XREF: handle_listprocess_packet+24j
		LDR		R3, [SP,#0x1D8+var_1CC]
		CMP		R4, R3
		BCC		loc_1022CC

		LDR		R0, =aEndOfProcessLi ; "end of process list.\n"
		BL		nsDbgPrint


loc_10232C				; CODE XREF: handle_listprocess_packet+30j
		ADD		SP, SP,	#0x1CC
		LDMFD		SP!, {R4,R5,PC}

; End of function handle_listprocess_packet

; ---------------------------------------------------------------------------
off_102334	DCD aGetprocesslist	; DATA XREF: handle_listprocess_packet+28r
					; ROM:offsets_starto
					; "getProcessList failed: %08x\n"
off_102338	DCD aGetprocessinfo	; DATA XREF: handle_listprocess_packet+50r
					; ROM:offsets_starto
					; "getProcessInfo failed: %08x\n"
off_10233C	DCD aPid0x08xPname8	; DATA XREF: handle_listprocess_packet+5Cr
					; ROM:offsets_starto
					; "pid: 0x%08x, pname: %8s, tid: %08x%08x,"...
off_102340	DCD aEndOfProcessLi	; DATA XREF: handle_listprocess_packet+8Cr
					; ROM:offsets_starto
					; "end of process list.\n"

; =============== S U B	R O U T	I N E =======================================


handle_memlayout_packet			; CODE XREF: dispatch_client_cmd+E4p

a1		= -0x1C

		LDR		R3, =dword_10AAF4
		STMFD		SP!, {R0,R1,R4-R8,LR}
		ADD		R0, SP,	#0x20+a1
		LDR		R3, [R3]
		ADD		R3, R3,	#0x2000
		LDR		R1, [R3,#0x34]
		BL		OpenProcess

		SUBS		R5, R0,	#0
		BEQ		loc_102384

		LDR		R0, =aOpenprocessF_0 ; "openProcess failed: %08x\n"
		MOV		R1, R5
		MOV		R2, #0
		BL		nsDbgPrint

		MOV		R3, #0
		STR		R3, [SP,#0x20+a1]
		B		loc_1023F0

; ---------------------------------------------------------------------------

loc_102384				; CODE XREF: handle_memlayout_packet+20j
		LDR		R0, =aValidMemregion ; "valid memregions:\n"
		BL		nsDbgPrint

		LDR		R8, =0x20001000
		MOV		R4, #0x100000
		MOV		R7, R5


loc_102398				; CODE XREF: handle_memlayout_packet+A0j
		LDR		R0, [SP,#0x20+a1] ; hKProcess
		MOV		R1, R4	; addr
		MOV		R2, #0x1000 ; size
		BL		protectRemoteMemory ; assigns RWX to addr : addr+size

		CLZ		R6, R0
		MOV		R6, R6,LSR#5
		CMP		R6, R7
		BEQ		loc_1023DC

		CMP		R7, #0
		BEQ		loc_1023D4

		LDR		R0, =a08x08xSize08x ; "%08x - %08x , size: %08x\n"
		MOV		R1, R5
		SUB		R2, R4,	#1
		RSB		R3, R5,	R4
		BL		nsDbgPrint


loc_1023D4				; CODE XREF: handle_memlayout_packet+78j
		MOV		R5, R4
		MOV		R7, R6


loc_1023DC				; CODE XREF: handle_memlayout_packet+70j
		ADD		R4, R4,	#0x1000
		CMP		R4, R8
		BNE		loc_102398

		LDR		R0, =aEndOfMemlayout ; "end of memlayout.\n"
		BL		nsDbgPrint


loc_1023F0				; CODE XREF: handle_memlayout_packet+3Cj
		LDR		R0, [SP,#0x20+a1]
		CMP		R0, #0
		BEQ		loc_102400

		BL		CloseHandle


loc_102400				; CODE XREF: handle_memlayout_packet+B4j
		ADD		SP, SP,	#8
		LDMFD		SP!, {R4-R8,PC}

; End of function handle_memlayout_packet

; ---------------------------------------------------------------------------
off_102408	DCD dword_10AAF4	; DATA XREF: handle_memlayout_packetr
					; ROM:offsets_starto
off_10240C	DCD aOpenprocessF_0	; DATA XREF: handle_memlayout_packet+24r
					; ROM:offsets_starto
					; "openProcess failed: %08x\n"
off_102410	DCD aValidMemregion	; DATA XREF: handle_memlayout_packet:loc_102384r
					; ROM:offsets_starto
					; "valid memregions:\n"
dword_102414	DCD 0x20001000		; DATA XREF: handle_memlayout_packet+48r
off_102418	DCD a08x08xSize08x	; DATA XREF: handle_memlayout_packet+7Cr
					; ROM:offsets_starto
					; "%08x - %08x , size: %08x\n"
off_10241C	DCD aEndOfMemlayout	; DATA XREF: handle_memlayout_packet+A4r
					; ROM:offsets_starto
					; "end of memlayout.\n"

; =============== S U B	R O U T	I N E =======================================


handle_writemem_packet			; CODE XREF: dispatch_client_cmd+104p

size		= -0x30
hDst		= -0x24

		STMFD		SP!, {R0-R10,LR}
		LDR		R8, =dword_10AAF4
		LDR		R3, [R8]
		ADD		R3, R3,	#0x2000
		LDR		R7, [R3,#0x34]
		LDR		R4, [R3,#0x38]
		CMN		R7, #1
		LDR		R5, [R3,#0x3C]
		BNE		loc_102450

		BL		get_current_process_handle

		STR		R0, [SP,#0x30+hDst]
		B		loc_10247C

; ---------------------------------------------------------------------------

loc_102450				; CODE XREF: handle_writemem_packet+20j
		MOV		R1, R7
		ADD		R0, SP,	#0x30+hDst
		BL		OpenProcess

		SUBS		R1, R0,	#0
		BEQ		loc_10247C

		LDR		R0, =aOpenprocessF_1 ; "openProcess failed: %08x, pid: %08x\n"
		MOV		R2, R7
		BL		nsDbgPrint

		MOV		R3, #0
		STR		R3, [SP,#0x30+hDst]
		B		loc_10255C

; ---------------------------------------------------------------------------

loc_10247C				; CODE XREF: handle_writemem_packet+2Cj
					; handle_writemem_packet+40j
		CMN		R4, #0xE0000001
		BLS		loc_102490


loc_102484				; CODE XREF: handle_writemem_packet+84j
		LDR		R10, =0xFFF
		LDR		R9, =dword_10AAF4
		B		loc_102508

; ---------------------------------------------------------------------------

loc_102490				; CODE XREF: handle_writemem_packet+60j
		MOV		R1, R4	; addr
		LDR		R0, [SP,#0x30+hDst] ; hProcess
		MOV		R2, R5	; size
		BL		rtCheckRemoteMemoryRegionSafeForWrite

		SUBS		R1, R0,	#0
		BEQ		loc_102484

		LDR		R0, =aRtcheckremot_0 ; "rtCheckRemoteMemoryRegionSafeForWrite f"...
		MOV		R2, #0
		BL		nsDbgPrint

		B		loc_10255C

; ---------------------------------------------------------------------------

loc_1024B8				; CODE XREF: handle_writemem_packet+ECj
		LDR		R0, [R8]
		CMP		R5, R10
		MOVLS		R6, R5
		MOVHI		R6, #0x1000
		ADD		R0, R0,	#0x2040
		ADD		R0, R0,	#0x3C
		MOV		R1, R6
		BL		recv_wrapper

		CMN		R7, #1
		BNE		loc_10251C

		LDR		R1, [R9]
		CMP		R4, #0x20000000
		ADD		R1, R1,	#0x2040
		MOV		R0, R4	; dst
		ADD		R1, R1,	#0x3C ;	src
		MOV		R2, R6	; count
		BLS		loc_102514

		BL		arm11k_memcpy


loc_102500				; CODE XREF: handle_writemem_packet+F8j
					; handle_writemem_packet+120j ...
		ADD		R4, R4,	R6
		RSB		R5, R6,	R5


loc_102508				; CODE XREF: handle_writemem_packet+6Cj
		CMP		R5, #0
		BNE		loc_1024B8

		B		loc_102554

; ---------------------------------------------------------------------------

loc_102514				; CODE XREF: handle_writemem_packet+D8j
		BL		memcpy

		B		loc_102500

; ---------------------------------------------------------------------------

loc_10251C				; CODE XREF: handle_writemem_packet+BCj
		LDR		R3, [R9]
		MOV		R1, R4	; dst_addr
		ADD		R3, R3,	#0x2040
		STR		R6, [SP,#0x30+size] ; size
		LDR		R0, [SP,#0x30+hDst] ; hDst
		LDR		R2, =0xFFFF8001	; hSrc
		ADD		R3, R3,	#0x3C ;	src_addr
		BL		inter_process_dma_copy

		SUBS		R1, R0,	#0
		BEQ		loc_102500

		LDR		R0, =aCopyremotememo ; "copyRemoteMemory failed: %08x, addr: %0"...
		MOV		R2, R4
		BL		nsDbgPrint

		B		loc_102500

; ---------------------------------------------------------------------------

loc_102554				; CODE XREF: handle_writemem_packet+F0j
		LDR		R0, =aFinished ; "finished"
		BL		nsDbgPrint


loc_10255C				; CODE XREF: handle_writemem_packet+58j
					; handle_writemem_packet+94j
		LDR		R0, [SP,#0x30+hDst]
		CMP		R0, #0
		CMNNE		R7, #1
		BEQ		loc_102570

		BL		CloseHandle


loc_102570				; CODE XREF: handle_writemem_packet+148j
		ADD		SP, SP,	#0x10
		LDMFD		SP!, {R4-R10,PC}

; End of function handle_writemem_packet

; ---------------------------------------------------------------------------
off_102578	DCD dword_10AAF4	; DATA XREF: handle_writemem_packet+4r
					; handle_writemem_packet+68r ...
off_10257C	DCD aOpenprocessF_1	; DATA XREF: handle_writemem_packet+44r
					; ROM:offsets_starto
					; "openProcess failed: %08x, pid: %08x\n"
dword_102580	DCD 0xFFF		; DATA XREF: handle_writemem_packet:loc_102484r
off_102584	DCD aRtcheckremot_0	; DATA XREF: handle_writemem_packet+88r
					; ROM:offsets_starto
					; "rtCheckRemoteMemoryRegionSafeForWrite f"...
; unsigned int hSrc
hSrc		DCD 0xFFFF8001		; DATA XREF: handle_writemem_packet+110r
off_10258C	DCD aCopyremotememo	; DATA XREF: handle_writemem_packet+124r
					; ROM:offsets_starto
					; "copyRemoteMemory failed: %08x, addr: %0"...
off_102590	DCD aFinished		; DATA XREF: handle_writemem_packet:loc_102554r
					; ROM:offsets_starto
					; "finished"

; =============== S U B	R O U T	I N E =======================================


handle_readmem_packet			; CODE XREF: dispatch_client_cmd+F4p

size		= -0x30
hSrc		= -0x24

		STMFD		SP!, {R4-R9,LR}
		SUB		SP, SP,	#0x14
		LDR		R6, =dword_10AAF4
		LDR		R7, [R6]
		ADD		R7, R7,	#0x2000
		LDR		R8, [R7,#0x34]
		LDR		R4, [R7,#0x38]
		CMN		R8, #1
		LDR		R5, [R7,#0x3C]
		BNE		loc_1025C8

		BL		get_current_process_handle

		STR		R0, [SP,#0x30+hSrc]
		B		loc_1025F4

; ---------------------------------------------------------------------------

loc_1025C8				; CODE XREF: handle_readmem_packet+24j
		MOV		R1, R8
		ADD		R0, SP,	#0x30+hSrc
		BL		OpenProcess

		SUBS		R1, R0,	#0
		BEQ		loc_1025F4

		LDR		R0, =aOpenprocessF_1 ; "openProcess failed: %08x, pid: %08x\n"
		MOV		R2, R8
		BL		nsDbgPrint

		MOV		R3, #0
		STR		R3, [SP,#0x30+hSrc]
		B		loc_1026D4

; ---------------------------------------------------------------------------

loc_1025F4				; CODE XREF: handle_readmem_packet+30j
					; handle_readmem_packet+44j
		CMN		R4, #0xE0000001
		BHI		loc_102624

		MOV		R1, R4	; addr
		LDR		R0, [SP,#0x30+hSrc] ; hProcess
		MOV		R2, R5	; size
		BL		rtCheckRemoteMemoryRegionSafeForWrite

		SUBS		R1, R0,	#0
		BEQ		loc_102624

		LDR		R0, =aRtcheckremot_0 ; "rtCheckRemoteMemoryRegionSafeForWrite f"...
		MOV		R2, #0
		BL		nsDbgPrint

		B		loc_1026D4

; ---------------------------------------------------------------------------

loc_102624				; CODE XREF: handle_readmem_packet+64j
					; handle_readmem_packet+7Cj
		STR		R5, [R7,#0x74]
		BL		sub_101984

		LDR		R9, =0xFFF


loc_102630				; CODE XREF: handle_readmem_packet+134j
		CMP		R5, #0
		BEQ		loc_1026CC

		CMP		R5, R9
		MOVLS		R7, R5
		MOVHI		R7, #0x1000
		CMN		R8, #1
		BNE		loc_102678

		LDR		R0, [R6]
		CMP		R4, #0x20000000
		ADD		R0, R0,	#0x2040
		ADD		R0, R0,	#0x3C ;	dst
		MOV		R1, R4	; src
		MOV		R2, R7	; count
		BLS		loc_102670

		BL		arm11k_memcpy

		B		loc_1026AC

; ---------------------------------------------------------------------------

loc_102670				; CODE XREF: handle_readmem_packet+D0j
		BL		memcpy

		B		loc_1026AC

; ---------------------------------------------------------------------------

loc_102678				; CODE XREF: handle_readmem_packet+B4j
		LDR		R1, [R6]
		STR		R7, [SP,#0x30+size] ; size
		ADD		R1, R1,	#0x2040
		ADD		R1, R1,	#0x3C ;	dst_addr
		LDR		R0, =0xFFFF8001	; hDst
		LDR		R2, [SP,#0x30+hSrc] ; hSrc
		MOV		R3, R4	; src_addr
		BL		inter_process_dma_copy

		SUBS		R1, R0,	#0
		BEQ		loc_1026AC

		LDR		R0, =aCopyremotememo ; "copyRemoteMemory failed: %08x, addr: %0"...
		MOV		R2, R4
		BL		nsDbgPrint


loc_1026AC				; CODE XREF: handle_readmem_packet+D8j
					; handle_readmem_packet+E0j ...
		LDR		R0, [R6]
		MOV		R1, R7
		ADD		R0, R0,	#0x2040
		ADD		R0, R0,	#0x3C
		BL		sub_1019AC

		ADD		R4, R4,	R7
		RSB		R5, R7,	R5
		B		loc_102630

; ---------------------------------------------------------------------------

loc_1026CC				; CODE XREF: handle_readmem_packet+A0j
		LDR		R0, =aFinished ; "finished"
		BL		nsDbgPrint


loc_1026D4				; CODE XREF: handle_readmem_packet+5Cj
					; handle_readmem_packet+8Cj
		LDR		R0, [SP,#0x30+hSrc]
		CMP		R0, #0
		CMNNE		R8, #1
		BEQ		loc_1026E8

		BL		CloseHandle


loc_1026E8				; CODE XREF: handle_readmem_packet+14Cj
		ADD		SP, SP,	#0x14
		LDMFD		SP!, {R4-R9,PC}

; End of function handle_readmem_packet

; ---------------------------------------------------------------------------
off_1026F0	DCD dword_10AAF4	; DATA XREF: handle_readmem_packet+8r
					; ROM:offsets_starto
off_1026F4	DCD aOpenprocessF_1	; DATA XREF: handle_readmem_packet+48r
					; ROM:offsets_starto
					; "openProcess failed: %08x, pid: %08x\n"
off_1026F8	DCD aRtcheckremot_0	; DATA XREF: handle_readmem_packet+80r
					; ROM:offsets_starto
					; "rtCheckRemoteMemoryRegionSafeForWrite f"...
dword_1026FC	DCD 0xFFF		; DATA XREF: handle_readmem_packet+98r
; unsigned int dword_102700
dword_102700	DCD 0xFFFF8001		; DATA XREF: handle_readmem_packet+F4r
off_102704	DCD aCopyremotememo	; DATA XREF: handle_readmem_packet+10Cr
					; ROM:offsets_starto
					; "copyRemoteMemory failed: %08x, addr: %0"...
off_102708	DCD aFinished		; DATA XREF: handle_readmem_packet:loc_1026CCr
					; ROM:offsets_starto
					; "finished"

; =============== S U B	R O U T	I N E =======================================


get_remote_PC				; CODE XREF: handle_listthread_packet+FCp
					; inject_ntr_into_remote_process+C0p

var_B0C		= -0xB0C
var_B08		= -0xB08
var_978		= -0x978
var_7E8		= -0x7E8
var_660		= -0x660
var_620		= -0x620
var_61C		= -0x61C

		STMFD		SP!, {R4-R7,LR}
		SUB		SP, SP,	#0xAF0
		SUB		SP, SP,	#0xC
		MOV		R6, R0
		ADD		R5, SP,	#0xB10+var_B08
		MOV		R1, R5
		SUB		R0, R5,	#4
		MOV		R2, #0x64 ; 'd'
		MOV		R3, R6
		BL		GetThreadList

		SUBS		R1, R0,	#0
		MOVEQ		R4, R1
		BEQ		loc_102750

		LDR		R0, =aGetthreadlistF ; "getThreadList failed: %08x\n"
		BL		nsDbgPrint

		MOV		R0, #0
		B		loc_102888

; ---------------------------------------------------------------------------

loc_102750				; CODE XREF: get_remote_PC+30j
					; get_remote_PC+98j
		LDR		R3, [SP,#0xB10+var_B0C]
		CMP		R4, R3
		BCS		loc_1027A8

		ADD		R0, SP,	#0xB10+var_660
		LDR		R7, [R5,R4,LSL#2]
		MOV		R1, #0x33 ; '3'
		MOV		R2, #0x640
		ADD		R0, R0,	#8
		BL		memset_

		ADD		R2, SP,	#0xB10+var_660
		ADD		R2, R2,	#8 ; context_struc
		MOV		R0, R6	; hProcess
		MOV		R1, R7	; tid
		BL		get_thread_context

		LDR		R2, [SP,#0xB10+var_61C]
		ADD		R3, SP,	#0xB10+var_978
		STR		R2, [R3,R4,LSL#2]
		LDR		R2, [SP,#0xB10+var_620]
		ADD		R3, SP,	#0xB10+var_7E8
		STR		R2, [R3,R4,LSL#2]
		ADD		R4, R4,	#1
		B		loc_102750

; ---------------------------------------------------------------------------

loc_1027A8				; CODE XREF: get_remote_PC+4Cj
		LDR		R0, =aRecommendPc ; "recommend pc:\n"
		BL		nsDbgPrint

		MOV		R4, #0
		MOV		R5, R4


loc_1027B8				; CODE XREF: get_remote_PC+108j
		LDR		R2, [SP,#0xB10+var_B0C]
		CMP		R5, R2
		BCS		loc_102818

		MOV		R3, #0


loc_1027C8				; CODE XREF: get_remote_PC+E4j
		CMP		R3, R2
		BEQ		loc_1027F4

		CMP		R5, R3
		BEQ		loc_1027EC

		ADD		R1, SP,	#0xB10+var_978
		LDR		R0, [R1,R5,LSL#2]
		LDR		R1, [R1,R3,LSL#2]
		CMP		R0, R1
		BEQ		loc_102810


loc_1027EC				; CODE XREF: get_remote_PC+C8j
		ADD		R3, R3,	#1
		B		loc_1027C8

; ---------------------------------------------------------------------------

loc_1027F4				; CODE XREF: get_remote_PC+C0j
		ADD		R3, SP,	#0xB10+var_978
		LDR		R0, =(aRunappletTid00+0x1C)
		LDR		R6, [R3,R5,LSL#2]
		MOV		R1, R6
		BL		nsDbgPrint

		CMP		R4, #0
		MOVEQ		R4, R6


loc_102810				; CODE XREF: get_remote_PC+DCj
		ADD		R5, R5,	#1
		B		loc_1027B8

; ---------------------------------------------------------------------------

loc_102818				; CODE XREF: get_remote_PC+B4j
		LDR		R0, =aRecommendLr ; "recommend lr:\n"
		BL		nsDbgPrint

		MOV		R5, #0


loc_102824				; CODE XREF: get_remote_PC+174j
		LDR		R2, [SP,#0xB10+var_B0C]
		CMP		R5, R2
		BCS		loc_102884

		MOV		R3, #0


loc_102834				; CODE XREF: get_remote_PC+150j
		CMP		R3, R2
		BEQ		loc_102860

		CMP		R5, R3
		BEQ		loc_102858

		ADD		R1, SP,	#0xB10+var_7E8
		LDR		R0, [R1,R5,LSL#2]
		LDR		R1, [R1,R3,LSL#2]
		CMP		R0, R1
		BEQ		loc_10287C


loc_102858				; CODE XREF: get_remote_PC+134j
		ADD		R3, R3,	#1
		B		loc_102834

; ---------------------------------------------------------------------------

loc_102860				; CODE XREF: get_remote_PC+12Cj
		ADD		R3, SP,	#0xB10+var_7E8
		LDR		R0, =(aRunappletTid00+0x1C)
		LDR		R6, [R3,R5,LSL#2]
		MOV		R1, R6
		BL		nsDbgPrint

		CMP		R4, #0
		MOVEQ		R4, R6


loc_10287C				; CODE XREF: get_remote_PC+148j
		ADD		R5, R5,	#1
		B		loc_102824

; ---------------------------------------------------------------------------

loc_102884				; CODE XREF: get_remote_PC+120j
		MOV		R0, R4


loc_102888				; CODE XREF: get_remote_PC+40j
		ADD		SP, SP,	#0xAF0
		ADD		SP, SP,	#0xC
		LDMFD		SP!, {R4-R7,PC}

; End of function get_remote_PC

; ---------------------------------------------------------------------------
off_102894	DCD aGetthreadlistF	; DATA XREF: get_remote_PC+34r
					; ROM:offsets_starto
					; "getThreadList failed: %08x\n"
off_102898	DCD aRecommendPc	; DATA XREF: get_remote_PC:loc_1027A8r
					; ROM:offsets_starto
					; "recommend pc:\n"
off_10289C	DCD aRunappletTid00+0x1C ; DATA	XREF: get_remote_PC+ECr
					; get_remote_PC+158r ...
off_1028A0	DCD aRecommendLr	; DATA XREF: get_remote_PC:loc_102818r
					; ROM:offsets_starto
					; "recommend lr:\n"

; =============== S U B	R O U T	I N E =======================================


handle_listthread_packet		; CODE XREF: dispatch_client_cmd+C4p

hProcess	= -0x7F0
var_7EC		= -0x7EC
var_7E8		= -0x7E8
var_658		= -0x658
var_620		= -0x620
var_61C		= -0x61C

		LDR		R3, =dword_10AAF4
		STMFD		SP!, {R4-R7,LR}
		SUB		SP, SP,	#0x7D0
		LDR		R3, [R3]
		SUB		SP, SP,	#0xC
		ADD		R3, R3,	#0x2000
		ADD		R5, SP,	#0x7F0+var_7E8
		LDR		R1, [R3,#0x34]
		SUB		R0, R5,	#8
		BL		OpenProcess

		SUBS		R1, R0,	#0
		BEQ		loc_1028EC

		LDR		R0, =aOpenprocessF_0 ; "openProcess failed: %08x\n"
		MOV		R2, #0
		BL		nsDbgPrint

		MOV		R3, #0
		STR		R3, [SP,#0x7F0+hProcess]
		B		loc_1029A4

; ---------------------------------------------------------------------------

loc_1028EC				; CODE XREF: handle_listthread_packet+2Cj
		MOV		R1, R5
		SUB		R0, R5,	#4
		MOV		R2, #0x64 ; 'd'
		LDR		R3, [SP,#0x7F0+hProcess]
		BL		GetThreadList

		SUBS		R1, R0,	#0
		MOVEQ		R4, R1
		ADDEQ		R7, SP,	#0x7F0+var_658
		BEQ		loc_102948

		LDR		R0, =aGetthreadlistF ; "getThreadList failed: %08x\n"
		BL		nsDbgPrint

		B		loc_1029B4

; ---------------------------------------------------------------------------

loc_10291C				; CODE XREF: handle_listthread_packet+8Cj
					; handle_listthread_packet+F4j
		LDR		R1, [R7,R6,LSL#2]
		LDR		R0, =(aRD08x+4)
		ADD		R6, R6,	#1
		BL		nsDbgPrint

		CMP		R6, #0x20 ; ' '
		BNE		loc_10291C

		LDR		R0, =(aWillListenAtPortD+0x17)
		BL		nsDbgPrint

		MOV		R0, #0
		BL		CloseHandle

		ADD		R4, R4,	#1


loc_102948				; CODE XREF: handle_listthread_packet+68j
		LDR		R3, [SP,#0x7F0+var_7EC]
		CMP		R4, R3
		BCS		loc_10299C

		LDR		R6, [R5,R4,LSL#2]
		LDR		R0, =aTid0x08x ; "tid: 0x%08x\n"
		MOV		R1, R6
		BL		nsDbgPrint

		MOV		R1, #0x33 ; '3'
		MOV		R2, #0x640
		MOV		R0, R7
		BL		memset_

		MOV		R1, R6	; tid
		MOV		R2, R7	; context_struc
		LDR		R0, [SP,#0x7F0+hProcess] ; hProcess
		BL		get_thread_context

		LDR		R0, =aPc08xLr08x ; "pc: %08x, lr: %08x\n"
		LDR		R1, [SP,#0x7F0+var_61C]
		LDR		R2, [SP,#0x7F0+var_620]
		BL		nsDbgPrint

		MOV		R6, #0
		B		loc_10291C

; ---------------------------------------------------------------------------

loc_10299C				; CODE XREF: handle_listthread_packet+ACj
		LDR		R0, [SP,#0x7F0+hProcess]
		BL		get_remote_PC


loc_1029A4				; CODE XREF: handle_listthread_packet+44j
		LDR		R0, [SP,#0x7F0+hProcess]
		CMP		R0, #0
		BEQ		loc_1029B4

		BL		CloseHandle


loc_1029B4				; CODE XREF: handle_listthread_packet+74j
					; handle_listthread_packet+108j
		ADD		SP, SP,	#0x7D0
		ADD		SP, SP,	#0xC
		LDMFD		SP!, {R4-R7,PC}

; End of function handle_listthread_packet

; ---------------------------------------------------------------------------
off_1029C0	DCD dword_10AAF4	; DATA XREF: handle_listthread_packetr
					; ROM:offsets_starto
off_1029C4	DCD aOpenprocessF_0	; DATA XREF: handle_listthread_packet+30r
					; ROM:offsets_starto
					; "openProcess failed: %08x\n"
off_1029C8	DCD aGetthreadlistF	; DATA XREF: handle_listthread_packet+6Cr
					; ROM:offsets_starto
					; "getThreadList failed: %08x\n"
off_1029CC	DCD aRD08x+4		; DATA XREF: handle_listthread_packet+7Cr
					; ROM:offsets_starto
off_1029D0	DCD aWillListenAtPortD+0x17 ; DATA XREF: handle_listthread_packet+90r
					; ROM:offsets_starto
off_1029D4	DCD aTid0x08x		; DATA XREF: handle_listthread_packet+B4r
					; ROM:offsets_starto
					; "tid: 0x%08x\n"
off_1029D8	DCD aPc08xLr08x		; DATA XREF: handle_listthread_packet+E0r
					; ROM:offsets_starto
					; "pc: %08x, lr: %08x\n"

; =============== S U B	R O U T	I N E =======================================

; if addr is 0,	the hook will be placed	at
; process' current PC

; int __cdecl inject_ntr_into_remote_process(unsigned int handle, unsigned int addr_jmpcode, void *buf)
inject_ntr_into_remote_process		; CODE XREF: inject_ntr_into_home_menu+6Cp
					; handle_attachprocess_packet+74p ...

size		= -0x78
jumpout		= -0x70
jumpout_dst	= -0x6C

		LDR		R3, =arm11BinStart
		STMFD		SP!, {R4-R9,LR}
		MOV		R6, R0
		LDR		R8, [R3]
		LDR		R3, =arm11BinSize
		SUB		SP, SP,	#0x5C
		MOV		R5, R1
		LDR		R9, [R3]
		MOV		R7, R2
		LDR		R0, =aBuf08xSize08x ; "buf: %08x, size: %08x\n"
		MOV		R1, R8
		MOV		R2, R9
		BL		nsDbgPrint

		CMP		R8, #0
		BNE		loc_102A24

		LDR		R0, =aArm11NotLoaded ; "arm11 not loaded\n"
		BL		nsDbgPrint

		B		loc_102B78

; ---------------------------------------------------------------------------

loc_102A24				; CODE XREF: inject_ntr_into_remote_process+38j
		ADD		R4, R9,	#0x5000
		MOV		R1, #0x6000000 ; addr
		MOV		R0, R6	; handle
		MOV		R2, R4	; size
		BL		map_remote_memory

		SUBS		R1, R0,	#0
		BEQ		loc_102A4C

		LDR		R0, =aMapremotememor ; "mapRemoteMemory failed: %08x\n"
		MOV		R2, #0
		BL		nsDbgPrint


loc_102A4C				; CODE XREF: inject_ntr_into_remote_process+60j
		MOV		R2, R4	; size
		MOV		R0, R6	; hKProcess
		MOV		R1, #0x6000000 ; addr
		BL		protectRemoteMemory ; assigns RWX to addr : addr+size

		SUBS		R4, R0,	#0
		LDRNE		R0, =aProtectremotem ; "protectRemoteMemory failed: %08x\n"
		BNE		loc_102B68

		LDR		R3, =hCurKProcess
		STR		R9, [SP,#0x78+size] ; size
		MOV		R0, R6	; hDst
		LDR		R2, [R3] ; hSrc
		LDR		R1, =0x6005000 ; dst_addr
		MOV		R3, R8	; src_addr
		BL		inter_process_dma_copy ; inject	code into foreign process at addr 0x06005000

		SUBS		R4, R0,	#0
		LDRNE		R0, =aCopyremoteme_0 ; "copyRemoteMemory(1) failed: %08x\n"
		BNE		loc_102B68

		CMP		R5, #0
		BNE		loc_102AA4

		MOV		R0, R6
		BL		get_remote_PC

		MOV		R5, R0


loc_102AA4				; CODE XREF: inject_ntr_into_remote_process+B8j
		LDR		R0, =aRemotepc08x ; "remotePC: %08x\n"
		MOV		R1, R5
		MOV		R2, #0
		BL		nsDbgPrint

		CMP		R5, #0
		BEQ		loc_102B74

		MOV		R0, R6	; hProcess
		MOV		R1, R5	; addr
		MOV		R2, #8	; size
		BL		rtCheckRemoteMemoryRegionSafeForWrite

		SUBS		R4, R0,	#0
		LDRNE		R0, =aRtcheckremot_0 ; "rtCheckRemoteMemoryRegionSafeForWrite f"...
		BNE		loc_102B68

		MOV		R1, R7	; dst addr
		MOV		R3, #2
		MOV		R8, #8
		STR		R3, [R1],#0x20
		LDR		R0, =0xFFFF8001	; hDst
		STR		R8, [SP,#0x78+size] ; size
		MOV		R2, R6	; hSrc
		MOV		R3, R5	; src_addr
		BL		inter_process_dma_copy ; back up two instructions at current PC

		SUBS		R4, R0,	#0
		LDRNE		R0, =aCopyremoteme_1 ; "copyRemoteMemory(3) failed: %08x\n"
		BNE		loc_102B68

		MOV		R3, #0x238
		STR		R3, [SP,#0x78+size] ; size
		STR		R5, [R7,#0x28] ; save backed up	PC at offs 0x28
		MOV		R0, R6	; hDst
		MOV		R1, #0x6000000 ; dst_addr
		LDR		R2, =0xFFFF8001	; hSrc
		MOV		R3, R7	; src_addr
		BL		inter_process_dma_copy ; transfer backed up code and configuration to remote process
					; at addr 0x06000000

		SUBS		R4, R0,	#0
		LDRNE		R0, =aCopyremoteme_2 ; "copyRemoteMemory(2) failed: %08x\n"
		BNE		loc_102B68

		LDR		R3, =0xE51FF004
		STR		R8, [SP,#0x78+size] ; size
		STR		R3, [SP,#0x78+jumpout]
		LDR		R3, =0x6005000
		MOV		R0, R6	; hDst
		STR		R3, [SP,#0x78+jumpout_dst]
		MOV		R1, R5	; dst_addr
		LDR		R2, =0xFFFF8001	; hSrc
		ADD		R3, SP,	#0x78+jumpout ;	src_addr
		BL		inter_process_dma_copy ; patch code at current PC to redirect code flow	to addr	0x06005000

		SUBS		R4, R0,	#0
		BEQ		loc_102B74

		LDR		R0, =aCopyremoteme_3 ; "copyRemoteMemory(4) failed: %08x\n"


loc_102B68				; CODE XREF: inject_ntr_into_remote_process+88j
					; inject_ntr_into_remote_process+B0j ...
		MOV		R1, R4
		MOV		R2, #0
		BL		nsDbgPrint


loc_102B74				; CODE XREF: inject_ntr_into_remote_process+DCj
					; inject_ntr_into_remote_process+184j
		MOV		R0, R4


loc_102B78				; CODE XREF: inject_ntr_into_remote_process+44j
		ADD		SP, SP,	#0x5C
		LDMFD		SP!, {R4-R9,PC}

; End of function inject_ntr_into_remote_process

; ---------------------------------------------------------------------------
off_102B80	DCD arm11BinStart	; DATA XREF: inject_ntr_into_remote_processr
					; ROM:offsets_starto
off_102B84	DCD arm11BinSize	; DATA XREF: inject_ntr_into_remote_process+10r
					; ROM:offsets_starto
off_102B88	DCD aBuf08xSize08x	; DATA XREF: inject_ntr_into_remote_process+24r
					; ROM:offsets_starto
					; "buf: %08x, size: %08x\n"
off_102B8C	DCD aArm11NotLoaded	; DATA XREF: inject_ntr_into_remote_process+3Cr
					; ROM:offsets_starto
					; "arm11 not loaded\n"
off_102B90	DCD aMapremotememor	; DATA XREF: inject_ntr_into_remote_process+64r
					; ROM:offsets_starto
					; "mapRemoteMemory failed: %08x\n"
off_102B94	DCD aProtectremotem	; DATA XREF: inject_ntr_into_remote_process+84r
					; ROM:offsets_starto
					; "protectRemoteMemory failed: %08x\n"
off_102B98	DCD hCurKProcess	; DATA XREF: inject_ntr_into_remote_process+8Cr
					; ROM:offsets_starto
; void *dst_addr
dst_addr	DCD 0x6005000		; DATA XREF: inject_ntr_into_remote_process+9Cr
					; inject_ntr_into_remote_process+164r
off_102BA0	DCD aCopyremoteme_0	; DATA XREF: inject_ntr_into_remote_process+ACr
					; ROM:offsets_starto
					; "copyRemoteMemory(1) failed: %08x\n"
off_102BA4	DCD aRemotepc08x	; DATA XREF: inject_ntr_into_remote_process:loc_102AA4r
					; ROM:offsets_starto
					; "remotePC: %08x\n"
off_102BA8	DCD aRtcheckremot_0	; DATA XREF: inject_ntr_into_remote_process+F4r
					; ROM:offsets_starto
					; "rtCheckRemoteMemoryRegionSafeForWrite f"...
; unsigned int dword_102BAC
dword_102BAC	DCD 0xFFFF8001		; DATA XREF: inject_ntr_into_remote_process+10Cr
					; inject_ntr_into_remote_process+140r ...
off_102BB0	DCD aCopyremoteme_1	; DATA XREF: inject_ntr_into_remote_process+124r
					; ROM:offsets_starto
					; "copyRemoteMemory(3) failed: %08x\n"
off_102BB4	DCD aCopyremoteme_2	; DATA XREF: inject_ntr_into_remote_process+150r
					; ROM:offsets_starto
					; "copyRemoteMemory(2) failed: %08x\n"
dword_102BB8	DCD 0xE51FF004		; DATA XREF: inject_ntr_into_remote_process+158r
off_102BBC	DCD aCopyremoteme_3	; DATA XREF: inject_ntr_into_remote_process+188r
					; ROM:offsets_starto
					; "copyRemoteMemory(4) failed: %08x\n"

; =============== S U B	R O U T	I N E =======================================


handle_attachprocess_packet		; CODE XREF: dispatch_client_cmd+D4p

handle		= -0x24C
buf		= -0x248
var_244		= -0x244

		LDR		R3, =dword_10AAF4
		STMFD		SP!, {R4,R5,LR}
		SUB		SP, SP,	#0x244
		LDR		R3, [R3]
		MOV		R1, #0
		ADD		R3, R3,	#0x2000
		MOV		R2, #0x238
		ADD		R0, SP,	#0x250+buf
		LDR		R4, [R3,#0x34]
		LDR		R5, [R3,#0x38]
		BL		memset_

		CMP		R4, #2
		MOVEQ		R3, #0x3E8
		LDRNE		R3, =0x3EA
		MOV		R1, R4
		ADD		R0, SP,	#0x250+handle
		STR		R3, [SP,#0x250+var_244]
		BL		OpenProcess

		SUBS		R1, R0,	#0
		BEQ		loc_102C28

		LDR		R0, =aOpenprocessF_0 ; "openProcess failed: %08x\n"
		MOV		R2, #0
		BL		nsDbgPrint

		MOV		R3, #0
		STR		R3, [SP,#0x250+handle]
		B		loc_102C48

; ---------------------------------------------------------------------------

loc_102C28				; CODE XREF: handle_attachprocess_packet+4Cj
		MOV		R1, R5	; addr_jmpcode
		LDR		R0, [SP,#0x250+handle] ; handle
		ADD		R2, SP,	#0x250+buf ; buf
		BL		inject_ntr_into_remote_process ; if addr is 0, the hook	will be	placed at
					; process' current PC

		ADD		R1, R4,	#0x1380
		LDR		R0, =aWillListenAtPortD	; "will listen at port %d \n"
		ADD		R1, R1,	#8
		BL		nsDbgPrint


loc_102C48				; CODE XREF: handle_attachprocess_packet+64j
		LDR		R0, [SP,#0x250+handle]
		CMP		R0, #0
		BEQ		loc_102C58

		BL		CloseHandle


loc_102C58				; CODE XREF: handle_attachprocess_packet+90j
		ADD		SP, SP,	#0x244
		LDMFD		SP!, {R4,R5,PC}

; End of function handle_attachprocess_packet

; ---------------------------------------------------------------------------
off_102C60	DCD dword_10AAF4	; DATA XREF: handle_attachprocess_packetr
					; ROM:offsets_starto
dword_102C64	DCD 0x3EA		; DATA XREF: handle_attachprocess_packet+34r
off_102C68	DCD aOpenprocessF_0	; DATA XREF: handle_attachprocess_packet+50r
					; ROM:offsets_starto
					; "openProcess failed: %08x\n"
off_102C6C	DCD aWillListenAtPortD	; DATA XREF: handle_attachprocess_packet+7Cr
					; ROM:offsets_starto
					; "will listen at port %d \n"

; =============== S U B	R O U T	I N E =======================================


send_proc_context_to_client		; CODE XREF: check_for_bp_hit+84p
		STMFD		SP!, {R3-R5,LR}
		MOV		R4, R0
		MOV		R5, R4
		LDR		R0, =aCpsr08x ;	"cpsr:%08x "
		LDR		R1, [R5],#0x38
		BL		nsDbgPrint

		LDR		R1, [R4,#0x38]
		LDR		R0, =aLr08xSp08x ; "lr:%08x sp:%08x\n"
		MOV		R2, R5
		BL		nsDbgPrint

		MOV		R1, #0


loc_102C9C				; CODE XREF: send_proc_context_to_client+44j
		ADD		R5, R1,	#1
		LDR		R0, =aRD08x ; "r%d:%08x "
		LDR		R2, [R4,R5,LSL#2]
		BL		nsDbgPrint

		CMP		R5, #0xD
		MOV		R1, R5
		BNE		loc_102C9C

		LDR		R0, =(aWillListenAtPortD+0x17)
		LDMFD		SP!, {R3-R5,LR}
		B		nsDbgPrint

; End of function send_proc_context_to_client

; ---------------------------------------------------------------------------
off_102CC4	DCD aCpsr08x		; DATA XREF: send_proc_context_to_client+Cr
					; ROM:offsets_starto
					; "cpsr:%08x "
off_102CC8	DCD aLr08xSp08x		; DATA XREF: send_proc_context_to_client+1Cr
					; ROM:offsets_starto
					; "lr:%08x sp:%08x\n"
off_102CCC	DCD aRD08x		; DATA XREF: send_proc_context_to_client+30r
					; ROM:offsets_starto
					; "r%d:%08x "
off_102CD0	DCD aWillListenAtPortD+0x17 ; DATA XREF: send_proc_context_to_client+48r
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


check_for_bp_hit			; CODE XREF: handle_network_client:good_magic_valp

var_14		= -0x14
var_10		= -0x10
var_C		= -0xC

		STMFD		SP!, {R0-R4,LR}
		LDR		R4, =dword_10AAF4
		LDR		R0, [R4]
		ADD		R0, R0,	#0xB700
		ADD		R0, R0,	#0x94 ;	lock
		BL		rtAcquireLock

		LDR		R2, [R4]
		ADD		R3, SP,	#0x18+var_14
		ADD		R2, R2,	#0xB700
		MOV		R12, R2
		LDR		R0, [R12,#0x98]!
		LDR		R1, [R12,#4]
		STMIA		R3!, {R0,R1}
		LDR		R0, [R12,#8]
		STR		R0, [R3]
		ADD		R0, R2,	#0x94 ;	lock
		BL		rtReleaseLock

		LDR		R3, [SP,#0x18+var_14]
		CMP		R3, #0
		BEQ		loc_102D60

		LDR		R3, [SP,#0x18+var_C]
		CMP		R3, #1
		MOVEQ		R3, #0
		BEQ		loc_102D60

		LDR		R3, [R4]
		ADD		R3, R3,	#0xB000
		LDR		R3, [R3,#0x7A4]
		CMP		R3, #0
		BNE		loc_102D5C

		LDR		R0, =aBreakpointDHit ; "breakpoint %d hit\n"
		LDR		R1, [SP,#0x18+var_14]
		BL		nsDbgPrint

		LDR		R0, [SP,#0x18+var_10]
		BL		send_proc_context_to_client


loc_102D5C				; CODE XREF: check_for_bp_hit+70j
		MOV		R3, #1


loc_102D60				; CODE XREF: check_for_bp_hit+4Cj
					; check_for_bp_hit+5Cj
		LDR		R2, [R4]
		ADD		R2, R2,	#0xB000
		STR		R3, [R2,#0x7A4]
		ADD		SP, SP,	#0x10
		LDMFD		SP!, {R4,PC}

; End of function check_for_bp_hit

; ---------------------------------------------------------------------------
off_102D74	DCD dword_10AAF4	; DATA XREF: check_for_bp_hit+4r
					; ROM:offsets_starto
off_102D78	DCD aBreakpointDHit	; DATA XREF: check_for_bp_hit+74r
					; ROM:offsets_starto
					; "breakpoint %d hit\n"

; =============== S U B	R O U T	I N E =======================================


dispatch_client_cmd			; CODE XREF: handle_network_client+A8p
		STMFD		SP!, {R3-R5,LR}
		LDR		R3, =dword_10AAF4
		LDR		R4, [R3]
		ADD		R4, R4,	#0x2000
		LDR		R3, [R4,#0x74]
		STR		R3, [R4,#0x78]
		LDR		R3, [R4,#0x30]
		CMP		R3, #3
		BNE		loc_102DAC

handle_hello_packet:
		LDR		R0, =aHello ; "hello"
		LDMFD		SP!, {R3-R5,LR}
		B		nsDbgPrint

; ---------------------------------------------------------------------------

loc_102DAC				; CODE XREF: dispatch_client_cmd+20j
		CMP		R3, #0
		BNE		loc_102E04

handle_heartbeat_packet:
		LDR		R5, =p_config_memory
		LDR		R0, [R5]
		ADD		R0, R0,	#0x1C ;	lock
		BL		rtAcquireLock

		LDR		R3, [R5]
		LDR		R3, [R3,#NS_CONFIG.debugPtr]
		STR		R3, [R4,#0x74]
		BL		sub_101984

		LDR		R1, [R4,#0x74]
		CMP		R1, #0
		BEQ		loc_102DEC

		LDR		R3, [R5]
		LDR		R0, [R3,#NS_CONFIG.debugBuf]
		BL		sub_1019AC


loc_102DEC				; CODE XREF: dispatch_client_cmd+60j
		LDR		R0, [R5]
		MOV		R3, #0
		ADD		R0, R0,	#NS_CONFIG.debugBufferLock ; lock
		STR		R3, [R0,#-8]
		LDMFD		SP!, {R3-R5,LR}
		B		rtReleaseLock

; ---------------------------------------------------------------------------

loc_102E04				; CODE XREF: dispatch_client_cmd+34j
		CMP		R3, #1
		BNE		loc_102E14

		LDMFD		SP!, {R3-R5,LR}
		B		handle_savefile_packet

; ---------------------------------------------------------------------------

loc_102E14				; CODE XREF: dispatch_client_cmd+8Cj
		CMP		R3, #4
		BNE		loc_102E24

		LDMFD		SP!, {R3-R5,LR}
		B		handle_reload_packet

; ---------------------------------------------------------------------------

loc_102E24				; CODE XREF: dispatch_client_cmd+9Cj
		CMP		R3, #5
		BNE		loc_102E34

		LDMFD		SP!, {R3-R5,LR}
		B		handle_listprocess_packet

; ---------------------------------------------------------------------------

loc_102E34				; CODE XREF: dispatch_client_cmd+ACj
		CMP		R3, #7
		BNE		loc_102E44

		LDMFD		SP!, {R3-R5,LR}
		B		handle_listthread_packet

; ---------------------------------------------------------------------------

loc_102E44				; CODE XREF: dispatch_client_cmd+BCj
		CMP		R3, #6
		BNE		loc_102E54

		LDMFD		SP!, {R3-R5,LR}
		B		handle_attachprocess_packet

; ---------------------------------------------------------------------------

loc_102E54				; CODE XREF: dispatch_client_cmd+CCj
		CMP		R3, #8
		BNE		loc_102E64

		LDMFD		SP!, {R3-R5,LR}
		B		handle_memlayout_packet

; ---------------------------------------------------------------------------

loc_102E64				; CODE XREF: dispatch_client_cmd+DCj
		CMP		R3, #9
		BNE		loc_102E74

		LDMFD		SP!, {R3-R5,LR}
		B		handle_readmem_packet

; ---------------------------------------------------------------------------

loc_102E74				; CODE XREF: dispatch_client_cmd+ECj
		CMP		R3, #0xA
		BNE		loc_102E84

		LDMFD		SP!, {R3-R5,LR}
		B		handle_writemem_packet

; ---------------------------------------------------------------------------

loc_102E84				; CODE XREF: dispatch_client_cmd+FCj
		CMP		R3, #0xB
		BNE		loc_102E94

		LDMFD		SP!, {R3-R5,LR}
		B		handle_debugcmd_packet ; breakpoint and	resume cmds

; ---------------------------------------------------------------------------

loc_102E94				; CODE XREF: dispatch_client_cmd+10Cj
		CMP		R3, #0xC
		LDMNEFD		SP!, {R3-R5,PC}

		LDMFD		SP!, {R3-R5,LR}
		B		handle_queryhandle_packet

; End of function dispatch_client_cmd

; ---------------------------------------------------------------------------
off_102EA4	DCD dword_10AAF4	; DATA XREF: dispatch_client_cmd+4r
					; ROM:offsets_starto
off_102EA8	DCD aHello		; DATA XREF: dispatch_client_cmd+24r
					; ROM:offsets_starto
					; "hello"
off_102EAC	DCD p_config_memory	; DATA XREF: dispatch_client_cmd+38r
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


handle_network_client			; CODE XREF: thread_handle_network_client+4p
					; setup_ntr_network_server+18Cp

var_28		= -0x28
var_24		= -0x24

		STMFD		SP!, {R0-R8,LR}


loc_102EB4				; CODE XREF: handle_network_client+2Cj
		BL		check_plugin_exit_flag

		MOV		R0, #2
		MOV		R1, #1
		MOV		R2, #0
		BL		socket

		SUBS		R6, R0,	#0
		BGT		loc_102EE0

		LDR		R0, =0x3B9ACA00
		MOV		R1, #0
		BL		SleepThread

		B		loc_102EB4

; ---------------------------------------------------------------------------

loc_102EE0				; CODE XREF: handle_network_client+1Cj
		LDR		R4, =dword_10AAF4
		MOV		R2, #2
		STRH		R2, [SP,#0x28+var_28]
		LDR		R3, [R4]
		MOV		R5, #0
		STR		R6, [R3,#4]
		LDRH		R0, [R3]
		BL		sub_104C98

		MOV		R1, SP
		MOV		R2, #0x10
		STR		R5, [SP,#0x28+var_24]
		STRH		R0, [SP,#0x28+var_28+2]
		MOV		R0, R6
		BL		bind_

		SUBS		R1, R0,	#0
		LDRLT		R0, =aBindFailed08x ; "bind failed: %08x"
		BLT		loc_102F44

		MOV		R1, #1
		MOV		R0, R6
		BL		listen_

		SUBS		R1, R0,	#0
		MOVGE		R7, R4
		LDRGE		R8, =0x12345678	; magic
		BGE		loc_102F94

		LDR		R0, =aListenFailed08 ; "listen failed: %08x"


loc_102F44				; CODE XREF: handle_network_client+70j
		MOV		R2, R5
		BL		showDbg

		ADD		SP, SP,	#0x10
		LDMFD		SP!, {R4-R8,PC}

; ---------------------------------------------------------------------------

good_magic_val				; CODE XREF: handle_network_client+12Cj
		BL		check_for_bp_hit

		BL		dispatch_client_cmd


loc_102F5C				; CODE XREF: handle_network_client+108j
		LDR		R1, [R4]
		MOV		R0, R5
		ADD		R1, R1,	#0x2000
		ADD		R1, R1,	#0x24
		MOV		R2, #0x54 ; 'T'
		BL		recv_

		CMP		R0, #0x54 ; 'T'
		MOV		R1, R0
		BEQ		recvd_54_bytes

		LDR		R0, =aRtrecvsocketFa ; "rtRecvSocket failed: %08x"
		MOV		R2, #0


loc_102F88				; CODE XREF: handle_network_client+138j
		BL		nsDbgPrint

		MOV		R0, R5
		BL		close


loc_102F94				; CODE XREF: handle_network_client+8Cj
					; handle_network_client+118j
		BL		check_plugin_exit_flag

		MOV		R1, #0
		MOV		R0, R6
		MOV		R2, R1
		BL		accept

		LDR		R3, [R4]
		CMP		R0, #0
		MOV		R5, R0
		STR		R0, [R3,#8]
		BGE		loc_102F5C

		LDR		R0, =0x3B9ACA00
		MOV		R1, #0
		BL		SleepThread

		B		loc_102F94

; ---------------------------------------------------------------------------

recvd_54_bytes				; CODE XREF: handle_network_client+CCj
		LDR		R3, [R7]
		ADD		R3, R3,	#0x2000
		LDR		R1, [R3,#0x24]
		CMP		R1, R8
		BEQ		good_magic_val

		LDR		R0, =aBrokenProtocol ; "broken protocol: %08x, %08x"
		LDR		R2, [R3,#0x28]
		B		loc_102F88

; End of function handle_network_client

; ---------------------------------------------------------------------------
p_some_code	DCD 0x3B9ACA00		; DATA XREF: get_kernel_version_info+2Co
					; ROM:off_100C9Co ...
off_102FF0	DCD dword_10AAF4	; DATA XREF: handle_network_client:loc_102EE0r
					; ROM:offsets_starto
off_102FF4	DCD aBindFailed08x	; DATA XREF: handle_network_client+6Cr
					; ROM:offsets_starto
					; "bind failed: %08x"
dword_102FF8	DCD 0x12345678		; DATA XREF: handle_network_client+88r
off_102FFC	DCD aListenFailed08	; DATA XREF: handle_network_client+90r
					; ROM:offsets_starto
					; "listen failed: %08x"
off_103000	DCD aRtrecvsocketFa	; DATA XREF: handle_network_client+D0r
					; ROM:offsets_starto
					; "rtRecvSocket failed: %08x"
off_103004	DCD aBrokenProtocol	; DATA XREF: handle_network_client+130r
					; ROM:offsets_starto
					; "broken protocol: %08x, %08x"

; =============== S U B	R O U T	I N E =======================================

; Attributes: noreturn

thread_handle_network_client		; DATA XREF: setup_ntr_network_server+1B0o
					; ROM:off_10327Co
		STMFD		SP!, {R3,LR}
		BL		handle_network_client

		LDMFD		SP!, {R3,LR}
		B		ExitThread

; End of function thread_handle_network_client


; =============== S U B	R O U T	I N E =======================================


init_config_mem				; CODE XREF: thread_NTR_home_injectee+B0p
					; install_ntr+14Cp
		STMFD		SP!, {R4,LR}
		LDR		R4, =p_config_memory
		LDR		R3, =cb_plugin_info ; will point to update_plugin_info
		LDR		R2, =init_debugger
		LDR		R0, [R4]
		STR		R2, [R3] ; will	point to update_plugin_info
		ADD		R0, R0,	#NS_CONFIG.debugBufferLock ; lock
		BL		rtInitLock

		LDR		R3, [R4]
		LDR		R2, =0x6000900
		STR		R2, [R3,#0xC] ;	offset 0xC = 0x6000900
		MOV		R2, #0xF0 ; 'ð'
		STR		R2, [R3,#0x10] ; offs 0x10 = 0xF0
		MOV		R2, #0
		STR		R2, [R3,#0x14]
		MOV		R2, #1
		STR		R2, [R3,#0x18]
		LDMFD		SP!, {R4,PC}

; End of function init_config_mem

; ---------------------------------------------------------------------------
off_103060	DCD p_config_memory	; DATA XREF: init_config_mem+4r
					; ROM:offsets_starto
off_103064	DCD cb_plugin_info	; DATA XREF: init_config_mem+8r
					; ROM:offsets_starto
					; will point to	update_plugin_info
off_103068	DCD init_debugger	; DATA XREF: init_config_mem+Cr
					; ROM:offsets_starto
dword_10306C	DCD 0x6000900		; DATA XREF: init_config_mem+24r

; =============== S U B	R O U T	I N E =======================================


setup_ntr_network_server		; CODE XREF: thread_setup_ntr_network_server+10p
					; thread_NTR_home_injectee+B4p

outaddr		= -0x18
var_14		= -0x14

		STMFD		SP!, {R0-R6,LR}	; operation
		LDR		R0, =0xB7A8
		BL		round_to_pagesize_

		LDR		R4, =p_config_memory
		LDR		R3, [R4]
		LDR		R3, [R3,#NS_CONFIG]
		CMP		R3, #1


loc_10308C				; DATA XREF: get_kernel_version_info+50o
					; ROM:off_100CA4o
		MOVEQ		R3, #0x6F00000
		STREQ		R3, [SP,#0x20+outaddr]
		ADD		R5, R0,	#0x44000
		BEQ		loc_1030C8

		LDR		R0, =0x203
		MOV		R3, #3
		MOV		R1, #0x6F00000 ; addr0
		STMEA		SP, {R0,R3}
		MOV		R2, #0	; addr1
		ADD		R0, SP,	#0x20+outaddr ;	outaddr
		MOV		R3, R5	; size
		BL		ControlMemory

		SUBS		R1, R0,	#0
		LDRNE		R0, =aSvc_controlmem ; "svc_controlMemory failed: %08x"
		BNE		loc_103248


loc_1030C8				; CODE XREF: setup_ntr_network_server+28j
		BL		get_current_process_handle

		MOV		R1, #0x6F00000 ; addr
		MOV		R2, R5	; size
		BL		rtCheckRemoteMemoryRegionSafeForWrite

		SUBS		R1, R0,	#0
		BEQ		loc_1030EC

		LDR		R0, =aRtcheckremot_1 ; "rtCheckRemoteMemoryRegionSafeForWrite f"...
		MOV		R2, #0
		BL		showDbg


loc_1030EC				; CODE XREF: setup_ntr_network_server+6Cj
		LDR		R3, =h_srv
		LDR		R3, [R3]
		CMP		R3, #0
		BNE		loc_103100

		BL		get_srv_handle


loc_103100				; CODE XREF: setup_ntr_network_server+88j
		LDR		R3, [R4]
		LDR		R5, [R3,#NS_CONFIG.hSOCU]
		CMP		R5, #0
		LDRNE		R3, =hSession
		STRNE		R5, [R3]
		BNE		loc_103148

		MOV		R1, #0x40000
		LDR		R0, [SP,#0x20+outaddr]
		BL		SOC_Initialize

		SUBS		R1, R0,	#0
		MOVNE		R2, R5
		LDRNE		R0, =aSoc_initialize ; "SOC_Initialize failed: %08x"
		BNE		loc_10324C

		LDR		R3, =p_config_memory
		LDR		R2, =hSession
		LDR		R3, [R3]
		LDR		R2, [R2]
		STR		R2, [R3,#8]


loc_103148				; CODE XREF: setup_ntr_network_server+A4j
		LDR		R0, [SP,#0x20+outaddr]
		LDR		R5, =dword_10AAF4
		ADD		R0, R0,	#0x40000
		MOV		R1, #0
		LDR		R2, =0xB7A8
		STR		R0, [R5]
		BL		memset_

		LDR		R6, [R5]
		MOV		R3, #0x1F40
		STR		R3, [R6]
		LDR		R3, [R4]
		LDR		R3, [R3,#NS_CONFIG]
		CMP		R3, #2
		BNE		loc_103190

		BL		get_current_process_id

		ADD		R0, R0,	#0x1380
		ADD		R0, R0,	#8
		STR		R0, [R6] ; *r6 = pid + 0x1388


loc_103190				; CODE XREF: setup_ntr_network_server+10Cj
		LDR		R0, [R5]
		ADD		R0, R0,	#0x6000
		ADD		R0, R0,	#0x90 ;	lock
		BL		rtInitLock

		LDR		R0, [R5]
		ADD		R0, R0,	#0xB700
		ADD		R0, R0,	#0x94 ;	lock
		BL		rtInitLock

		LDR		R3, [R4]
		LDR		R2, [R5]
		ADD		R2, R2,	#0x10
		STR		R2, [R3,#NS_CONFIG.debugBuf]
		MOV		R2, #0
		STR		R2, [R3,#NS_CONFIG.debugPtr]
		MOV		R2, #0x2000
		STR		R2, [R3,#NS_CONFIG.debugBufSize]
		LDR		R2, [R3]
		CMP		R2, #2
		BNE		loc_1031E8

		MOV		R0, #1
		MOV		R1, #0x100000
		BL		debugcmd_init_breakpoint


loc_1031E8				; CODE XREF: setup_ntr_network_server+168j
		LDR		R3, [R4]
		LDR		R3, [R3]
		SUB		R3, R3,	#1
		CMP		R3, #1
		BHI		more_than_one_connection

		BL		handle_network_client

		B		loc_103250

; ---------------------------------------------------------------------------

more_than_one_connection		; CODE XREF: setup_ntr_network_server+188j
		LDR		R0, =0xB7A8
		LDR		R4, [SP,#0x20+outaddr]
		BL		round_to_pagesize_

		ADD		R4, R4,	#0x40000
		MOV		R1, #0x10
		MOV		R2, #0xFFFFFFFE
		STMEA		SP, {R1,R2}
		LDR		R1, =thread_handle_network_client
		MOV		R2, #0
		ADD		R0, R4,	R0
		ADD		R3, R0,	#0x3FC0
		ADD		R3, R3,	#0x18
		ADD		R0, SP,	#0x20+var_14
		BL		CreateThread

		SUBS		R1, R0,	#0
		BEQ		loc_103250

		LDR		R0, =aSvc_createthre ; "svc_createThread failed: %08x"


loc_103248				; CODE XREF: setup_ntr_network_server+54j
		MOV		R2, #0


loc_10324C				; CODE XREF: setup_ntr_network_server+C0j
		BL		showDbg


loc_103250				; CODE XREF: setup_ntr_network_server+190j
					; setup_ntr_network_server+1D0j
		ADD		SP, SP,	#0x10
		LDMFD		SP!, {R4-R6,PC}

; End of function setup_ntr_network_server

; ---------------------------------------------------------------------------
dword_103258	DCD 0xB7A8		; DATA XREF: setup_ntr_network_server+4r
					; setup_ntr_network_server+E8r	...
off_10325C	DCD p_config_memory	; DATA XREF: setup_ntr_network_server+Cr
					; setup_ntr_network_server+C4r	...
dword_103260	DCD 0x203		; DATA XREF: setup_ntr_network_server+2Cr
off_103264	DCD aSvc_controlmem	; DATA XREF: setup_ntr_network_server+50r
					; ROM:offsets_starto
					; "svc_controlMemory failed: %08x"
off_103268	DCD aRtcheckremot_1	; DATA XREF: setup_ntr_network_server+70r
					; ROM:offsets_starto
					; "rtCheckRemoteMemoryRegionSafeForWrite f"...
off_10326C	DCD h_srv		; DATA XREF: setup_ntr_network_server:loc_1030ECr
					; ROM:offsets_starto
off_103270	DCD hSession		; DATA XREF: setup_ntr_network_server+9Cr
					; setup_ntr_network_server+C8r	...
off_103274	DCD aSoc_initialize	; DATA XREF: setup_ntr_network_server+BCr
					; ROM:offsets_starto
					; "SOC_Initialize failed: %08x"
off_103278	DCD dword_10AAF4	; DATA XREF: setup_ntr_network_server+DCr
					; ROM:offsets_starto
off_10327C	DCD thread_handle_network_client ; DATA	XREF: setup_ntr_network_server+1B0r
					; ROM:offsets_starto
off_103280	DCD aSvc_createthre	; DATA XREF: setup_ntr_network_server+1D4r
					; ROM:offsets_starto
					; "svc_createThread failed: %08x"
; ---------------------------------------------------------------------------
		ADD		R3, R0,	#0xEC000000
		CMN		R3, #0xF8000001
		BHI		loc_103298

		ADD		R0, R0,	#0xC000000
		BX		LR

; ---------------------------------------------------------------------------

loc_103298				; CODE XREF: ROM:0010328Cj
		ADD		R3, R0,	#0xD0000000
		CMN		R3, #0xF0000001
		BHI		loc_1032AC

		ADD		R0, R0,	#0xF0000000
		BX		LR

; ---------------------------------------------------------------------------

loc_1032AC				; CODE XREF: ROM:001032A0j
		ADD		R3, R0,	#0xE1000000
		CMP		R3, #0x600000
		ADDCC		R0, R0,	#0xF9000000
		MOVCS		R0, #0
		BX		LR

; ---------------------------------------------------------------------------
		STMFD		SP!, {R0-R2,LR}
		MOV		R1, #0x25 ; '%'
		ADD		R0, SP,	#4
		BL		OpenProcess

		STR		R0, [SP,#4]
		BL		CloseHandle

		ADD		SP, SP,	#0xC
		LDR		PC, [SP],#4

; ---------------------------------------------------------------------------

plgRegisterCallback			; DATA XREF: initSharedFunc+30o
					; ROM:off_10572Co
		MOV		R0, #0	; not implemented
		BX		LR


; =============== S U B	R O U T	I N E =======================================


; int __fastcall plgRequestMemory(unsigned int size)
plgRequestMemory			; CODE XREF: create_screenshot_callback+18p
					; DATA XREF: initSharedFunc+28o ...

outaddr		= -0x14

		TST		R0, #1
		STMFD		SP!, {R0-R6,LR}	; operation
		BEQ		loc_1032FC


loc_1032F4				; CODE XREF: plgRequestMemory+5Cj
		MOV		R0, #0
		B		loc_103358

; ---------------------------------------------------------------------------

loc_1032FC				; CODE XREF: plgRequestMemory+8j
		LDR		R3, =dword_10AB04
		MOV		R4, R0
		ADD		R0, SP,	#0x20+outaddr ;	outaddr
		LDR		R2, [R3]
		LDR		R6, =dword_10AB04
		CMP		R2, #0
		LDREQ		R2, =p_plgloader_info_ver_specific
		LDREQ		R2, [R2]
		STREQ		R2, [R3]
		LDR		R2, =0x203
		LDR		R5, [R3]
		MOV		R3, #3
		MOV		R1, R5	; addr0
		STMEA		SP, {R2,R3}
		MOV		R2, R5	; addr1
		MOV		R3, R4	; size
		BL		ControlMemory

		CMP		R0, #0
		BNE		loc_1032F4

		LDR		R0, [R6]
		ADD		R4, R4,	R0
		MOV		R0, R5
		STR		R4, [R6]


loc_103358				; CODE XREF: plgRequestMemory+10j
		ADD		SP, SP,	#0x10
		LDMFD		SP!, {R4-R6,PC}

; End of function plgRequestMemory

; ---------------------------------------------------------------------------
off_103360	DCD dword_10AB04	; DATA XREF: plgRequestMemory:loc_1032FCr
					; plgRequestMemory+24r	...
off_103364	DCD p_plgloader_info_ver_specific ; DATA XREF: plgRequestMemory+2Cr
					; ROM:offsets_starto
dword_103368	DCD 0x203		; DATA XREF: plgRequestMemory+38r

; =============== S U B	R O U T	I N E =======================================


plgGetSharedServiceHandle		; CODE XREF: init_builtin_screenshot_plugin+28p
					; DATA XREF: initSharedFunc+20o ...
		STMFD		SP!, {R4,LR}
		MOV		R4, R1
		LDR		R1, =aFsUser ; "fs:USER"
		BL		get_svc_handle_by_name

		CMP		R0, #0
		BNE		locret_103394

		LDR		R3, =hFSUser
		LDR		R3, [R3]
		STR		R3, [R4]
		LDMFD		SP!, {R4,PC}

; ---------------------------------------------------------------------------

locret_103394				; CODE XREF: plgGetSharedServiceHandle+14j
		LDMFD		SP!, {R4,PC}

; End of function plgGetSharedServiceHandle

; ---------------------------------------------------------------------------
off_103398	DCD aFsUser		; DATA XREF: plgGetSharedServiceHandle+8r
					; ROM:offsets_starto
					; "fs:USER"
off_10339C	DCD hFSUser		; DATA XREF: plgGetSharedServiceHandle+18r
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================

; old: io_get_mapped_register_va
;
; u32 plgGetIoBase(u32 IoType);
; #define IO_BASE_PAD	  1
; #define IO_BASE_LCD	  2
; #define IO_BASE_PDC	  3
; #define IO_BASE_GSPHEAP 4
;

plgGetIoBase				; DATA XREF: initSharedFunc+48o
					; ROM:off_105738o
		CMP		R0, #2
		LDREQ		R3, =va_mapped_io_LCD
		BEQ		loc_1033B8

		CMP		R0, #1
		BNE		loc_1033C0

		LDR		R3, =va_mapped_io_PAD


loc_1033B8				; CODE XREF: plgGetIoBase+8j
					; plgGetIoBase+28j
		LDR		R0, [R3]
		BX		LR

; ---------------------------------------------------------------------------

loc_1033C0				; CODE XREF: plgGetIoBase+10j
		CMP		R0, #3
		LDREQ		R3, =va_mapped_io_PDC
		BEQ		loc_1033B8

		LDR		R3, =0x14006000
		CMP		R0, #4
		MOVEQ		R0, R3
		MOVNE		R0, #0
		BX		LR

; End of function plgGetIoBase

; ---------------------------------------------------------------------------
off_1033E0	DCD va_mapped_io_LCD	; DATA XREF: plgGetIoBase+4r
					; ROM:offsets_starto
off_1033E4	DCD va_mapped_io_PAD	; DATA XREF: plgGetIoBase+14r
					; ROM:offsets_starto
off_1033E8	DCD va_mapped_io_PDC	; DATA XREF: plgGetIoBase+24r
					; ROM:offsets_starto
dword_1033EC	DCD 0x14006000		; DATA XREF: plgGetIoBase+2Cr

; =============== S U B	R O U T	I N E =======================================


display_OSD_menu			; CODE XREF: thread_NTR_home_injectee+F0p

var_238		= -0x238
var_234		= -0x234
var_8		= -8

		STMFD		SP!, {R4,LR}
		SUB		SP, SP,	#0x230
		BL		sub_106EBC

		LDR		R3, =aProcessManager ; "Process Manager"
		LDR		R2, =g_plugin_func_ptrs_
		STR		R3, [SP,#0x238+var_238]
		LDR		R3, =aPlugins ;	"Plugins"
		MOV		R4, #2
		STR		R3, [SP,#0x238+var_234]
		LDR		R3, =dword_10AB04
		MOV		R12, #0xC
		LDR		R0, [R3,#(num_total_plugins - 0x10AB04)]
		MOV		R3, #0


loc_103424				; CODE XREF: display_OSD_menu+68j
		CMP		R3, R0
		BEQ		loc_10345C

		MUL		R1, R12, R3
		ADD		LR, R1,	R2
		LDR		R1, [R1,R2]
		CMP		R1, #1
		ADDEQ		R1, SP,	#0x238+var_8
		ADDEQ		R1, R1,	R4,LSL#2
		LDREQ		LR, [LR,#4]
		STREQ		R3, [R1,#-0x118]
		STREQ		LR, [R1,#-0x230]
		ADDEQ		R4, R4,	#1
		ADD		R3, R3,	#1
		B		loc_103424

; ---------------------------------------------------------------------------

loc_10345C				; CODE XREF: display_OSD_menu+38j
		BL		acquire_video


loc_103460				; CODE XREF: display_OSD_menu+A0j
					; display_OSD_menu+A8j	...
		LDR		R0, =aNtrCfw2_0	; "NTR CFW 2.0"
		MOV		R1, R4
		MOV		R2, SP
		BL		get_process_list_action	; returns
					; 0 - dump
					; 1 - info

		CMN		R0, #1
		BNE		loc_103484


loc_103478				; CODE XREF: display_OSD_menu+D4j
		BL		release_video

		ADD		SP, SP,	#0x230
		LDMFD		SP!, {R4,PC}

; ---------------------------------------------------------------------------

loc_103484				; CODE XREF: display_OSD_menu+84j
		CMP		R0, #0
		BNE		loc_103494

		BL		ntr_cmd_process

		B		loc_103460

; ---------------------------------------------------------------------------

loc_103494				; CODE XREF: display_OSD_menu+98j
		CMP		R0, #1
		BLS		loc_103460

		ADD		R3, SP,	#0x238+var_8
		ADD		R0, R3,	R0,LSL#2
		MOV		R1, #0xC
		LDR		R2, [R0,#-0x118]
		LDR		R3, =g_plugin_func_ptrs_
		MLA		R3, R1,	R2, R3
		LDR		R3, [R3,#8]
		BLX		R3	; call plugin?

		CMP		R0, #0
		BEQ		loc_103460

		B		loc_103478

; End of function display_OSD_menu

; ---------------------------------------------------------------------------
off_1034C8	DCD aProcessManager	; DATA XREF: display_OSD_menu+Cr
					; ROM:offsets_starto
					; "Process Manager"
off_1034CC	DCD g_plugin_func_ptrs_	; DATA XREF: display_OSD_menu+10r
					; display_OSD_menu+BCr	...
off_1034D0	DCD aPlugins		; DATA XREF: display_OSD_menu+18r
					; ROM:offsets_starto
					; "Plugins"
off_1034D4	DCD dword_10AB04	; DATA XREF: display_OSD_menu+24r
					; ROM:offsets_starto
off_1034D8	DCD aNtrCfw2_0		; DATA XREF: display_OSD_menu:loc_103460r
					; ROM:offsets_starto
					; "NTR CFW 2.0"

; =============== S U B	R O U T	I N E =======================================


; int __cdecl plgRegisterMenuEntry(unsigned int	catalog, char *title, void *callback)
plgRegisterMenuEntry			; CODE XREF: init_builtin_screenshot_plugin+1Cp
					; DATA XREF: initSharedFunc+18o ...
		STMFD		SP!, {R4,R5,LR}
		LDR		LR, =dword_10AB04
		LDR		R3, [LR,#(num_total_plugins - 0x10AB04)]
		CMP		R3, #0x3F ; '?'
		BLS		loc_1034F8

		MOV		R0, #0xFFFFFFFF
		LDMFD		SP!, {R4,R5,PC}

; ---------------------------------------------------------------------------

loc_1034F8				; CODE XREF: plgRegisterMenuEntry+10j
		MOV		R12, #0xC
		LDR		R5, =g_plugin_func_ptrs_
		MUL		R12, R12, R3
		ADD		R3, R3,	#1
		ADD		R4, R5,	R12
		STR		R0, [R5,R12]
		STR		R3, [LR,#(num_total_plugins - 0x10AB04)]
		STMIB		R4, {R1,R2}
		LDMFD		SP!, {R4,R5,PC}

; End of function plgRegisterMenuEntry

; ---------------------------------------------------------------------------
off_10351C	DCD dword_10AB04	; DATA XREF: plgRegisterMenuEntry+4r
					; ROM:offsets_starto
off_103520	DCD g_plugin_func_ptrs_	; DATA XREF: plgRegisterMenuEntry+20r
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


alloc_plugin_memory			; CODE XREF: load_ntr_plugins+80p
					; load_all_plugins_and_inject_ntr_into_pm+A0p

outaddr		= -0x1C

		STMFD		SP!, {R0-R8,LR}	; operation
		LDR		R5, =dword_10AB04
		LDR		R3, [R5,#(plgBufferPtr - 0x10AB04)]
		CMP		R3, #0
		LDREQ		R3, =p_plgloader_info_ver_specific
		LDREQ		R3, [R3,#(plgloader_info - 0x108358)]
		STREQ		R3, [R5,#(plgBufferPtr - 0x10AB04)]
		LDR		R6, [R5,#(plgBufferPtr - 0x10AB04)]
		CMP		R0, R6
		BLS		loc_1035BC

		RSB		R8, R6,	R0
		MOV		R1, R6
		MOV		R2, R8
		MOV		R7, R0
		LDR		R0, =aExpandPoolAddr ; "expand pool addr: %08x, size: %08x\n"
		BL		nsDbgPrint

		LDR		R2, =0x203
		MOV		R3, #3
		ADD		R0, SP,	#0x28+outaddr ;	outaddr
		STMEA		SP, {R2,R3}
		MOV		R1, R6	; addr0
		MOV		R2, R6	; addr1
		MOV		R3, R8	; size
		BL		ControlMemory

		SUBS		R4, R0,	#0
		BEQ		loc_1035B8

		LDR		R0, =0xFFFF8001	; hProcess
		MOV		R1, R6	; addr
		MOV		R2, R8	; size
		BL		rtCheckRemoteMemoryRegionSafeForWrite

		CMP		R0, #0
		BEQ		loc_1035B8

		LDR		R0, =aAllocPlgMemory ; "alloc plg memory failed: %08x\n"
		MOV		R1, R4
		BL		nsDbgPrint

		MOV		R0, R4
		B		loc_1035C0

; ---------------------------------------------------------------------------

loc_1035B8				; CODE XREF: alloc_plugin_memory+64j
					; alloc_plugin_memory+7Cj
		STR		R7, [R5,#8]


loc_1035BC				; CODE XREF: alloc_plugin_memory+24j
		MOV		R0, #0


loc_1035C0				; CODE XREF: alloc_plugin_memory+90j
		ADD		SP, SP,	#0x10
		LDMFD		SP!, {R4-R8,PC}

; End of function alloc_plugin_memory

; ---------------------------------------------------------------------------
off_1035C8	DCD dword_10AB04	; DATA XREF: alloc_plugin_memory+4r
					; ROM:offsets_starto
off_1035CC	DCD p_plgloader_info_ver_specific ; DATA XREF: alloc_plugin_memory+10r
					; ROM:offsets_starto
off_1035D0	DCD aExpandPoolAddr	; DATA XREF: alloc_plugin_memory+38r
					; ROM:offsets_starto
					; "expand pool addr: %08x, size: %08x\n"
dword_1035D4	DCD 0x203		; DATA XREF: alloc_plugin_memory+40r
; unsigned int dword_1035D8
dword_1035D8	DCD 0xFFFF8001		; DATA XREF: alloc_plugin_memory+68r
off_1035DC	DCD aAllocPlgMemory	; DATA XREF: alloc_plugin_memory+80r
					; ROM:offsets_starto
					; "alloc plg memory failed: %08x\n"

; =============== S U B	R O U T	I N E =======================================


get_fs_user_handle_0
		STMFD		SP!, {R4,LR}
		LDR		R4, =hFSUser
		LDR		R3, [R4]
		CMP		R3, #0
		LDMNEFD		SP!, {R4,PC}

		LDR		R3, =h_srv
		LDR		R3, [R3]
		CMP		R3, #0
		BNE		loc_103608

		BL		get_srv_handle


loc_103608				; CODE XREF: get_fs_user_handle_0+20j
		LDR		R1, =hFSUser
		LDR		R2, =aFsReg ; "fs:REG"
		MOV		R0, #0
		BL		get_service_session_handle

		LDR		R0, [R4]
		BL		FSUSER_Initialize

		SUBS		R1, R0,	#0
		BEQ		loc_103630

		LDR		R0, =aFsuser_initial ; "FSUSER_Initialize failed: %08x\n"
		BL		nsDbgPrint


loc_103630				; CODE XREF: get_fs_user_handle_0+44j
		LDR		R1, [R4]
		LDR		R0, =aFsuserhandle08 ; "fsUserHandle: %08x\n"
		LDMFD		SP!, {R4,LR}
		B		nsDbgPrint

; End of function get_fs_user_handle_0

; ---------------------------------------------------------------------------
off_103640	DCD hFSUser		; DATA XREF: get_fs_user_handle_0+4r
					; get_fs_user_handle_0:loc_103608r ...
off_103644	DCD h_srv		; DATA XREF: get_fs_user_handle_0+14r
					; ROM:offsets_starto
off_103648	DCD aFsReg		; DATA XREF: get_fs_user_handle_0+2Cr
					; ROM:offsets_starto
					; "fs:REG"
off_10364C	DCD aFsuser_initial	; DATA XREF: get_fs_user_handle_0+48r
					; ROM:offsets_starto
					; "FSUSER_Initialize failed: %08x\n"
off_103650	DCD aFsuserhandle08	; DATA XREF: get_fs_user_handle_0+54r
					; ROM:offsets_starto
					; "fsUserHandle: %08x\n"

; =============== S U B	R O U T	I N E =======================================


inject_into_nintendo_home		; CODE XREF: callback_inject_into_nintendo_home+Cp

size		= -0x498
var_490		= -0x490
var_48C		= -0x48C
dst_addr	= -0x488
var_384		= -0x384
var_380		= -0x380
var_37C		= -0x37C
var_378		= -0x378
var_374		= -0x374
buf		= -0x260
var_25C		= -0x25C

		STMFD		SP!, {R4-R11,LR}
		SUB		SP, SP,	#0x470
		LDR		R7, =dword_10AB04
		SUB		SP, SP,	#4
		MOV		R5, R0
		LDR		R8, [R7,#(plgSize - 0x10AB04)]
		MOV		R6, R7
		CMP		R8, #0
		BNE		loc_103694

		ADD		R0, R7,	#0xC
		MOV		R1, #0xF ; pid 15 = "menu" process?
		BL		OpenProcess

		SUBS		R4, R0,	#0
		STRNE		R8, [R7,#(plgSize - 0x10AB04)]
		LDRNE		R0, =aOpenMenuProces ; "open menu process failed: %08x\n"
		BNE		loc_10388C


loc_103694				; CODE XREF: inject_into_nintendo_home+20j
		LDR		R0, =aHmenuprocess08 ; "hMenuProcess:%08x\n"
		LDR		R1, [R6,#0xC]
		LDR		R9, =p_plgloader_info_ver_specific
		BL		nsDbgPrint

		MOV		R1, #0
		MOV		R2, #0x238
		ADD		R0, SP,	#0x498+buf
		BL		memset_

		ADD		R7, SP,	#0x498+dst_addr
		MOV		R3, #0x114
		STR		R3, [SP,#0x498+size] ; size
		LDR		R0, =0xFFFF8001	; hDst
		MOV		R1, R7	; dst_addr
		LDR		R2, [R6,#0xC] ;	hSrc
		LDR		R3, [R9,#(plgloader_info - 0x108358)] ;	src_addr
		BL		inter_process_dma_copy

		SUBS		R4, R0,	#0
		LDRNE		R0, =aLoadPlginfoFai ; "load plginfo failed:%08x\n"
		BNE		loc_10388C

		SUB		R1, R7,	#8 ; buf
		MOV		R0, R5	; handle
		BL		sub_1042A4

		LDR		R2, [SP,#0x498+var_490]
		LDR		R0, =aProctid08x08x ; "procTid: %08x%08x\n"
		LDR		R1, [SP,#0x498+var_48C]
		BL		nsDbgPrint

		LDR		R3, [SP,#0x498+var_37C]
		LDR		R2, [SP,#0x498+var_490]
		CMP		R2, R3
		BNE		loc_10371C

		LDR		R3, [SP,#0x498+var_378]
		LDR		R2, [SP,#0x498+var_48C]
		CMP		R2, R3
		BEQ		loc_103728


loc_10371C				; CODE XREF: inject_into_nintendo_home+B4j
		LDR		R0, =aTidMismatch ; "tid mismatch\n"
		BL		nsDbgPrint

		B		loc_103898

; ---------------------------------------------------------------------------

loc_103728				; CODE XREF: inject_into_nintendo_home+C4j
		LDR		R3, [SP,#0x498+dst_addr]
		CMP		R3, #0
		BEQ		loc_10378C


loc_103734				; CODE XREF: inject_into_nintendo_home+144j
		LDR		R3, [SP,#0x498+var_384]
		ADD		R8, SP,	#0x498+var_374
		STR		R3, [R6,#0x10]
		LDR		R3, [SP,#0x498+var_380]
		MOV		R1, R7
		STR		R3, [R6,#0x14]
		LDR		R3, [R6,#0xC]
		MOV		R2, #0x114
		STR		R3, [R9,#(hCurKProcess - 0x108358)]
		LDR		R3, =0x3E9
		MOV		R0, R8
		STR		R3, [SP,#0x498+var_25C]
		LDR		R4, [R9,#(plgloader_info - 0x108358)]
		BL		memcpy

		MOV		R0, #0x114
		BL		round_to_pagesize_

		LDR		R1, [SP,#0x498+dst_addr]
		MOV		R3, #0
		MOV		R1, R1,LSL#2
		MOV		R11, R0
		ADD		R2, R0,	R4
		B		loc_10379C

; ---------------------------------------------------------------------------

loc_10378C				; CODE XREF: inject_into_nintendo_home+DCj
		BL		is_BUTTON_DL_pressed

		CMP		R0, #0
		BEQ		loc_103898

		B		loc_103734

; ---------------------------------------------------------------------------

loc_10379C				; CODE XREF: inject_into_nintendo_home+134j
					; inject_into_nintendo_home+16Cj
		CMP		R3, R1
		BEQ		loc_1037C4

		ADD		R0, R7,	R3
		ADD		R12, R8, R3
		LDR		R0, [R0,#0x84]
		STR		R2, [R12,#4]
		ADD		R11, R11, R0
		ADD		R2, R2,	R0
		ADD		R3, R3,	#4
		B		loc_10379C

; ---------------------------------------------------------------------------

loc_1037C4				; CODE XREF: inject_into_nintendo_home+14Cj
		MOV		R0, R5	; handle
		LDR		R1, [R9,#(plgloader_info - 0x108358)] ;	addr
		MOV		R2, R11	; size
		BL		map_remote_memory

		LDR		R10, =p_plgloader_info_ver_specific
		SUBS		R4, R0,	#0
		LDRNE		R0, =aAllocPluginMem ; "alloc plugin memory failed: %08x\n"
		BNE		loc_10388C

		MOV		R0, R5	; hProcess
		LDR		R1, [R10,#(plgloader_info - 0x108358)] ; addr
		MOV		R2, R11	; size
		BL		rtCheckRemoteMemoryRegionSafeForWrite

		SUBS		R4, R0,	#0
		LDRNE		R0, =aRwxFailed08x ; "rwx failed: %08x\n"
		BNE		loc_10388C

		MOV		R3, #0x114
		STR		R3, [SP,#0x498+size] ; size
		MOV		R0, R5	; hDst
		LDR		R1, [R10,#(plgloader_info - 0x108358)] ; dst_addr
		LDR		R2, =0xFFFF8001	; hSrc
		MOV		R3, R8	; src_addr
		BL		inter_process_dma_copy

		SUBS		R4, R0,	#0
		LDRNE		R0, =aCopyPlginfoFai ; "copy plginfo failed: %08x\n"
		BNE		loc_10388C

		MOV		R9, #1


loc_10382C				; CODE XREF: inject_into_nintendo_home+210j
		LDR		R2, [SP,#0x498+var_374]
		SUB		R3, R9,	#1
		CMP		R3, R2
		BCS		loc_103870

		ADD		R3, R8,	R9,LSL#2
		MOV		R0, R5	; hDst
		LDR		R3, [R3,#0x80]
		STR		R3, [SP,#0x498+size] ; size
		LDR		R1, [R8,R9,LSL#2] ; dst_addr
		LDR		R3, [R7,R9,LSL#2] ; src_addr
		LDR		R2, [R6,#0xC] ;	hSrc
		BL		inter_process_dma_copy

		ADD		R9, R9,	#1
		SUBS		R4, R0,	#0
		BEQ		loc_10382C

		LDR		R0, =aLoadPlgFailed0 ; "load plg failed: %08x\n"
		B		loc_10388C

; ---------------------------------------------------------------------------

loc_103870				; CODE XREF: inject_into_nintendo_home+1E4j
		MOV		R0, R5	; handle
		MOV		R1, #0x100000 ;	addr_jmpcode
		ADD		R2, SP,	#0x498+buf ; buf
		BL		inject_ntr_into_remote_process ; if addr is 0, the hook	will be	placed at
					; process' current PC

		SUBS		R4, R0,	#0
		BEQ		loc_1038A0

		LDR		R0, =aAttachProcessF ; "attach process failed: %08x\n"


loc_10388C				; CODE XREF: inject_into_nintendo_home+3Cj
					; inject_into_nintendo_home+88j ...
		MOV		R1, R4
		BL		nsDbgPrint

		B		loc_1038A0

; ---------------------------------------------------------------------------

loc_103898				; CODE XREF: inject_into_nintendo_home+D0j
					; inject_into_nintendo_home+140j
		MOV		R0, #0xFFFFFFFF
		B		loc_1038A4

; ---------------------------------------------------------------------------

loc_1038A0				; CODE XREF: inject_into_nintendo_home+230j
					; inject_into_nintendo_home+240j
		MOV		R0, R4


loc_1038A4				; CODE XREF: inject_into_nintendo_home+248j
		ADD		SP, SP,	#0x470
		ADD		SP, SP,	#4
		LDMFD		SP!, {R4-R11,PC}

; End of function inject_into_nintendo_home

; ---------------------------------------------------------------------------
off_1038B0	DCD dword_10AB04	; DATA XREF: inject_into_nintendo_home+8r
					; ROM:offsets_starto
off_1038B4	DCD aOpenMenuProces	; DATA XREF: inject_into_nintendo_home+38r
					; ROM:offsets_starto
					; "open menu process failed: %08x\n"
off_1038B8	DCD aHmenuprocess08	; DATA XREF: inject_into_nintendo_home:loc_103694r
					; ROM:offsets_starto
					; "hMenuProcess:%08x\n"
off_1038BC	DCD p_plgloader_info_ver_specific ; DATA XREF: inject_into_nintendo_home+48r
					; inject_into_nintendo_home+180r ...
; unsigned int dword_1038C0
dword_1038C0	DCD 0xFFFF8001		; DATA XREF: inject_into_nintendo_home+6Cr
					; inject_into_nintendo_home+1BCr
off_1038C4	DCD aLoadPlginfoFai	; DATA XREF: inject_into_nintendo_home+84r
					; ROM:offsets_starto
					; "load plginfo failed:%08x\n"
off_1038C8	DCD aProctid08x08x	; DATA XREF: inject_into_nintendo_home+9Cr
					; ROM:offsets_starto
					; "procTid: %08x%08x\n"
off_1038CC	DCD aTidMismatch	; DATA XREF: inject_into_nintendo_home:loc_10371Cr
					; ROM:offsets_starto
					; "tid mismatch\n"
dword_1038D0	DCD 0x3E9		; DATA XREF: inject_into_nintendo_home+104r
off_1038D4	DCD aAllocPluginMem	; DATA XREF: inject_into_nintendo_home+188r
					; ROM:offsets_starto
					; "alloc plugin memory failed: %08x\n"
off_1038D8	DCD aRwxFailed08x	; DATA XREF: inject_into_nintendo_home+1A4r
					; ROM:offsets_starto
					; "rwx failed: %08x\n"
off_1038DC	DCD aCopyPlginfoFai	; DATA XREF: inject_into_nintendo_home+1CCr
					; ROM:offsets_starto
					; "copy plginfo failed: %08x\n"
off_1038E0	DCD aLoadPlgFailed0	; DATA XREF: inject_into_nintendo_home+214r
					; ROM:offsets_starto
					; "load plg failed: %08x\n"
off_1038E4	DCD aAttachProcessF	; DATA XREF: inject_into_nintendo_home+234r
					; ROM:offsets_starto
					; "attach process failed: %08x\n"

; =============== S U B	R O U T	I N E =======================================


callback_inject_into_nintendo_home	; DATA XREF: install_home_injection_hook+14o
					; ROM:off_1039A4o

; FUNCTION CHUNK AT 0010AF80 SIZE 00000040 BYTES

		STMFD		SP!, {R4-R6,LR}
		MOV		R5, R0
		MOV		R4, R1
		BL		inject_into_nintendo_home

		MOV		R0, R5
		MOV		R1, R4
		LDR		R3, =loc_10AF80
		LDMFD		SP!, {R4-R6,LR}
		BX		R3 ; loc_10AF80

; End of function callback_inject_into_nintendo_home

; ---------------------------------------------------------------------------
off_10390C	DCD loc_10AF80		; DATA XREF: callback_inject_into_nintendo_home+18r
					; ROM:offsets_starto
; ---------------------------------------------------------------------------
		STMFD		SP!, {R4-R8,LR}
		MOV		R4, R2
		MOV		R5, R3
		LDR		R3, [R2]
		LDR		R2, =dword_10AB04
		LDR		R8, [SP,#0x18]
		MOV		R7, R0
		STR		R3, [R2,#(dword_10AB1C - 0x10AB04)]
		LDR		R3, [R4,#4]
		MOV		R6, R1
		STR		R3, [R2,#(dword_10AB20 - 0x10AB04)]
		LDR		R0, =aRunappletTid00 ; "runApplet tid0: %08x, tid1: %08x\n"
		LDMIA		R4, {R1,R2}
		BL		nsDbgPrint

		STR		R8, [SP,#0x18]
		MOV		R0, R7
		MOV		R1, R6
		MOV		R2, R4
		MOV		R3, R5
		LDR		R12, =loc_10ABB0
		LDMFD		SP!, {R4-R8,LR}
		BX		R12 ; loc_10ABB0

; ---------------------------------------------------------------------------
off_103968	DCD dword_10AB04	; DATA XREF: ROM:00103920r
					; ROM:offsets_starto
off_10396C	DCD aRunappletTid00	; DATA XREF: ROM:0010393Cr
					; ROM:offsets_starto
					; "runApplet tid0: %08x, tid1: %08x\n"
off_103970	DCD loc_10ABB0		; DATA XREF: ROM:0010395Cr
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


install_home_injection_hook		; CODE XREF: install_ntr+244p
		LDR		R3, =process_manager_patch_addr
		STMFD		SP!, {R4,LR}
		LDR		R4, =rthook_home_injection
		LDR		R1, [R3] ; funcaddr
		MOV		R0, R4	; hook
		LDR		R2, =callback_inject_into_nintendo_home	; callback_addr
		BL		rtInitHook

		MOV		R0, R4	; rthook
		LDMFD		SP!, {R4,LR}
		B		rtEnableHook

; End of function install_home_injection_hook

; ---------------------------------------------------------------------------
off_10399C	DCD process_manager_patch_addr ; DATA XREF: install_home_injection_hookr
					; ROM:offsets_starto
; RT_HOOK *off_1039A0
off_1039A0	DCD rthook_home_injection ; DATA XREF: install_home_injection_hook+8r
					; ROM:offsets_starto
; void *off_1039A4
off_1039A4	DCD callback_inject_into_nintendo_home
					; DATA XREF: install_home_injection_hook+14r
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


find_files_				; CODE XREF: load_ntr_plugins+28p

var_498		= -0x498
var_484		= -0x484
var_480		= -0x480
var_47C		= -0x47C
var_478		= -0x478
var_474		= -0x474
var_470		= -0x470

		STMFD		SP!, {R4-R9,LR}
		SUB		SP, SP,	#0x480
		SUB		SP, SP,	#0xC
		MOV		R3, #3
		MOV		R7, R0
		MOV		R0, R2	; a1
		MOV		R4, R2
		MOV		R6, R1
		STRB		R3, [SP,#0x4A8+var_47C]
		BL		strlen_

		ADD		R5, SP,	#0x4A8+var_470
		STR		R4, [SP,#0x4A8+var_474]
		LDR		R12, =some_filename_
		ADD		R3, SP,	#0x4A8+var_498
		ADD		R0, R0,	#1
		STR		R0, [SP,#0x4A8+var_478]
		LDMDB		R5, {R0-R2}
		STMIA		R3, {R0-R2}
		ADD		R3, R12, #8
		LDMIA		R3, {R0-R3}
		STMEA		SP, {R0-R3}
		LDR		R1, =hFSUser
		LDMIA		R12, {R2,R3}
		LDR		R0, [R1]
		ADD		R1, SP,	#0x4A8+var_484
		BL		FSUSER_OpenDirectory_

		SUBS		R1, R0,	#0
		MOVEQ		R4, R1
		MOVEQ		R8, R4
		MOVEQ		R9, R4
		BEQ		loc_103A60

		LDR		R0, =aFsuser_opendir ; "FSUSER_OpenDirectory failed, ret=%08x"
		BL		nsDbgPrint

		MOV		R0, #0
		B		loc_103A9C

; ---------------------------------------------------------------------------

loc_103A34				; CODE XREF: find_files_+A8j
		ADD		R3, R3,	#2
		CMP		R3, #0x450
		STRB		R2, [R6,R8]
		ADD		R8, R8,	#1
		BEQ		loc_103A54


loc_103A48				; CODE XREF: find_files_+E4j
		LDRH		R2, [R5,R3]
		CMP		R2, #0
		BNE		loc_103A34


loc_103A54				; CODE XREF: find_files_+9Cj
		STRB		R9, [R6,R8]
		ADD		R4, R4,	#1
		ADD		R8, R8,	#1


loc_103A60				; CODE XREF: find_files_+78j
		MOV		R3, R5
		LDR		R0, [SP,#0x4A8+var_484]
		ADD		R1, SP,	#0x4A8+var_480
		MOV		R2, #1
		STR		R9, [SP,#0x4A8+var_480]
		BL		sub_100B14

		LDR		R3, [SP,#0x4A8+var_480]
		CMP		R3, #0
		ADDNE		R3, R6,	R8
		STRNE		R3, [R7,R4,LSL#2]
		MOVNE		R3, #0
		BNE		loc_103A48

		LDR		R0, [SP,#0x4A8+var_484]
		BL		sub_100B78

		MOV		R0, R4


loc_103A9C				; CODE XREF: find_files_+88j
		ADD		SP, SP,	#0x480
		ADD		SP, SP,	#0xC
		LDMFD		SP!, {R4-R9,PC}

; End of function find_files_

; ---------------------------------------------------------------------------
off_103AA8	DCD some_filename_	; DATA XREF: find_files_+30r
					; ROM:offsets_starto
off_103AAC	DCD hFSUser		; DATA XREF: find_files_+54r
					; ROM:offsets_starto
off_103AB0	DCD aFsuser_opendir	; DATA XREF: find_files_+7Cr
					; ROM:offsets_starto
					; "FSUSER_OpenDirectory failed, ret=%08x"

; =============== S U B	R O U T	I N E =======================================


update_plginfo_with_arm11_addresses	; CODE XREF: callback_applet_start+24p
					; load_all_plugins_and_inject_ntr_into_pm+10Cp	...
		LDR		R3, =p_plgloader_info
		MOV		R2, #0
		LDR		R3, [R3]
		STR		R2, [R3]
		LDR		R2, =arm11BinEnd
		LDR		R1, [R2]
		LDR		R2, =arm11BinEnd2
		STR		R1, [R2]
		LDR		R2, =dword_10AB04
		LDR		R1, [R2,#(arm11BinStart	- 0x10AB04)]
		LDR		R2, [R2,#(arm11BinSize - 0x10AB04)]
		STR		R1, [R3,#0x104]
		STR		R2, [R3,#0x108]
		BX		LR

; End of function update_plginfo_with_arm11_addresses

; ---------------------------------------------------------------------------
off_103AEC	DCD p_plgloader_info	; DATA XREF: update_plginfo_with_arm11_addressesr
					; ROM:offsets_starto
off_103AF0	DCD arm11BinEnd		; DATA XREF: update_plginfo_with_arm11_addresses+10r
					; ROM:offsets_starto
off_103AF4	DCD arm11BinEnd2	; DATA XREF: update_plginfo_with_arm11_addresses+18r
					; ROM:offsets_starto
off_103AF8	DCD dword_10AB04	; DATA XREF: update_plginfo_with_arm11_addresses+20r
					; ROM:offsets_starto
; ---------------------------------------------------------------------------
		BX		LR


; =============== S U B	R O U T	I N E =======================================


load_ntr_plugins			; CODE XREF: callback_applet_start+2Cp
					; callback_applet_start+48p ...

var_11A8	= -0x11A8
var_10E0	= -0x10E0
var_1018	= -0x1018

		STMFD		SP!, {R4-R7,LR}
		SUB		SP, SP,	#0x1200
		SUB		SP, SP,	#0x14
		MOV		R2, R0
		LDR		R1, =aPluginS ;	"/plugin/%s"
		ADD		R0, SP,	#0x1228+var_11A8
		BL		xsprintf

		MOV		R0, SP
		ADD		R1, SP,	#0x1228+var_1018
		ADD		R2, SP,	#0x1228+var_11A8
		BL		find_files_

		LDR		R6, =arm11BinEnd2
		MOV		R5, #0
		MOV		R7, R0


loc_103B38				; CODE XREF: load_ntr_plugins+E4j
		CMP		R5, R7
		BEQ		loc_103BE8

		LDR		R1, =aSS_0 ; "%s/%s"
		ADD		R2, SP,	#0x1228+var_11A8
		LDR		R3, [SP,R5,LSL#2]
		ADD		R0, SP,	#0x1228+var_10E0
		BL		xsprintf

		ADD		R0, SP,	#0x1228+var_10E0
		BL		get_file_size

		BL		round_to_pagesize_

		ADD		R1, SP,	#0x1228+var_10E0
		LDR		R3, [R6]
		MOV		R4, R0
		MOV		R2, R4
		LDR		R0, =aLoadingPluginS ; "loading plugin: %s, size: %08x, addr: %"...
		BL		nsDbgPrint

		LDR		R0, [R6]
		ADD		R0, R4,	R0
		BL		alloc_plugin_memory

		CMP		R0, #0
		LDRNE		R0, =aAllocPluginM_0 ; "alloc plugin memory failed\n"
		BNE		loc_103BAC

		ADD		R0, SP,	#0x1228+var_10E0
		LDR		R1, [R6]
		MOV		R2, R4
		BL		rtLoadFileToBuffer

		CMP		R0, #0
		BNE		loc_103BB4

		LDR		R0, =aRtloadfiletobu ; "rtLoadFileToBuffer failed\n"


loc_103BAC				; CODE XREF: load_ntr_plugins+8Cj
		BL		nsDbgPrint

		B		loc_103BE0

; ---------------------------------------------------------------------------

loc_103BB4				; CODE XREF: load_ntr_plugins+A4j
		LDR		R3, =p_plgloader_info
		LDR		R1, [R6]
		LDR		R2, [R3]
		LDR		R3, [R2]
		ADD		R0, R2,	R3,LSL#2
		ADD		R3, R3,	#1
		STR		R4, [R0,#0x84]
		ADD		R4, R4,	R1
		STR		R1, [R0,#4]
		STR		R3, [R2]
		STR		R4, [R6]


loc_103BE0				; CODE XREF: load_ntr_plugins+B0j
		ADD		R5, R5,	#1
		B		loc_103B38

; ---------------------------------------------------------------------------

loc_103BE8				; CODE XREF: load_ntr_plugins+3Cj
		MOV		R0, R5
		ADD		SP, SP,	#0x1200
		ADD		SP, SP,	#0x14
		LDMFD		SP!, {R4-R7,PC}

; End of function load_ntr_plugins

; ---------------------------------------------------------------------------
off_103BF8	DCD aPluginS		; DATA XREF: load_ntr_plugins+10r
					; ROM:offsets_starto
					; "/plugin/%s"
off_103BFC	DCD arm11BinEnd2	; DATA XREF: load_ntr_plugins+2Cr
					; ROM:offsets_starto
off_103C00	DCD aSS_0		; DATA XREF: load_ntr_plugins+40r
					; ROM:offsets_starto
					; "%s/%s"
off_103C04	DCD aLoadingPluginS	; DATA XREF: load_ntr_plugins+70r
					; ROM:offsets_starto
					; "loading plugin: %s, size: %08x, addr: %"...
off_103C08	DCD aAllocPluginM_0	; DATA XREF: load_ntr_plugins+88r
					; ROM:offsets_starto
					; "alloc plugin memory failed\n"
off_103C0C	DCD aRtloadfiletobu	; DATA XREF: load_ntr_plugins+A8r
					; ROM:offsets_starto
					; "rtLoadFileToBuffer failed\n"
off_103C10	DCD p_plgloader_info	; DATA XREF: load_ntr_plugins:loc_103BB4r
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================

; maps game plugins into process

callback_applet_start			; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+134o
					; ROM:off_103F54o
		STMFD		SP!, {R4-R6,LR}
		MOV		R4, R0
		SUB		SP, SP,	#0x20
		MOV		R6, R1
		MOV		R5, R2
		LDR		R1, [R4,#4]
		LDR		R2, [R4]
		LDR		R0, =aStartingApplet ; "starting applet: %08x%08x\n"
		BL		nsDbgPrint

		BL		update_plginfo_with_arm11_addresses

		LDR		R0, =aGame ; "game"
		BL		load_ntr_plugins

		LDR		R2, [R4,#4]
		LDR		R3, [R4]
		MOV		R0, SP
		LDR		R1, =a08x08x ; "%08x%08x"
		BL		xsprintf

		MOV		R0, SP
		BL		load_ntr_plugins

		LDR		R3, =p_plgloader_info
		LDR		R2, [R4]
		MOV		R0, R4
		LDR		R3, [R3]
		MOV		R1, R6
		STR		R2, [R3,#0x10C]
		LDR		R2, [R4,#4]
		STR		R2, [R3,#0x110]
		MOV		R2, R5
		LDR		R3, =rthook_applet_start.callCode
		BLX		R3

		ADD		SP, SP,	#0x20
		LDMFD		SP!, {R4-R6,PC}

; End of function callback_applet_start

; ---------------------------------------------------------------------------
off_103C94	DCD aStartingApplet	; DATA XREF: callback_applet_start+1Cr
					; ROM:offsets_starto
					; "starting applet: %08x%08x\n"
off_103C98	DCD aGame		; DATA XREF: callback_applet_start+28r
					; ROM:offsets_starto
					; "game"
off_103C9C	DCD a08x08x		; DATA XREF: callback_applet_start+3Cr
					; ROM:offsets_starto
					; "%08x%08x"
off_103CA0	DCD p_plgloader_info	; DATA XREF: callback_applet_start+4Cr
					; ROM:offsets_starto
off_103CA4	DCD rthook_applet_start.callCode ; DATA	XREF: callback_applet_start+70r
					; ROM:offsets_starto

; =============== S U B	R O U T	I N E =======================================


inject_ntr_into_process_manager		; CODE XREF: load_all_plugins_and_inject_ntr_into_pm+14Cp

handle		= -0x244
buf		= -0x240
var_23C		= -0x23C

		LDR		R3, =process_manager_patch_addr
		STMFD		SP!, {R4,LR}
		SUB		SP, SP,	#0x240
		MOV		R1, #0
		MOV		R2, #0x238
		ADD		R0, SP,	#0x248+buf
		LDR		R4, [R3]
		BL		memset_

		MOV		R3, #0x3E8
		MOV		R1, #2	; pid 2
		ADD		R0, SP,	#0x248+handle
		STR		R3, [SP,#0x248+var_23C]
		BL		OpenProcess

		SUBS		R1, R0,	#0
		BEQ		loc_103CFC

		LDR		R0, =aOpenprocessF_0 ; "openProcess failed: %08x\n"
		MOV		R2, #0
		BL		nsDbgPrint

		MOV		R3, #0
		STR		R3, [SP,#0x248+handle]
		B		loc_103D0C

; ---------------------------------------------------------------------------

loc_103CFC				; CODE XREF: inject_ntr_into_process_manager+38j
		LDR		R0, [SP,#0x248+handle] ; handle
		MOV		R1, R4	; addr_jmpcode
		ADD		R2, SP,	#0x248+buf ; buf
		BL		inject_ntr_into_remote_process ; if addr is 0, the hook	will be	placed at
					; process' current PC


loc_103D0C				; CODE XREF: inject_ntr_into_process_manager+50j
		LDR		R0, [SP,#0x248+handle]
		CMP		R0, #0
		BEQ		loc_103D1C

		BL		CloseHandle


loc_103D1C				; CODE XREF: inject_ntr_into_process_manager+6Cj
		ADD		SP, SP,	#0x240
		LDMFD		SP!, {R4,PC}

; End of function inject_ntr_into_process_manager

; ---------------------------------------------------------------------------
off_103D24	DCD process_manager_patch_addr ; DATA XREF: inject_ntr_into_process_managerr
					; ROM:offsets_starto
off_103D28	DCD aOpenprocessF_0	; DATA XREF: inject_ntr_into_process_manager+3Cr
					; ROM:offsets_starto
					; "openProcess failed: %08x\n"

; =============== S U B	R O U T	I N E =======================================


init_all_plugins_0			; CODE XREF: load_all_plugins_and_inject_ntr_into_pm+118p
		STMFD		SP!, {R4-R6,LR}
		LDR		R3, =arm11BinEnd2
		LDR		R5, =arm11BinEnd
		LDR		R3, [R3]
		LDR		R4, [R5]
		RSB		R4, R4,	R3
		BL		get_current_process_handle

		LDR		R1, [R5] ; addr
		MOV		R2, R4	; size
		BL		rtCheckRemoteMemoryRegionSafeForWrite

		SUBS		R1, R0,	#0
		MOVEQ		R4, R1
		LDREQ		R5, =p_plgloader_info
		BEQ		loc_103D70

		LDR		R0, =aRwxFailed08x ; "rwx failed: %08x\n"
		LDMFD		SP!, {R4-R6,LR}
		B		nsDbgPrint

; ---------------------------------------------------------------------------

loc_103D70				; CODE XREF: init_all_plugins_0+34j
					; init_all_plugins_0+7Cj
		LDR		R3, [R5]
		LDR		R2, [R3]
		CMP		R4, R2
		BCS		locret_103DAC

		MOV		R6, R4,LSL#2
		ADD		R3, R3,	R6
		LDR		R0, =aPlg08x ; "plg: %08x\n"
		LDR		R1, [R3,#4]
		BL		nsDbgPrint

		LDR		R3, [R5]
		ADD		R4, R4,	#1
		ADD		R3, R3,	R6
		LDR		R3, [R3,#4]
		BLX		R3

		B		loc_103D70

; ---------------------------------------------------------------------------

locret_103DAC				; CODE XREF: init_all_plugins_0+50j
		LDMFD		SP!, {R4-R6,PC}

; End of function init_all_plugins_0

; ---------------------------------------------------------------------------
off_103DB0	DCD arm11BinEnd2	; DATA XREF: init_all_plugins_0+4r
					; ROM:offsets_starto
off_103DB4	DCD arm11BinEnd		; DATA XREF: init_all_plugins_0+8r
					; ROM:offsets_starto
off_103DB8	DCD p_plgloader_info	; DATA XREF: init_all_plugins_0+30r
					; ROM:offsets_starto
off_103DBC	DCD aRwxFailed08x	; DATA XREF: init_all_plugins_0+38r
					; ROM:offsets_starto
					; "rwx failed: %08x\n"
off_103DC0	DCD aPlg08x		; DATA XREF: init_all_plugins_0+5Cr
					; ROM:00108C28o
					; "plg: %08x\n"

; =============== S U B	R O U T	I N E =======================================


load_all_plugins_and_inject_ntr_into_pm	; CODE XREF: thread_NTR_home_injectee+CCp
		STMFD		SP!, {R3-R7,LR}
		LDR		R3, =p_plgloader_info_ver_specific
		LDR		R5, =some_filename_
		LDR		R4, [R3,#(plgloader_info - 0x108358)]
		BL		initSharedFunc

		MOV		R1, #0
		MOV		R2, #0x18
		MOV		R0, R5
		BL		memset_

		MOV		R3, #9
		STR		R3, [R5]
		MOV		R3, #1
		STRB		R3, [R5,#(byte_10AFC4 -	0x10AFC0)]
		STR		R3, [R5,#(dword_10AFC8 - 0x10AFC0)]
		LDR		R3, =(aWillListenAtPortD+0x18)
		MOV		R1, R5
		STR		R3, [R5,#(dword_10AFCC - 0x10AFC0)]
		LDR		R3, =hFSUser
		LDR		R0, [R3]
		BL		FSUSER_OpenArchive_

		SUBS		R1, R0,	#0
		BEQ		loc_103E28

		LDR		R0, =aFsuser_openarc ; "FSUSER_OpenArchive failed: %08x\n"
		LDMFD		SP!, {R3-R7,LR}
		B		nsDbgPrint

; ---------------------------------------------------------------------------

loc_103E28				; CODE XREF: load_all_plugins_and_inject_ntr_into_pm+54j
		LDR		R6, =p_plgloader_info
		MOV		R0, #0x114
		LDR		R5, =dword_10AB04
		STR		R4, [R6]
		BL		round_to_pagesize_

		ADD		R4, R0,	R4
		LDR		R0, =aNtr_bin ;	"/ntr.bin"
		BL		get_file_size

		BL		round_to_pagesize_

		MOV		R1, R0
		STR		R0, [R5,#(arm11BinSize - 0x10AB04)]
		LDR		R0, =aArm11BinSize08 ; "arm11 bin size: %08x\n"
		BL		nsDbgPrint

		LDR		R0, [R5,#(arm11BinSize - 0x10AB04)]
		ADD		R0, R4,	R0
		BL		alloc_plugin_memory

		CMP		R0, #0
		BEQ		loc_103E78

		LDR		R0, =aAllocMemoryFor ; "alloc memory for arm11bin failed\n"
		BL		nsDbgPrint


loc_103E78				; CODE XREF: load_all_plugins_and_inject_ntr_into_pm+A8j
		LDR		R0, =aNtr_bin ;	"/ntr.bin"
		MOV		R1, R4
		LDR		R2, [R5,#0x14] ; arm11 binsize
		BL		rtLoadFileToBuffer

		LDR		R7, =dword_10AB04
		CMP		R0, #0
		BNE		loc_103EA0

		LDR		R0, =aLoadArm11binFa ; "load arm11bin failed\n"
		LDMFD		SP!, {R3-R7,LR}
		B		nsDbgPrint

; ---------------------------------------------------------------------------

loc_103EA0				; CODE XREF: load_all_plugins_and_inject_ntr_into_pm+CCj
		LDR		R3, [R7,#(arm11BinSize - 0x10AB04)]
		STR		R4, [R7,#(arm11BinStart	- 0x10AB04)]
		CMP		R3, #0x20 ; ' '
		ADD		R5, R4,	R3
		MOVHI		R3, #1
		STRHI		R3, [R4,#4]
		LDR		R4, =arm11BinEnd
		MOV		R1, #0
		MOV		R2, #0x114
		LDR		R0, [R6]
		BL		memset_

		STR		R5, [R4]
		BL		update_plginfo_with_arm11_addresses

		LDR		R0, =aHome ; "home"
		BL		load_ntr_plugins

		BL		init_all_plugins_0

		LDR		R3, =arm11BinEnd2
		LDR		R3, [R3]
		STR		R3, [R4]
		BL		update_plginfo_with_arm11_addresses

		LDR		R3, =nintendo_home_applet_start_hook_addr
		LDR		R0, =rthook_applet_start ; hook
		LDR		R2, =callback_applet_start ; callback_addr
		LDR		R1, [R3] ; funcaddr
		BL		rtInitHook

		LDR		R0, =rthook_applet_start ; rthook
		BL		rtEnableHook

		LDMFD		SP!, {R3-R7,LR}
		B		inject_ntr_into_process_manager

; End of function load_all_plugins_and_inject_ntr_into_pm

; ---------------------------------------------------------------------------
off_103F14	DCD p_plgloader_info_ver_specific
					; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+4r
					; ROM:00108C30o
off_103F18	DCD some_filename_	; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+8r
					; ROM:00108C38o
off_103F1C	DCD aWillListenAtPortD+0x18
					; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+38r
					; ROM:00108C40o
off_103F20	DCD hFSUser		; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+44r
					; ROM:00108C48o
off_103F24	DCD aFsuser_openarc	; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+58r
					; ROM:00108C50o
					; "FSUSER_OpenArchive failed: %08x\n"
off_103F28	DCD p_plgloader_info	; DATA XREF: load_all_plugins_and_inject_ntr_into_pm:loc_103E28r
					; ROM:00108C58o
off_103F2C	DCD dword_10AB04	; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+6Cr
					; load_all_plugins_and_inject_ntr_into_pm+C4r ...
off_103F30	DCD aNtr_bin		; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+7Cr
					; load_all_plugins_and_inject_ntr_into_pm:loc_103E78r ...
					; "/ntr.bin"
off_103F34	DCD aArm11BinSize08	; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+90r
					; ROM:00108C70o
					; "arm11 bin size: %08x\n"
off_103F38	DCD aAllocMemoryFor	; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+ACr
					; ROM:00108C78o
					; "alloc memory for arm11bin failed\n"
off_103F3C	DCD aLoadArm11binFa	; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+D0r
					; ROM:00108C80o
					; "load arm11bin failed\n"
off_103F40	DCD arm11BinEnd		; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+F4r
					; ROM:00108C88o
off_103F44	DCD aHome		; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+110r
					; ROM:00108C90o
					; "home"
off_103F48	DCD arm11BinEnd2	; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+11Cr
					; ROM:00108C98o
off_103F4C	DCD nintendo_home_applet_start_hook_addr
					; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+12Cr
					; ROM:00108CA0o
; RT_HOOK *off_103F50
off_103F50	DCD rthook_applet_start	; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+130r
					; load_all_plugins_and_inject_ntr_into_pm+140r	...
; void *off_103F54
off_103F54	DCD callback_applet_start
					; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+134r
					; ROM:00108CB0o
					; maps game plugins into process

; =============== S U B	R O U T	I N E =======================================


init_all_plugins			; CODE XREF: install_ntr+26Cp
		STMFD		SP!, {R3-R7,LR}
		BL		initSharedFunc

		LDR		R3, =p_plgloader_info_ver_specific
		LDR		R4, =p_plgloader_info
		MOV		R5, #0
		LDR		R3, [R3,#(plgloader_info - 0x108358)]
		MOV		R7, R4
		STR		R3, [R4]


loc_103F78				; CODE XREF: init_all_plugins+58j
		LDR		R3, [R4]
		LDR		R2, [R3,#PLGLOADER_INFO]
		CMP		R5, R2
		BCS		locret_103FB4

		MOV		R6, R5,LSL#2
		ADD		R3, R3,	R6
		LDR		R0, =aPlg08x ; "plg: %08x\n"
		LDR		R1, [R3,#PLGLOADER_INFO.plgBufferPtr]
		BL		nsDbgPrint

		LDR		R3, [R7]
		ADD		R5, R5,	#1
		ADD		R3, R3,	R6
		LDR		R3, [R3,#PLGLOADER_INFO.plgBufferPtr]
		BLX		R3

		B		loc_103F78

; ---------------------------------------------------------------------------

locret_103FB4				; CODE XREF: init_all_plugins+2Cj
		LDMFD		SP!, {R3-R7,PC}

; End of function init_all_plugins

; ---------------------------------------------------------------------------
off_103FB8	DCD p_plgloader_info_ver_specific ; DATA XREF: init_all_plugins+8r
					; ROM:00108CB8o
off_103FBC	DCD p_plgloader_info	; DATA XREF: init_all_plugins+Cr
					; ROM:00108CC0o
off_103FC0	DCD aPlg08x		; DATA XREF: init_all_plugins+38r
					; ROM:00108CC8o
					; "plg: %08x\n"
; ---------------------------------------------------------------------------
		BX		LR


; =============== S U B	R O U T	I N E =======================================


get_current_process_id			; CODE XREF: install_ntr+198p
					; setup_ntr_network_server+110p
		STMFD		SP!, {R4,LR}
		LDR		R4, =cur_pid
		LDR		R1, =0xFFFF8001
		MOV		R0, R4
		BL		GetProcessId

		LDR		R0, [R4]
		LDMFD		SP!, {R4,PC}

; End of function get_current_process_id

; ---------------------------------------------------------------------------
off_103FE4	DCD cur_pid		; DATA XREF: get_current_process_id+4r
					; ROM:00108CD0o
dword_103FE8	DCD 0xFFFF8001		; DATA XREF: get_current_process_id+8r

; =============== S U B	R O U T	I N E =======================================


get_current_process_handle		; CODE XREF: init_breakpoint_+18p
					; handle_writemem_packet+24p ...

hProcess	= -0x14

		STMFD		SP!, {R0-R2,R4,R5,LR}
		MOV		R3, #0
		LDR		R5, =cur_pid
		STR		R3, [SP,#0x18+hProcess]
		LDR		R4, [R5,#(hProcess - 0x10B0AC)]
		CMP		R4, R3
		BNE		loc_10403C

		LDR		R1, =0xFFFF8001
		MOV		R0, R5
		BL		GetProcessId

		LDR		R1, [R5]
		ADD		R0, SP,	#0x18+hProcess
		BL		OpenProcess

		SUBS		R1, R0,	#0
		LDREQ		R4, [SP,#0x18+hProcess]
		STREQ		R4, [R5,#(hProcess - 0x10B0AC)]
		BEQ		loc_10403C

		LDR		R0, =aOpenprocessF_2 ; "openProcess failed, ret: %08x"
		MOV		R2, R4
		BL		showDbg


loc_10403C				; CODE XREF: get_current_process_handle+18j
					; get_current_process_handle+40j
		MOV		R0, R4
		ADD		SP, SP,	#0xC
		LDMFD		SP!, {R4,R5,PC}

; End of function get_current_process_handle

; ---------------------------------------------------------------------------
off_104048	DCD cur_pid		; DATA XREF: get_current_process_handle+8r
					; ROM:00108CD8o
dword_10404C	DCD 0xFFFF8001		; DATA XREF: get_current_process_handle+1Cr
off_104050	DCD aOpenprocessF_2	; DATA XREF: get_current_process_handle+44r
					; ROM:00108CE0o
					; "openProcess failed, ret: %08x"
; ---------------------------------------------------------------------------
		B		arm11k_get_current_kprocess


; =============== S U B	R O U T	I N E =======================================


; int __cdecl map_remote_memory(unsigned int handle, unsigned int addr,	unsigned int size)
map_remote_memory			; CODE XREF: inject_ntr_into_remote_process+58p
					; inject_into_nintendo_home+17Cp

var_24		= -0x24
var_20		= -0x20

		STMFD		SP!, {R4-R9,LR}
		SUB		SP, SP,	#0x14 ;	operation
		ADD		R5, SP,	#0x30+var_20
		MOV		R6, #0
		MOV		R4, R1
		MOV		R8, R2
		STR		R6, [R5,#-4]!
		BL		arm11k_get_kernel_object ; r0 =	handle
					; returns ptr to kernel	object

		MOV		R9, R0
		BL		arm11k_get_current_kprocess

		MOV		R7, R0
		MOV		R0, R9
		BL		arm11k_set_current_kprocess

		LDR		R2, =0x203
		MOV		R3, #3
		MOV		R0, R5	; outaddr
		STMEA		SP, {R2,R3}
		MOV		R1, R4	; addr0
		MOV		R2, R4	; addr1
		MOV		R3, R8	; size
		BL		ControlMemory

		MOV		R5, R0
		MOV		R0, R7
		BL		arm11k_set_current_kprocess

		CMP		R5, R6
		LDRNE		R0, =aSvc_controlmem ; "svc_controlMemory failed: %08x"
		MOVNE		R1, R5
		MOVNE		R2, R6
		BNE		loc_1040E0

		LDR		R1, [SP,#0x30+var_24]
		CMP		R1, R4
		BEQ		loc_1040E4

		LDR		R0, =aOutaddr08xAddr ; "outAddr: %08x, addr: %08x"
		MOV		R2, R4


loc_1040E0				; CODE XREF: map_remote_memory+70j
		BL		showDbg


loc_1040E4				; CODE XREF: map_remote_memory+7Cj
		MOV		R0, R5
		ADD		SP, SP,	#0x14
		LDMFD		SP!, {R4-R9,PC}

; End of function map_remote_memory

; ---------------------------------------------------------------------------
dword_1040F0	DCD 0x203		; DATA XREF: map_remote_memory+34r
off_1040F4	DCD aSvc_controlmem	; DATA XREF: map_remote_memory+64r
					; ROM:00108CE8o
					; "svc_controlMemory failed: %08x"
off_1040F8	DCD aOutaddr08xAddr	; DATA XREF: map_remote_memory+80r
					; "outAddr: %08x, addr: %08x"

; =============== S U B	R O U T	I N E =======================================

; assigns RWX to addr :	addr+size

; int __fastcall protectRemoteMemory(unsigned int hKProcess, unsigned int addr,	unsigned int size)
protectRemoteMemory			; CODE XREF: handle_memlayout_packet+60p
					; inject_ntr_into_remote_process+7Cp ...

var_4		= -4

		STMFD		SP!, {R0-R2,LR}	; Type
		MOV		R3, R2	; Size
		MOV		R12, #7	; permissions
		MOV		R2, #6	; type
		STMEA		SP, {R2,R12}
		MOV		R2, R1	; Addr1
		BL		ControlProcessMemory

		ADD		SP, SP,	#0xC
		LDR		PC, [SP+4+var_4],#4

; End of function protectRemoteMemory


; =============== S U B	R O U T	I N E =======================================

; assigns RWX to addr :	addr+size

; int __cdecl protectMemory(unsigned int addr, unsigned	int size)
protectMemory				; CODE XREF: prepare_config_mem+1Cp
					; handle_reload_packet+130p ...
		STMFD		SP!, {R3-R5,LR}
		MOV		R4, R1
		MOV		R5, R0
		BL		get_current_process_handle

		MOV		R1, R5	; addr
		MOV		R2, R4	; size
		LDMFD		SP!, {R3-R5,LR}
		B		protectRemoteMemory ; assigns RWX to addr : addr+size

; End of function protectMemory


; =============== S U B	R O U T	I N E =======================================


; int __fastcall inter_process_dma_copy(unsigned int hDst, void	*dst_addr, unsigned int	hSrc, const void *src_addr, unsigned int size)
inter_process_dma_copy			; CODE XREF: get_nintendo_home_version_info+3Cp
					; handle_writemem_packet+118p ...

src		= -0x88
hdma		= -0x78
var_74		= -0x74
config		= -0x70
size		=  0

		STMFD		SP!, {R4-R10,LR}
		SUB		SP, SP,	#0x68
		ADD		R9, SP,	#0x88+config
		LDR		R5, [SP,#0x88+size]
		MOV		R10, R3
		MOV		R8, R2
		MOV		R7, R0
		MOV		R2, #0x50 ; 'P'
		MOV		R6, R1
		MOV		R0, R9
		MOV		R1, #0
		BL		memset_

		MOV		R3, #0
		MOV		R0, R8
		MOV		R1, R10
		MOV		R2, R5
		STR		R3, [SP,#0x88+hdma]
		BL		FlushProcessDataCache

		SUBS		R4, R0,	#0
		LDRNE		R0, =aSvc_flushproce ; "svc_flushProcessDataCache(hSrc) failed."...
		BNE		loc_1041B0

		MOV		R0, R7
		MOV		R1, R6
		MOV		R2, R5
		BL		FlushProcessDataCache

		SUBS		R4, R0,	#0
		BEQ		loc_1041BC

		LDR		R0, =aSvc_flushpro_0 ; "svc_flushProcessDataCache(hDst) failed."...


loc_1041B0				; CODE XREF: inter_process_dma_copy+50j
		BL		nsDbgPrint

		MOV		R0, R4
		B		loc_10427C

; ---------------------------------------------------------------------------

loc_1041BC				; CODE XREF: inter_process_dma_copy+68j
		STR		R10, [SP,#0x88+src] ; src
		STMFA		SP, {R5,R9}
		ADD		R0, SP,	#0x88+hdma ; hdma
		MOV		R1, R7	; hdstProcess
		MOV		R2, R6	; dst
		MOV		R3, R8	; hsrcProcess
		BL		StartInterProcessDma

		CMP		R0, #0
		BNE		loc_10427C

		LDR		R4, =0x2710
		LDR		R8, =0xFFF04504
		LDR		R9, =0xFFF54204


loc_1041EC				; CODE XREF: inter_process_dma_copy+108j
		MOV		R3, #0
		ADD		R0, SP,	#0x88+var_74
		LDR		R1, [SP,#0x88+hdma]
		STR		R3, [SP,#0x88+var_74]
		BL		GetDmaState

		LDR		R3, [SP,#0x88+var_74]
		UXTB		R2, R3
		CMP		R2, #4
		BNE		loc_104238

		CMP		R3, R9
		CMPNE		R3, R8
		LDR		R1, =0xFFF04204
		MOVEQ		R2, #1
		MOVNE		R2, #0
		CMP		R3, R1
		MOVNE		R3, R2
		ORREQ		R3, R2,	#1
		CMP		R3, #0
		BNE		loc_104264


loc_104238				; CODE XREF: inter_process_dma_copy+CCj
		LDR		R0, =0xF4240
		MOV		R1, #0
		BL		SleepThread

		SUBS		R4, R4,	#1
		BNE		loc_1041EC

		LDR		R0, =aReadremotememo ; "readRemoteMemory time out %08x"
		LDR		R1, [SP,#0x88+var_74]
		MOV		R2, R4
		BL		showDbg

		MOV		R0, #1
		B		loc_10427C

; ---------------------------------------------------------------------------

loc_104264				; CODE XREF: inter_process_dma_copy+F4j
		LDR		R0, [SP,#0x88+hdma]
		BL		CloseHandle

		MOV		R0, R7
		MOV		R1, R6
		MOV		R2, R5
		BL		InvalidateProcessDataCache


loc_10427C				; CODE XREF: inter_process_dma_copy+78j
					; inter_process_dma_copy+9Cj ...
		ADD		SP, SP,	#0x68
		LDMFD		SP!, {R4-R10,PC}

; End of function inter_process_dma_copy

; ---------------------------------------------------------------------------
off_104284	DCD aSvc_flushproce	; DATA XREF: inter_process_dma_copy+4Cr
					; "svc_flushProcessDataCache(hSrc) failed."...
off_104288	DCD aSvc_flushpro_0	; DATA XREF: inter_process_dma_copy+6Cr
					; "svc_flushProcessDataCache(hDst) failed."...
dword_10428C	DCD 0x2710		; DATA XREF: inter_process_dma_copy+A0r
dword_104290	DCD 0xFFF04504		; DATA XREF: inter_process_dma_copy+A4r
dword_104294	DCD 0xFFF54204		; DATA XREF: inter_process_dma_copy+A8r
dword_104298	DCD 0xFFF04204		; DATA XREF: inter_process_dma_copy+D8r
dword_10429C	DCD 0xF4240		; DATA XREF: inter_process_dma_copy:loc_104238r
off_1042A0	DCD aReadremotememo	; DATA XREF: inter_process_dma_copy+10Cr
					; "readRemoteMemory time out %08x"

; =============== S U B	R O U T	I N E =======================================


; int __cdecl sub_1042A4(unsigned int handle, void *buf)
sub_1042A4				; CODE XREF: inject_into_nintendo_home+94p

dst		= -0x108
var_AC		= -0xAC
var_A8		= -0xA8

		STMFD		SP!, {R4,LR}
		SUB		SP, SP,	#0x200
		MOV		R4, R1
		BL		arm11k_get_kernel_object ; r0 =	handle
					; returns ptr to kernel	object

		MOV		R2, #0x100 ; count
		MOV		R1, R0	; src
		MOV		R0, SP	; dst
		BL		arm11k_memcpy

		LDR		R3, =offs_KCodeSet
		ADD		R0, SP,	#0x208+dst ; dst
		MOV		R2, #0x100 ; count
		LDR		R3, [R3]
		LDR		R1, [SP,R3] ; src
		BL		arm11k_memcpy

		LDR		R3, [SP,#0x208+var_AC]
		STR		R3, [R4]
		LDR		R3, [SP,#0x208+var_A8]
		STR		R3, [R4,#4]
		ADD		SP, SP,	#0x200
		LDMFD		SP!, {R4,PC}

; End of function sub_1042A4

; ---------------------------------------------------------------------------
off_1042F4	DCD offs_KCodeSet	; DATA XREF: sub_1042A4+20r

; =============== S U B	R O U T	I N E =======================================


get_process_name			; CODE XREF: handle_listprocess_packet+44p
					; ntr_cmd_process+128p

hProcess	= -0x224
buf		= -0x220
KCodeSet	= -0x120
procname	= -0xD0
var_C6		= -0xC6
var_C4		= -0xC4
var_C0		= -0xC0

		STMFD		SP!, {R4-R9,LR}
		MOV		R12, R0
		SUB		SP, SP,	#0x20C
		MOV		R9, R1
		ADD		R0, SP,	#0x228+hProcess
		MOV		R1, R12
		MOV		R6, R2
		MOV		R8, R3
		BL		OpenProcess

		SUBS		R4, R0,	#0
		BEQ		loc_104338

		LDR		R0, =aOpenprocessF_0 ; "openProcess failed: %08x\n"
		MOV		R1, R4
		MOV		R2, #0
		BL		nsDbgPrint

		B		loc_104394

; ---------------------------------------------------------------------------

loc_104338				; CODE XREF: get_process_name+28j
		LDR		R0, [SP,#0x228+hProcess] ; handle
		BL		arm11k_get_kernel_object ; r0 =	handle
					; returns ptr to kernel	object

		ADD		R7, SP,	#0x228+buf
		MOV		R2, #0x100 ; count
		MOV		R5, R0
		MOV		R1, R5	; src
		MOV		R0, R7	; dst
		BL		arm11k_memcpy

		LDR		R3, =offs_KCodeSet
		ADD		R0, SP,	#0x228+KCodeSet	; dst
		MOV		R2, #0x100 ; count
		LDR		R3, [R3]
		LDR		R1, [R7,R3] ; src
		BL		arm11k_memcpy

		LDR		R3, [SP,#0x228+var_C4]
		MOV		R0, R9
		STR		R3, [R6]
		LDR		R3, [SP,#0x228+var_C0]
		ADD		R1, SP,	#0x228+procname
		STR		R3, [R6,#4]
		STRB		R4, [SP,#0x228+var_C6]
		BL		strncpy_

		STR		R5, [R8]


loc_104394				; CODE XREF: get_process_name+3Cj
		LDR		R0, [SP,#0x228+hProcess]
		CMP		R0, #0
		BEQ		loc_1043A4

		BL		CloseHandle


loc_1043A4				; CODE XREF: get_process_name+A4j
		MOV		R0, R4
		ADD		SP, SP,	#0x20C
		LDMFD		SP!, {R4-R9,PC}

; End of function get_process_name

; ---------------------------------------------------------------------------
off_1043B0	DCD aOpenprocessF_0	; DATA XREF: get_process_name+2Cr
					; "openProcess failed: %08x\n"
off_1043B4	DCD offs_KCodeSet	; DATA XREF: get_process_name+60r

; =============== S U B	R O U T	I N E =======================================


; void __cdecl dump_process_to_file(unsigned int pid, char *filename)
dump_process_to_file			; CODE XREF: install_ntr+B8p
					; install_ntr+C4p ...

size		= -0x1078
var_1068	= -0x1068
var_105C	= -0x105C
var_1058	= -0x1058
hSrc		= -0x1050
var_104C	= -0x104C
var_1044	= -0x1044
var_1040	= -0x1040
var_103C	= -0x103C
var_1038	= -0x1038
var_1018	= -0x1018

		STMFD		SP!, {R4-R8,LR}
		SUB		SP, SP,	#0x1040
		SUB		SP, SP,	#0x20
		MOV		R3, #3
		MOV		R6, R0
		MOV		R0, R1	; a1
		MOV		R4, R1
		STRB		R3, [SP,#0x1078+var_1044]
		BL		strlen_

		ADD		R2, SP,	#0x1078+var_1044
		STR		R4, [SP,#0x1078+var_103C]
		ADD		R3, SP,	#0x1078+var_1068
		LDR		R12, =dword_108364
		MOV		R5, #0
		ADD		R0, R0,	#1
		STR		R0, [SP,#0x1078+var_1040]
		LDMIA		R2, {R0-R2}
		STMIA		R3, {R0-R2}
		MOV		R3, #7
		STR		R3, [SP,#0x1078+var_105C]
		ADD		R3, R12, #8
		STR		R5, [SP,#0x1078+var_1058]
		LDMIA		R3, {R0-R3}
		STMEA		SP, {R0-R3}
		LDR		R1, =hFSUser
		LDMIA		R12, {R2,R3}
		LDR		R0, [R1]
		ADD		R1, SP,	#0x1078+var_104C
		BL		openFile_

		SUBS		R4, R0,	#0
		LDRNE		R0, =aOpenfileFailed ; "openFile failed: %08x"
		MOVNE		R1, R4
		MOVNE		R2, R5
		BNE		loc_1044BC

		MOV		R1, R6
		ADD		R0, SP,	#0x1078+hSrc
		BL		OpenProcess

		SUBS		R1, R0,	#0
		MOVNE		R2, R4
		LDRNE		R0, =aOpenprocessF_3 ; "openProcess failed: %08x"
		BNE		loc_1044BC

		ADD		R3, SP,	#0x1078+var_1018
		MOV		R4, #0x100000
		ADD		R5, SP,	#0x1078+var_1038
		SUB		R7, R3,	#0x30


loc_10446C				; CODE XREF: dump_process_to_file+174j
		LDR		R1, =(aOutaddr08xAddr+0xF)
		MOV		R2, R4
		MOV		R0, R5
		BL		xsprintf

		MOV		R0, R5
		BL		sub_106F68

		MOV		R1, #0
		LDR		R2, =0x1020
		MOV		R0, R5
		BL		memset_

		LDR		R0, [SP,#0x1078+hSrc] ;	hKProcess
		MOV		R1, R4	; addr
		MOV		R2, #0x1000 ; size
		BL		protectRemoteMemory ; assigns RWX to addr : addr+size

		SUB		R6, R4,	#0x100000
		SUBS		R8, R0,	#0
		BEQ		loc_1044D4

		LDR		R0, =aDumpFinishedAt ; "dump finished at addr: %08x"
		MOV		R1, R4
		MOV		R2, #0


loc_1044BC				; CODE XREF: dump_process_to_file+84j
					; dump_process_to_file+A0j
		BL		showDbg

		LDR		R0, [SP,#0x1078+hSrc]
		CMP		R0, #0
		BEQ		loc_104530

		BL		CloseHandle

		B		loc_104530

; ---------------------------------------------------------------------------

loc_1044D4				; CODE XREF: dump_process_to_file+F4j
		MOV		R3, #0x1000
		STR		R3, [SP,#0x1078+size] ;	size
		MOV		R1, R5	; dst_addr
		LDR		R0, =0xFFFF8001	; hDst
		LDR		R2, [SP,#0x1078+hSrc] ;	hSrc
		MOV		R3, R4	; src_addr
		BL		inter_process_dma_copy

		SUBS		R1, R0,	#0
		BEQ		loc_104504

		LDR		R0, =aReadremoteme_0 ; "readRemoteMemory failed: %08x"
		MOV		R2, R8
		BL		showDbg


loc_104504				; CODE XREF: dump_process_to_file+13Cj
		MOV		R2, #0x1000
		MOV		R3, #0
		STR		R5, [SP,#0x1078+size]
		STMFA		SP, {R2,R3}
		LDR		R0, [SP,#0x1078+var_104C]
		MOV		R1, R7
		MOV		R2, R6
		MOV		R3, #0
		BL		_FSFile_Write

		ADD		R4, R4,	#0x1000
		B		loc_10446C

; ---------------------------------------------------------------------------

loc_104530				; CODE XREF: dump_process_to_file+110j
					; dump_process_to_file+118j
		LDR		R0, [SP,#0x1078+var_104C]
		CMP		R0, #0
		BEQ		loc_104540

		BL		CloseHandle


loc_104540				; CODE XREF: dump_process_to_file+180j
		ADD		SP, SP,	#0x1040
		ADD		SP, SP,	#0x20
		LDMFD		SP!, {R4-R8,PC}

; End of function dump_process_to_file

; ---------------------------------------------------------------------------
off_10454C	DCD dword_108364	; DATA XREF: dump_process_to_file+30r
off_104550	DCD hFSUser		; DATA XREF: dump_process_to_file+60r
off_104554	DCD aOpenfileFailed	; DATA XREF: dump_process_to_file+78r
					; "openFile failed: %08x"
off_104558	DCD aOpenprocessF_3	; DATA XREF: dump_process_to_file+9Cr
					; "openProcess failed: %08x"
off_10455C	DCD aOutaddr08xAddr+0xF	; DATA XREF: dump_process_to_file:loc_10446Cr
dword_104560	DCD 0x1020		; DATA XREF: dump_process_to_file+D0r
off_104564	DCD aDumpFinishedAt	; DATA XREF: dump_process_to_file+F8r
					; "dump finished at addr: %08x"
; unsigned int dword_104568
dword_104568	DCD 0xFFFF8001		; DATA XREF: dump_process_to_file+128r
off_10456C	DCD aReadremoteme_0	; DATA XREF: dump_process_to_file+140r
					; "readRemoteMemory failed: %08x"
; ---------------------------------------------------------------------------
		STMFD		SP!, {R4-R7,LR}
		SUB		SP, SP,	#0x1040
		SUB		SP, SP,	#0x24
		MOV		R4, #0
		MOV		R3, #3
		MOV		R6, R0
		MOV		R0, R1
		MOV		R5, R1
		STRB		R3, [SP,#0x34]
		STR		R4, [SP,#0x28]
		STR		R4, [SP,#0x2C]
		BL		strlen_

		ADD		R2, SP,	#0x34
		STR		R5, [SP,#0x3C]
		ADD		R3, SP,	#0x10
		LDR		R12, =dword_108364
		ADD		R0, R0,	#1
		STR		R0, [SP,#0x38]
		LDMIA		R2, {R0-R2}
		STMIA		R3, {R0-R2}
		MOV		R3, #7
		STR		R3, [SP,#0x1C]
		ADD		R3, R12, #8
		STR		R4, [SP,#0x20]
		LDMIA		R3, {R0-R3}
		STMEA		SP, {R0-R3}
		LDR		R1, =hFSUser
		LDMIA		R12, {R2,R3}
		LDR		R0, [R1]
		ADD		R1, SP,	#0x2C
		BL		openFile_

		SUBS		R5, R0,	#0
		LDRNE		R0, =aOpenfileFailed ; "openFile failed: %08x"
		MOVNE		R1, R5
		MOVNE		R2, R4
		BNE		loc_1046A8

		LDR		R0, =aHfile08x ; "hfile: %08x"
		LDR		R1, [SP,#0x2C]
		MOV		R2, R5
		BL		showDbg

		ADD		R0, SP,	#0x28
		MOV		R1, R6
		BL		DebugActiveProcess

		SUBS		R4, R0,	#0
		LDRNE		R0, =aDebugactivepro ; "debugActiveProcess failed: %08x"
		MOVNE		R1, R4
		MOVNE		R2, R5
		BNE		loc_1046A8

		LDR		R0, =aHdebug08x	; "hdebug: %08x"
		LDR		R1, [SP,#0x28]
		MOV		R2, R4
		BL		showDbg

		ADD		R3, SP,	#0x60
		ADD		R5, SP,	#0x40
		SUB		R7, R3,	#0x30


loc_10464C				; CODE XREF: ROM:001046E8j
		ADD		R6, R4,	#0x100000
		MOV		R0, R5
		LDR		R1, =(aOutaddr08xAddr+0xF)
		MOV		R2, R6
		BL		xsprintf

		MOV		R1, #0xA
		MOV		R3, #0
		MOV		R2, R1
		STR		R3, [SP]
		STR		R3, [SP,#4]
		MOV		R0, R5
		MOV		R3, #0xFF
		BL		display_stuff

		BL		update_screen

		MOV		R2, R6
		MOV		R0, R5
		LDR		R1, [SP,#0x28]
		MOV		R3, #0x1000
		BL		ReadProcessMemory

		SUBS		R2, R0,	#0
		BEQ		loc_1046C0

		LDR		R0, =aReadmemoryAddr ; "readmemory addr = %08x, ret = %08x"
		MOV		R1, R6


loc_1046A8				; CODE XREF: ROM:001045FCj
					; ROM:0010462Cj
		BL		showDbg

		LDR		R0, [SP,#0x28]
		CMP		R0, #0
		BEQ		loc_1046EC

		BL		CloseHandle

		B		loc_1046EC

; ---------------------------------------------------------------------------

loc_1046C0				; CODE XREF: ROM:0010469Cj
		MOV		R3, #0x1000
		STR		R3, [SP,#4]
		STR		R2, [SP,#8]
		STR		R5, [SP]
		MOV		R2, R4
		LDR		R0, [SP,#0x2C]
		MOV		R1, R7
		MOV		R3, #0
		BL		_FSFile_Write

		ADD		R4, R4,	#0x1000
		B		loc_10464C

; ---------------------------------------------------------------------------

loc_1046EC				; CODE XREF: ROM:001046B4j
					; ROM:001046BCj
		LDR		R0, [SP,#0x2C]
		CMP		R0, #0
		BEQ		loc_1046FC

		BL		CloseHandle


loc_1046FC				; CODE XREF: ROM:001046F4j
		ADD		SP, SP,	#0x1040
		ADD		SP, SP,	#0x24
		LDMFD		SP!, {R4-R7,PC}

; ---------------------------------------------------------------------------
off_104708	DCD dword_108364	; DATA XREF: ROM:001045ACr
off_10470C	DCD hFSUser		; DATA XREF: ROM:001045D8r
off_104710	DCD aOpenfileFailed	; DATA XREF: ROM:001045F0r
					; "openFile failed: %08x"
off_104714	DCD aHfile08x		; DATA XREF: ROM:00104600r
					; "hfile: %08x"
off_104718	DCD aDebugactivepro	; DATA XREF: ROM:00104620r
					; "debugActiveProcess failed: %08x"
off_10471C	DCD aHdebug08x		; DATA XREF: ROM:00104630r
					; "hdebug: %08x"
off_104720	DCD aOutaddr08xAddr+0xF	; DATA XREF: ROM:00104654r
off_104724	DCD aReadmemoryAddr	; DATA XREF: ROM:001046A0r
					; "readmemory addr = %08x, ret = %08x"

; =============== S U B	R O U T	I N E =======================================


; int __cdecl dump_memory_to_file(unsigned int va_dumpaddr, unsigned int size, char *filename)
dump_memory_to_file			; CODE XREF: install_ntr+ECp

var_1128	= -0x1128
var_1118	= -0x1118
var_110C	= -0x110C
var_1108	= -0x1108
var_1100	= -0x1100
var_10FC	= -0x10FC
var_10E8	= -0x10E8
var_1020	= -0x1020

		STMFD		SP!, {R4-R10,LR}
		SUB		SP, SP,	#0x1100
		SUB		SP, SP,	#8
		ADD		R4, SP,	#0x1128+var_1020
		MOV		R8, R2
		MOV		R5, #0
		MOV		R7, R0
		LDR		R0, =aDumpcode ; "dumpcode"
		MOV		R6, R1
		STR		R5, [R4,#-0xE0]
		STR		R5, [R4,#-0xDC]
		BL		invoke_osd_wait_for_input

		MOV		R3, #3
		MOV		R0, R8	; a1
		STRB		R3, [R4,#-0xD4]
		BL		strlen_

		STR		R8, [R4,#-0xCC]
		ADD		R0, R0,	#1
		STR		R0, [R4,#-0xD0]
		LDR		R0, =aTestpath ; "testpath"
		BL		invoke_osd_wait_for_input

		SUB		R2, R4,	#0xD4
		ADD		R3, SP,	#0x1128+var_1118
		LDMIA		R2, {R0-R2}
		LDR		R12, =dword_108364
		STMIA		R3, {R0-R2}
		MOV		R3, #7
		STR		R3, [SP,#0x1128+var_110C]
		ADD		R3, R12, #8
		STR		R5, [SP,#0x1128+var_1108]
		LDMIA		R3, {R0-R3}
		STMEA		SP, {R0-R3}
		LDR		R1, =hFSUser
		LDMIA		R12, {R2,R3}
		LDR		R0, [R1]
		ADD		R1, SP,	#0x1128+var_1100
		BL		openFile_

		LDR		R0, =aOpenfile ; "openfile"
		BL		invoke_osd_wait_for_input

		LDR		R3, [R4,#-0xE0]
		CMP		R3, R5
		ADDNE		R8, SP,	#0x1128+var_10E8
		LDRNE		R9, =0xF423F
		BNE		loc_10481C

		LDR		R0, =aOpenFileFailed ; "open file failed"
		BL		invoke_osd_wait_for_input

		B		loc_104860

; ---------------------------------------------------------------------------

loc_1047E4				; CODE XREF: dump_memory_to_file+128j
		MOV		R0, R4	; dst
		MOV		R1, R10	; src
		MOV		R2, #0x1000 ; count
		BL		arm11k_memcpy

		MOV		R2, #0x1000
		MOV		R3, #0
		STR		R4, [SP,#0x1128+var_1128]
		STMFA		SP, {R2,R3}
		ADD		R1, SP,	#0x1128+var_10FC
		MOV		R2, R5
		LDR		R0, [R4,#-0xE0]
		MOV		R3, #0
		BL		_FSFile_Write

		ADD		R5, R5,	#0x1000


loc_10481C				; CODE XREF: dump_memory_to_file+ACj
		CMP		R5, R6
		BCS		loc_104860

		ADD		R10, R5, R7
		MOV		R0, R8
		LDR		R1, =(aOutaddr08xAddr+0xF)
		MOV		R2, R10
		BL		xsprintf

		MOV		R0, R8
		BL		sub_106F68

		MOV		R3, #0


loc_104844				; CODE XREF: dump_memory_to_file+134j
		STR		R3, [R4,#-0xD8]
		LDR		R3, [R4,#-0xD8]
		CMP		R3, R9
		BHI		loc_1047E4

		LDR		R3, [R4,#-0xD8]
		ADD		R3, R3,	#1
		B		loc_104844

; ---------------------------------------------------------------------------

loc_104860				; CODE XREF: dump_memory_to_file+B8j
					; dump_memory_to_file+F8j
		ADD		SP, SP,	#0x1100
		ADD		SP, SP,	#8
		LDMFD		SP!, {R4-R10,PC}

; End of function dump_memory_to_file

; ---------------------------------------------------------------------------
off_10486C	DCD aDumpcode		; DATA XREF: dump_memory_to_file+1Cr
					; "dumpcode"
off_104870	DCD aTestpath		; DATA XREF: dump_memory_to_file+4Cr
					; "testpath"
off_104874	DCD dword_108364	; DATA XREF: dump_memory_to_file+60r
off_104878	DCD hFSUser		; DATA XREF: dump_memory_to_file+80r
off_10487C	DCD aOpenfile		; DATA XREF: dump_memory_to_file+94r
					; "openfile"
dword_104880	DCD 0xF423F		; DATA XREF: dump_memory_to_file+A8r
off_104884	DCD aOpenFileFailed	; DATA XREF: dump_memory_to_file+B0r
					; "open file failed"
off_104888	DCD aOutaddr08xAddr+0xF	; DATA XREF: dump_memory_to_file+104r

; =============== S U B	R O U T	I N E =======================================


inject_code				; CODE XREF: patch_sm+24p

size		= -0x28
hDst		= -0x1C
var_18		= -0x18

		STMFD		SP!, {R4-R7,LR}
		SUB		SP, SP,	#0x14
		MOV		R12, R0
		ADD		R0, SP,	#0x28+var_18
		MOV		R7, R3
		MOV		R3, #0
		MOV		R5, R1
		STR		R3, [R0,#-4]!
		MOV		R1, R12
		MOV		R6, R2
		BL		OpenProcess

		CMP		R0, #0
		BNE		err

		LDR		R0, [SP,#0x28+hDst] ; hProcess
		MOV		R1, R5	; addr
		MOV		R2, R6	; size
		BL		rtCheckRemoteMemoryRegionSafeForWrite

		SUBS		R4, R0,	#0
		BNE		loc_1048F4

		STR		R6, [SP,#0x28+size] ; size
		LDR		R0, [SP,#0x28+hDst] ; hDst
		MOV		R1, R5	; dst_addr
		LDR		R2, =0xFFFF8001	; hSrc
		MOV		R3, R7	; src_addr
		BL		inter_process_dma_copy

		MOV		R4, R0


loc_1048F4				; CODE XREF: inject_code+48j
		LDR		R0, [SP,#0x28+hDst]
		CMP		R0, #0
		BEQ		loc_104904

		BL		CloseHandle


loc_104904				; CODE XREF: inject_code+70j
		MOV		R0, R4


err					; CODE XREF: inject_code+30j
		ADD		SP, SP,	#0x14
		LDMFD		SP!, {R4-R7,PC}

; End of function inject_code

; ---------------------------------------------------------------------------
; unsigned int dword_104910
dword_104910	DCD 0xFFFF8001		; DATA XREF: inject_code+58r

; =============== S U B	R O U T	I N E =======================================


patch_sm

var_4		= -4

		LDR		R2, =0xE3A00001
		LDR		R3, =0xE12FFF1E
		STR		LR, [SP,#var_4]!
		SUB		SP, SP,	#0x54
		LDR		R1, =loc_101820
		STMEA		SP, {R2,R3}
		MOV		R0, #3
		MOV		R2, #8
		MOV		R3, SP
		BL		inject_code

		SUBS		R1, R0,	#0
		BEQ		patch_success

		LDR		R0, =aPatchSmFailed0 ; "patch sm failed: %08x"
		MOV		R2, #0
		BL		showDbg


patch_success				; CODE XREF: patch_sm+2Cj
		ADD		SP, SP,	#0x54
		LDR		PC, [SP+4+var_4],#4

; End of function patch_sm

; ---------------------------------------------------------------------------
dword_104958	DCD 0xE3A00001		; DATA XREF: patch_smr
dword_10495C	DCD 0xE12FFF1E		; DATA XREF: patch_sm+4r
off_104960	DCD loc_101820		; DATA XREF: patch_sm+10r
off_104964	DCD aPatchSmFailed0	; DATA XREF: patch_sm+30r
					; "patch sm failed: %08x"

; =============== S U B	R O U T	I N E =======================================


ntr_cmd_process				; CODE XREF: display_OSD_menu+9Cp

var_6BC		= -0x6BC
var_6B8		= -0x6B8
var_6B0		= -0x6B0
var_6A0		= -0x6A0
var_696		= -0x696
a1		= -0x68C
var_658		= -0x658
var_4C8		= -0x4C8
var_338		= -0x338
var_20		= -0x20

		STMFD		SP!, {R4-R8,LR}
		SUB		SP, SP,	#0x6A0
		SUB		SP, SP,	#8
		ADD		R5, SP,	#0x6C0+var_6B8
		ADD		R8, SP,	#0x6C0+var_658
		MOV		R4, #0
		MOV		R1, R8
		SUB		R0, R5,	#4
		MOV		R2, #0x64 ; 'd'
		STR		R4, [SP,#0x6C0+var_6BC]
		BL		GetProcessList

		SUBS		R1, R0,	#0
		MOVEQ		R4, R1
		STREQB		R1, [SP,#0x6C0+var_338]
		MOVEQ		R6, R4
		BEQ		loc_1049B8

		LDR		R0, =aGetprocessli_0 ; "getProcessList failed: %08x"
		MOV		R2, R4
		BL		showDbg

		B		loc_104AA8

; ---------------------------------------------------------------------------

loc_1049B8				; CODE XREF: ntr_cmd_process+3Cj
					; ntr_cmd_process+98j
		LDR		R3, [SP,#0x6C0+var_6BC]
		ADD		R7, SP,	#0x6C0+var_4C8
		CMP		R4, R3
		BCS		loc_104A04

		LDR		R2, [R8,R4,LSL#2]
		ADD		R0, SP,	#0x6C0+a1
		LDR		R1, =(aSendRemainSize+0x1A)
		BL		xsprintf

		ADD		R3, SP,	#0x6C0+var_338
		ADD		R0, R3,	R6
		ADD		R1, SP,	#0x6C0+a1
		STR		R0, [R7,R4,LSL#2]
		BL		strncpy_

		ADD		R0, SP,	#0x6C0+a1 ; a1
		BL		strlen_

		ADD		R4, R4,	#1
		ADD		R0, R0,	#1
		ADD		R6, R6,	R0
		B		loc_1049B8

; ---------------------------------------------------------------------------

loc_104A04				; CODE XREF: ntr_cmd_process+5Cj
		LDR		R8, =off_109AE8


loc_104A08				; CODE XREF: ntr_cmd_process+104j
					; ntr_cmd_process+10Cj	...
		LDR		R0, =aProcesslist ; "processList"
		LDR		R1, [SP,#0x6C0+var_6BC]
		MOV		R2, R7
		BL		get_process_list_action	; returns
					; 0 - dump
					; 1 - info

		CMN		R0, #1
		MOV		R4, R0
		BEQ		loc_104AA8

		ADD		R3, SP,	#0x6C0+var_20
		LDMIA		R8, {R0,R1}
		ADD		R3, R3,	#8
		ADD		R4, R3,	R4,LSL#2
		STMIA		R5, {R0,R1}
		MOV		R2, R5
		LDR		R0, [R4,#-0x4B0]
		MOV		R1, #2
		BL		get_process_list_action	; returns
					; 0 - dump
					; 1 - info

		CMP		R0, #0
		BNE		loc_104A70

		ADD		R0, SP,	#0x6C0+a1
		LDR		R1, =aDump_pid08x ; "/dump_pid%08x"
		LDR		R2, [R4,#-0x640]
		BL		xsprintf

		LDR		R0, [R4,#-0x640] ; pid
		ADD		R1, SP,	#0x6C0+a1 ; filename
		BL		dump_process_to_file

		B		loc_104A08

; ---------------------------------------------------------------------------

loc_104A70				; CODE XREF: ntr_cmd_process+E4j
		CMP		R0, #1
		BNE		loc_104A08

		MOV		R6, #0
		ADD		R1, SP,	#0x6C0+var_6A0
		ADD		R2, SP,	#0x6C0+var_6B0
		LDR		R0, [R4,#-0x640]
		SUB		R3, R5,	#8
		STRB		R6, [SP,#0x6C0+var_696]
		BL		get_process_name

		LDR		R0, =aPnameS ; "pname: %s"
		ADD		R1, SP,	#0x6C0+var_6A0
		MOV		R2, R6
		BL		showDbg

		B		loc_104A08

; ---------------------------------------------------------------------------

loc_104AA8				; CODE XREF: ntr_cmd_process+4Cj
					; ntr_cmd_process+B8j
		ADD		SP, SP,	#0x6A0
		ADD		SP, SP,	#8
		LDMFD		SP!, {R4-R8,PC}

; End of function ntr_cmd_process

; ---------------------------------------------------------------------------
off_104AB4	DCD aGetprocessli_0	; DATA XREF: ntr_cmd_process+40r
					; "getProcessList failed: %08x"
off_104AB8	DCD aSendRemainSize+0x1A ; DATA	XREF: ntr_cmd_process+68r
off_104ABC	DCD off_109AE8		; DATA XREF: ntr_cmd_process:loc_104A04r
off_104AC0	DCD aProcesslist	; DATA XREF: ntr_cmd_process:loc_104A08r
					; "processList"
off_104AC4	DCD aDump_pid08x	; DATA XREF: ntr_cmd_process+ECr
					; "/dump_pid%08x"
off_104AC8	DCD aPnameS		; DATA XREF: ntr_cmd_process+12Cr
					; "pname: %s"

; =============== S U B	R O U T	I N E =======================================


; int __cdecl rtInitLock(RT_LOCK *lock)
rtInitLock				; CODE XREF: init_config_mem+1Cp
					; setup_ntr_network_server+12Cp ...
		MOV		R3, #0
		STR		R3, [R0]
		BX		LR

; End of function rtInitLock


; =============== S U B	R O U T	I N E =======================================


; int __cdecl rtAcquireLock(RT_LOCK *lock)
rtAcquireLock				; CODE XREF: nsDbgPrint+30p
					; sub_101CD4+1Cp ...
		STMFD		SP!, {R4,LR}
		MOV		R4, R0


loc_104AE0				; CODE XREF: rtAcquireLock+20j
		LDR		R3, [R4]
		CMP		R3, #0
		BEQ		loc_104AFC

		LDR		R0, =0xF4240
		MOV		R1, #0
		BL		SleepThread

		B		loc_104AE0

; ---------------------------------------------------------------------------

loc_104AFC				; CODE XREF: rtAcquireLock+10j
		MOV		R3, #1
		STR		R3, [R4]
		LDMFD		SP!, {R4,PC}

; End of function rtAcquireLock

; ---------------------------------------------------------------------------
dword_104B08	DCD 0xF4240		; DATA XREF: rtAcquireLock+14r

; =============== S U B	R O U T	I N E =======================================


; int __cdecl rtReleaseLock(RT_LOCK *lock)
rtReleaseLock				; CODE XREF: nsDbgPrint+48p
					; sub_101CD4+70p ...
		MOV		R3, #0
		STR		R3, [R0]
		BX		LR

; End of function rtReleaseLock


; =============== S U B	R O U T	I N E =======================================


round_to_pagesize_			; CODE XREF: inject_ntr_into_home_menu+2Cp
					; handle_reload_packet+C4p ...
		CMP		R0, #0
		SUBNE		R0, R0,	#1
		BICNE		R0, R0,	#0xFF0
		BICNE		R0, R0,	#0xF
		ADDNE		R0, R0,	#0x1000
		BX		LR

; End of function round_to_pagesize_

; ---------------------------------------------------------------------------
		BIC		R0, R0,	#0xFF0
		BIC		R0, R0,	#0xF
		BX		LR


; =============== S U B	R O U T	I N E =======================================


; int __cdecl rtCheckRemoteMemoryRegionSafeForWrite(unsigned int hProcess, unsigned int	addr, unsigned int size)
rtCheckRemoteMemoryRegionSafeForWrite	; CODE XREF: init_breakpoint_+30p
					; handle_writemem_packet+7Cp ...
		SUB		R2, R2,	#1
		STMFD		SP!, {R4-R6,LR}
		ADD		R4, R2,	R1
		BIC		R5, R1,	#0xFF0
		BIC		R4, R4,	#0xFF0
		MOV		R6, R0
		BIC		R5, R5,	#0xF
		BIC		R4, R4,	#0xF


loc_104B5C				; CODE XREF: rtCheckRemoteMemoryRegionSafeForWrite+44j
		CMP		R5, R4
		BHI		loc_104B84

		MOV		R0, R6	; hKProcess
		MOV		R1, R5	; addr
		MOV		R2, #0x1000 ; size
		BL		protectRemoteMemory ; assigns RWX to addr : addr+size

		CMP		R0, #0
		LDMNEFD		SP!, {R4-R6,PC}

		ADD		R5, R5,	#0x1000
		B		loc_104B5C

; ---------------------------------------------------------------------------

loc_104B84				; CODE XREF: rtCheckRemoteMemoryRegionSafeForWrite+24j
		MOV		R0, #0
		LDMFD		SP!, {R4-R6,PC}

; End of function rtCheckRemoteMemoryRegionSafeForWrite


; =============== S U B	R O U T	I N E =======================================


; int __fastcall rtSafeCopyMemory(unsigned int dst, unsigned int src, unsigned int size)
rtSafeCopyMemory
		STMFD		SP!, {R3-R7,LR}
		MOV		R7, R0
		MOV		R6, R1
		LDR		R0, =0xFFFF8001	; hProcess
		MOV		R1, R7	; addr
		MOV		R5, R2
		BL		rtCheckRemoteMemoryRegionSafeForWrite

		CMP		R0, #0
		LDMNEFD		SP!, {R3-R7,PC}

		LDR		R0, =0xFFFF8001	; hProcess
		MOV		R1, R6	; addr
		MOV		R2, R5	; size
		BL		rtCheckRemoteMemoryRegionSafeForWrite

		SUBS		R4, R0,	#0
		BNE		loc_104BD8

		MOV		R0, R7
		MOV		R1, R6
		MOV		R2, R5
		BL		memcpy


loc_104BD8				; CODE XREF: rtSafeCopyMemory+38j
		MOV		R0, R4
		LDMFD		SP!, {R3-R7,PC}

; End of function rtSafeCopyMemory

; ---------------------------------------------------------------------------
; unsigned int dword_104BE0
dword_104BE0	DCD 0xFFFF8001		; DATA XREF: rtSafeCopyMemory+Cr
					; rtSafeCopyMemory+24r

; =============== S U B	R O U T	I N E =======================================


recv_					; CODE XREF: recv_wrapper+38p
					; handle_network_client+C0p
		STMFD		SP!, {R4-R8,LR}
		MOV		R7, R0
		MOV		R8, R1
		MOV		R6, R2
		MOV		R4, R2
		MOV		R5, #0


loc_104BFC				; CODE XREF: recv_+50j
		CMP		R4, #0
		BEQ		loc_104C38

		MOV		R0, R7
		ADD		R1, R8,	R5
		MOV		R2, R4
		MOV		R3, #0
		BL		recvfrom_wrapper

		CMP		R0, #0
		BGT		loc_104C2C

		LDMEQFD		SP!, {R4-R8,PC}

		LDMFD		SP!, {R4-R8,LR}
		B		sub_10586C

; ---------------------------------------------------------------------------

loc_104C2C				; CODE XREF: recv_+38j
		ADD		R5, R5,	R0
		RSB		R4, R0,	R4
		B		loc_104BFC

; ---------------------------------------------------------------------------

loc_104C38				; CODE XREF: recv_+1Cj
		MOV		R0, R6
		LDMFD		SP!, {R4-R8,PC}

; End of function recv_


; =============== S U B	R O U T	I N E =======================================


sub_104C40				; CODE XREF: sub_101984+20j
					; sub_1019AC+38p
		STMFD		SP!, {R4-R8,LR}
		MOV		R7, R0
		MOV		R8, R1
		MOV		R6, R2
		MOV		R4, R2
		MOV		R5, #0


loc_104C58				; CODE XREF: sub_104C40+4Cj
		CMP		R4, #0
		BEQ		loc_104C90

		MOV		R0, R7
		ADD		R1, R8,	R5
		MOV		R2, R4
		MOV		R3, #0
		BL		sendto_wrapper

		CMP		R0, #0
		BGE		loc_104C84

		LDMFD		SP!, {R4-R8,LR}
		B		sub_10586C

; ---------------------------------------------------------------------------

loc_104C84				; CODE XREF: sub_104C40+38j
		ADD		R5, R5,	R0
		RSB		R4, R0,	R4
		B		loc_104C58

; ---------------------------------------------------------------------------

loc_104C90				; CODE XREF: sub_104C40+1Cj
		MOV		R0, R6
		LDMFD		SP!, {R4-R8,PC}

; End of function sub_104C40


; =============== S U B	R O U T	I N E =======================================


sub_104C98				; CODE XREF: handle_network_client+4Cp

var_2		= -2

		SUB		SP, SP,	#8
		MOV		R3, R0,LSR#8
		STRB		R3, [SP,#8+var_2]
		STRB		R0, [SP,#8+var_2+1]
		LDRH		R0, [SP,#8+var_2]
		ADD		SP, SP,	#8
		BX		LR

; End of function sub_104C98


; =============== S U B	R O U T	I N E =======================================


get_file_size				; CODE XREF: load_ntr_plugins+58p
					; load_all_plugins_and_inject_ntr_into_pm+80p

var_50		= -0x50
var_44		= -0x44
var_40		= -0x40
var_34		= -0x34
var_30		= -0x30
var_24		= -0x24
var_20		= -0x20
var_1C		= -0x1C
var_18		= -0x18

		STMFD		SP!, {R4-R7,LR}
		SUB		SP, SP,	#0x4C
		MOV		R3, #3
		MOV		R4, R0
		STRB		R3, [SP,#0x60+var_24]
		BL		strlen_

		ADD		R2, SP,	#0x60+var_18
		STR		R4, [SP,#0x60+var_1C]
		ADD		R3, SP,	#0x60+var_50
		LDR		R12, =dword_108364
		MOV		R5, #0
		ADD		R0, R0,	#1
		STR		R0, [SP,#0x60+var_20]
		LDMDB		R2, {R0-R2}
		STMIA		R3, {R0-R2}
		MOV		R3, #7
		STR		R3, [SP,#0x60+var_44]
		ADD		R3, R12, #8
		STR		R5, [SP,#0x60+var_40]
		LDMIA		R3, {R0-R3}
		STMEA		SP, {R0-R3}
		LDR		R1, =hFSUser
		LDMIA		R12, {R2,R3}
		LDR		R0, [R1]
		ADD		R1, SP,	#0x60+var_34
		BL		openFile_

		CMP		R0, R5
		MOV		R4, R0
		BEQ		loc_104D40

		LDR		R0, =aOpenfileFail_0 ; "openFile failed: %08x\n"
		MOV		R1, R4
		MOV		R2, R5
		BL		nsDbgPrint

		STR		R5, [SP,#0x60+var_34]
		B		loc_104D6C

; ---------------------------------------------------------------------------

loc_104D40				; CODE XREF: get_file_size+70j
		MOV		R7, R0
		ADD		R1, SP,	#0x60+var_30
		LDR		R0, [SP,#0x60+var_34]
		BL		FSFILE_GetSize_

		SUBS		R4, R0,	#0
		LDREQ		R6, [SP,#0x60+var_30]
		BEQ		loc_104D6C

		LDR		R0, =aFsfile_getsize ; "FSFILE_GetSize failed: %08x\n"
		MOV		R1, R4
		MOV		R2, R7
		BL		nsDbgPrint


loc_104D6C				; CODE XREF: get_file_size+88j
					; get_file_size+A4j
		LDR		R0, [SP,#0x60+var_34]
		CMP		R0, #0
		BEQ		loc_104D7C

		BL		CloseHandle


loc_104D7C				; CODE XREF: get_file_size+C0j
		CMP		R4, #0
		MOVEQ		R0, R6
		MOVNE		R0, #0
		ADD		SP, SP,	#0x4C
		LDMFD		SP!, {R4-R7,PC}

; End of function get_file_size

; ---------------------------------------------------------------------------
off_104D90	DCD dword_108364	; DATA XREF: get_file_size+24r
off_104D94	DCD hFSUser		; DATA XREF: get_file_size+54r
off_104D98	DCD aOpenfileFail_0	; DATA XREF: get_file_size+74r
					; "openFile failed: %08x\n"
off_104D9C	DCD aFsfile_getsize	; DATA XREF: get_file_size+A8r
					; "FSFILE_GetSize failed: %08x\n"

; =============== S U B	R O U T	I N E =======================================


rtLoadFileToBuffer			; CODE XREF: load_ntr_plugins+9Cp
					; load_all_plugins_and_inject_ntr_into_pm+C0p

var_68		= -0x68
var_64		= -0x64
var_58		= -0x58
var_4C		= -0x4C
var_48		= -0x48
var_40		= -0x40
var_3C		= -0x3C
var_38		= -0x38
var_2C		= -0x2C
var_28		= -0x28
var_24		= -0x24
var_20		= -0x20

		STMFD		SP!, {R4-R9,LR}
		SUB		SP, SP,	#0x4C
		MOV		R3, #3
		MOV		R4, R0
		MOV		R7, R1
		MOV		R8, R2
		STRB		R3, [SP,#0x68+var_2C]
		BL		strlen_

		ADD		R2, SP,	#0x68+var_20
		STR		R4, [SP,#0x68+var_24]
		ADD		R3, SP,	#0x68+var_58
		LDR		R12, =dword_108364
		MOV		R6, #0
		ADD		R0, R0,	#1
		STR		R0, [SP,#0x68+var_28]
		LDMDB		R2, {R0-R2}
		STMIA		R3, {R0-R2}
		MOV		R3, #7
		STR		R3, [SP,#0x68+var_4C]
		ADD		R3, R12, #8
		STR		R6, [SP,#0x68+var_48]
		LDMIA		R3, {R0-R3}
		STMEA		SP, {R0-R3}
		LDR		R1, =hFSUser
		LDMIA		R12, {R2,R3}
		LDR		R0, [R1]
		ADD		R1, SP,	#0x68+var_40
		BL		openFile_

		CMP		R0, R6
		MOV		R4, R0
		BEQ		loc_104E34

		LDR		R0, =aOpenfileFail_0 ; "openFile failed: %08x\n"
		MOV		R1, R4
		MOV		R2, R6
		BL		nsDbgPrint

		STR		R6, [SP,#0x68+var_40]
		B		loc_104EAC

; ---------------------------------------------------------------------------

loc_104E34				; CODE XREF: rtLoadFileToBuffer+78j
		MOV		R9, R0
		ADD		R1, SP,	#0x68+var_38
		LDR		R0, [SP,#0x68+var_40]
		BL		FSFILE_GetSize_

		SUBS		R6, R0,	#0
		MOV		R4, R0
		LDRNE		R0, =aFsfile_getsize ; "FSFILE_GetSize failed: %08x\n"
		MOVNE		R1, R4
		MOVNE		R2, R9
		BNE		loc_104EA8

		LDR		R5, [SP,#0x68+var_38]
		CMP		R8, R5
		BCS		loc_104E78

		LDR		R0, =aRtloadfileto_0 ; "rtLoadFileToBuffer: buffer too small\n"
		BL		nsDbgPrint

		MOV		R4, #0xFFFFFFFF
		B		loc_104EAC

; ---------------------------------------------------------------------------

loc_104E78				; CODE XREF: rtLoadFileToBuffer+C4j
		STR		R7, [SP,#0x68+var_68]
		STR		R5, [SP,#0x68+var_64]
		LDR		R0, [SP,#0x68+var_40]
		ADD		R1, SP,	#0x68+var_3C
		MOV		R2, #0
		MOV		R3, #0
		BL		FSFILE_Read

		SUBS		R4, R0,	#0
		BEQ		loc_104EAC

		LDR		R0, =aFsfile_readF_0 ; "FSFILE_Read failed: %08x\n"
		MOV		R1, R4
		MOV		R2, R6


loc_104EA8				; CODE XREF: rtLoadFileToBuffer+B8j
		BL		nsDbgPrint


loc_104EAC				; CODE XREF: rtLoadFileToBuffer+90j
					; rtLoadFileToBuffer+D4j ...
		LDR		R0, [SP,#0x68+var_40]
		CMP		R0, #0
		BEQ		loc_104EBC

		BL		CloseHandle


loc_104EBC				; CODE XREF: rtLoadFileToBuffer+114j
		CMP		R4, #0
		MOVEQ		R0, R5
		MOVNE		R0, #0
		ADD		SP, SP,	#0x4C
		LDMFD		SP!, {R4-R9,PC}

; End of function rtLoadFileToBuffer

; ---------------------------------------------------------------------------
off_104ED0	DCD dword_108364	; DATA XREF: rtLoadFileToBuffer+2Cr
off_104ED4	DCD hFSUser		; DATA XREF: rtLoadFileToBuffer+5Cr
off_104ED8	DCD aOpenfileFail_0	; DATA XREF: rtLoadFileToBuffer+7Cr
					; "openFile failed: %08x\n"
off_104EDC	DCD aFsfile_getsize	; DATA XREF: rtLoadFileToBuffer+ACr
					; "FSFILE_GetSize failed: %08x\n"
off_104EE0	DCD aRtloadfileto_0	; DATA XREF: rtLoadFileToBuffer+C8r
					; "rtLoadFileToBuffer: buffer too small\n"
off_104EE4	DCD aFsfile_readF_0	; DATA XREF: rtLoadFileToBuffer+FCr
					; "FSFILE_Read failed: %08x\n"

; =============== S U B	R O U T	I N E =======================================


; int __cdecl get_thread_context(unsigned int hProcess,	unsigned int tid, void *context_struc)
get_thread_context			; CODE XREF: get_remote_PC+78p
					; handle_listthread_packet+DCp

hThread		= -0x14

		MOV		R12, R0
		MOV		R3, R1
		STMFD		SP!, {R0-R2,R4,R5,LR}
		MOV		R4, R2
		ADD		R0, SP,	#0x18+hThread
		MOV		R1, R12
		MOV		R2, R3
		BL		OpenThread

		SUBS		R5, R0,	#0
		BEQ		loc_104F24

		LDR		R0, =aOpenthreadFail ; "openThread failed: %08x\n"
		MOV		R1, R5
		MOV		R2, #0
		BL		nsDbgPrint

		B		loc_104F58

; ---------------------------------------------------------------------------

loc_104F24				; CODE XREF: get_thread_context+24j
		LDR		R0, [SP,#0x18+hThread] ; handle
		BL		arm11k_get_kernel_object ; r0 =	handle
					; returns ptr to kernel	object

		MOV		R2, #0xA0 ; ' '	; count
		MOV		R1, R0	; src
		MOV		R0, R4	; dst
		BL		arm11k_memcpy ;	get first 0xA0 bytes of	KThread	object

		LDR		R1, [R4,#0x8C] ; end address of	the page for this thread
		MOV		R0, R4	; dst
		SUB		R1, R1,	#0x10C ; src
		MOV		R2, #0x10C ; get very last 0x10C number	of bytes of the	end address
		BL		arm11k_memcpy

		LDR		R0, [SP,#0x18+hThread]
		BL		CloseHandle


loc_104F58				; CODE XREF: get_thread_context+38j
		MOV		R0, R5
		ADD		SP, SP,	#0xC
		LDMFD		SP!, {R4,R5,PC}

; End of function get_thread_context

; ---------------------------------------------------------------------------
off_104F64	DCD aOpenthreadFail	; DATA XREF: get_thread_context+28r
					; "openThread failed: %08x\n"

; =============== S U B	R O U T	I N E =======================================


; int __cdecl rtGenerateJumpCode(void *dst, void *src)
rtGenerateJumpCode			; CODE XREF: install_ntr+17Cp
					; install_SVC_6D_hook+6Cp
		LDR		R3, =0xE51FF004
		STR		R0, [R1,#4]
		STR		R3, [R1]
		MOV		R0, #8
		BX		LR

; End of function rtGenerateJumpCode

; ---------------------------------------------------------------------------
LDR_PC_PC_MINUS_4 DCD 0xE51FF004	; DATA XREF: rtGenerateJumpCoder

; =============== S U B	R O U T	I N E =======================================


; int __cdecl flush_current_process_data_cache(const void *addr, unsigned int size)
flush_current_process_data_cache	; CODE XREF: install_ntr+170p
					; install_ntr+188p ...
		MOV		R3, R0
		MOV		R2, R1
		LDR		R0, =0xFFFF8001
		MOV		R1, R3
		B		FlushProcessDataCache

; End of function flush_current_process_data_cache

; ---------------------------------------------------------------------------
dword_104F94	DCD 0xFFFF8001		; DATA XREF: flush_current_process_data_cache+8r

; =============== S U B	R O U T	I N E =======================================


; int __fastcall rtInitHook(RT_HOOK *hook, void	*funcaddr, void	*callback_addr)
rtInitHook				; CODE XREF: thread_NTR_home_injectee+14p
					; thread_NTR_home_injectee+30p	...
		STMFD		SP!, {R4-R6,LR}
		MOV		R3, #0
		MOV		R5, R1
		STR		R3, [R0,#RT_HOOK]
		STMIB		R0, {R3,R5}
		MOV		R4, R0
		MOV		R6, R2
		BL		get_current_process_handle

		MOV		R1, R5	; addr
		MOV		R2, #8	; size
		BL		rtCheckRemoteMemoryRegionSafeForWrite

		LDR		R3, [R5]
		LDR		R1, =0xE51FF004	; ldr pc, [pc-4]
		STR		R3, [R4,#RT_HOOK.bakCode]
		LDR		R3, [R5,#4]
		STR		R1, [R4,#RT_HOOK.jmpCode]
		STR		R3, [R4,#RT_HOOK.bakCode+4]
		STR		R6, [R4,#RT_HOOK.jmpCode+4]
		LDR		R3, [R5]
		ADD		R0, R4,	#0x8C ;	addr
		STR		R3, [R4,#RT_HOOK.callCode]
		LDR		R3, [R5,#4]
		ADD		R5, R5,	#8
		STR		R3, [R0,#4]
		STR		R1, [R4,#RT_HOOK.callCode+8]
		STR		R5, [R4,#RT_HOOK.callCode+0xC]
		MOV		R1, #0x10 ; size
		LDMFD		SP!, {R4-R6,LR}
		B		flush_current_process_data_cache

; End of function rtInitHook

; ---------------------------------------------------------------------------
dword_10500C	DCD 0xE51FF004		; DATA XREF: rtInitHook+30r

; =============== S U B	R O U T	I N E =======================================


; int __cdecl rtEnableHook(struct RT_HOOK *rthook)
rtEnableHook				; CODE XREF: thread_NTR_home_injectee+1Cp
					; thread_NTR_home_injectee+38p	...
		LDR		R3, [R0,#RT_HOOK.isEnabled]
		CMP		R3, #0
		BXNE		LR

		MOV		R2, R0
		STMFD		SP!, {R4,LR}
		MOV		R4, R0
		LDR		R1, [R0,#RT_HOOK.funcAddr] ; get patch addr
		LDR		R3, [R2,#RT_HOOK.jmpCode]! ; get code: ldr pc, [pc-4]
		STR		R3, [R1] ; place jmp
		LDR		R3, [R2,#4]
		STR		R3, [R1,#4] ; place target addr
		MOV		R1, #8	; size
		LDR		R0, [R0,#8] ; addr
		BL		flush_current_process_data_cache

		MOV		R3, #1
		STR		R3, [R4,#4]
		LDMFD		SP!, {R4,PC}

; End of function rtEnableHook


; =============== S U B	R O U T	I N E =======================================


disable_breakpoint			; CODE XREF: debugcmd_disable_breakpoint+60p
		LDR		R3, [R0,#4]
		CMP		R3, #0
		BXEQ		LR

		MOV		R2, R0
		STMFD		SP!, {R4,LR}
		MOV		R4, R0
		LDR		R1, [R0,#8]
		LDR		R3, [R2,#0xC]!
		STR		R3, [R1]
		LDR		R3, [R2,#4]
		STR		R3, [R1,#4]
		MOV		R1, #8	; size
		LDR		R0, [R0,#8] ; addr
		BL		flush_current_process_data_cache

		MOV		R3, #0
		STR		R3, [R4,#4]
		LDMFD		SP!, {R4,PC}

; End of function disable_breakpoint


; =============== S U B	R O U T	I N E =======================================


; int __cdecl create_file(char *filename, unsigned int mode)
create_file				; CODE XREF: write_to_file+E0p
					; get_screenshot_index+24p

var_38		= -0x38
var_2C		= -0x2C
var_28		= -0x28
var_20		= -0x20
var_1C		= -0x1C
var_18		= -0x18
var_14		= -0x14
var_10		= -0x10

		STMFD		SP!, {R4,R5,LR}
		SUB		SP, SP,	#0x3C
		MOV		R3, #3
		MOV		R4, R1
		MOV		R5, R0
		STRB		R3, [SP,#0x48+var_1C]
		BL		strlen_

		ADD		R2, SP,	#0x48+var_10
		STR		R5, [SP,#0x48+var_14]
		ADD		R3, SP,	#0x48+var_38
		LDR		R12, =dword_108364
		ADD		R0, R0,	#1
		STR		R0, [SP,#0x48+var_18]
		LDMDB		R2, {R0-R2}
		STMIA		R3, {R0-R2}
		MOV		R3, #0
		STR		R3, [SP,#0x48+var_28]
		ADD		R3, R12, #8
		STR		R4, [SP,#0x48+var_2C]
		LDMIA		R3, {R0-R3}
		STMEA		SP, {R0-R3}
		LDR		R1, =hFSUser
		LDMIA		R12, {R2,R3}
		LDR		R0, [R1]
		ADD		R1, SP,	#0x48+var_20
		BL		openFile_

		CMP		R0, #0
		LDRGE		R0, [SP,#0x48+var_20]
		ADD		SP, SP,	#0x3C
		LDMFD		SP!, {R4,R5,PC}

; End of function create_file

; ---------------------------------------------------------------------------
off_105110	DCD dword_108364	; DATA XREF: create_file+28r
off_105114	DCD hFSUser		; DATA XREF: create_file+54r
; ---------------------------------------------------------------------------
		STMFD		SP!, {R4,R5,LR}
		SUB		SP, SP,	#0x14
		MOV		R4, R1
		MOV		R5, R1,ASR#31
		STMEA		SP, {R2,R3}
		ADD		R1, SP,	#0xC
		MOV		R2, R4
		MOV		R3, R5
		BL		FSFILE_Read

		CMP		R0, #0
		LDRGE		R0, [SP,#0xC]
		ADD		SP, SP,	#0x14
		LDMFD		SP!, {R4,R5,PC}


; =============== S U B	R O U T	I N E =======================================


FSFile_Write				; CODE XREF: write_to_file+F8p

var_20		= -0x20
var_14		= -0x14

		STMFD		SP!, {R4,R5,LR}
		SUB		SP, SP,	#0x1C
		MOV		R4, R1
		STMEA		SP, {R2,R3}
		MOV		R5, R1,ASR#31
		MOV		R3, #0
		STR		R3, [SP,#0x28+var_20]
		ADD		R1, SP,	#0x28+var_14
		MOV		R2, R4
		MOV		R3, R5
		BL		_FSFile_Write

		CMP		R0, #0
		LDRGE		R0, [SP,#0x28+var_14]
		ADD		SP, SP,	#0x1C
		LDMFD		SP!, {R4,R5,PC}

; End of function FSFile_Write

; [00000004 BYTES: COLLAPSED FUNCTION j_FSFile_Close. PRESS KEYPAD CTRL-"+" TO EXPAND]

; =============== S U B	R O U T	I N E =======================================


sub_10518C				; CODE XREF: write_to_file+48p
					; write_to_file+7Cp ...
		MOV		R3, R1,LSR#8
		STRB		R1, [R0]
		STRB		R3, [R0,#1]
		MOV		R3, R1,LSR#16
		MOV		R1, R1,LSR#24
		STRB		R3, [R0,#2]
		STRB		R1, [R0,#3]
		BX		LR

; End of function sub_10518C

; ---------------------------------------------------------------------------
		STRB		R1, [R0]
		MOV		R1, R1,LSR#8
		STRB		R1, [R0,#1]
		BX		LR


; =============== S U B	R O U T	I N E =======================================


write_to_file				; CODE XREF: create_screenshot+C4p
					; create_screenshot+130p
		STMFD		SP!, {R4-R10,LR}
		MUL		R6, R2,	R1
		MOV		R5, #0x36 ; '6'
		MOV		R4, R0
		MOV		R10, R1
		MOV		R8, R2
		MOV		R1, #0
		MOV		R2, R5
		MOV		R9, R3
		ADD		R6, R6,	R6,LSL#1
		BL		memset_

		MOV		R3, #0x42 ; 'B'
		ADD		R7, R6,	#0x36
		STRB		R3, [R4]
		MOV		R3, #0x4D ; 'M'
		STRB		R3, [R4,#1]
		ADD		R0, R4,	#2
		MOV		R1, R7
		BL		sub_10518C

		MOV		R3, #0x28 ; '('
		STRB		R5, [R4,#0xA]
		MOV		R5, #0
		STRB		R3, [R4,#0xE]
		ADD		R0, R4,	#0x12
		MOV		R1, R10
		STRB		R5, [R4,#0xB]
		STRB		R5, [R4,#0xC]
		STRB		R5, [R4,#0xD]
		STRB		R5, [R4,#0xF]
		STRB		R5, [R4,#0x10]
		STRB		R5, [R4,#0x11]
		BL		sub_10518C

		ADD		R0, R4,	#0x16
		MOV		R1, R8
		BL		sub_10518C

		MOV		R3, #1
		STRB		R3, [R4,#0x1A]
		MOV		R3, #0x18
		MOV		R1, R6
		STRB		R3, [R4,#0x1C]
		ADD		R0, R4,	#0x22
		STRB		R5, [R4,#0x1B]
		STRB		R5, [R4,#0x1D]
		BL		sub_10518C

		MOV		R12, #0x12
		MOV		R2, #0xB
		STRB		R12, [R4,#0x26]
		STRB		R2, [R4,#0x27]
		STRB		R5, [R4,#0x28]
		STRB		R5, [R4,#0x29]
		STRB		R12, [R4,#0x2A]
		STRB		R2, [R4,#0x2B]
		STRB		R5, [R4,#0x2C]
		STRB		R5, [R4,#0x2D]
		MOV		R0, R9	; filename
		MOV		R1, #7	; mode
		BL		create_file

		SUBS		R6, R0,	#0
		LDMLEFD		SP!, {R4-R10,PC}

		MOV		R1, R5
		MOV		R2, R4
		MOV		R3, R7
		BL		FSFile_Write

		MOV		R0, R6
		LDMFD		SP!, {R4-R10,LR}
		B		j_FSFile_Close

; End of function write_to_file


; =============== S U B	R O U T	I N E =======================================


sub_1052C4				; CODE XREF: create_screenshot+A0p
					; create_screenshot+10Cp

arg_0		=  0
arg_4		=  4

		STMFD		SP!, {R4-R11,LR}
		LDR		R4, [SP,#0x24+arg_4]
		LDR		R10, [SP,#0x24+arg_0]
		ANDS		R4, R4,	#0xF
		MOVEQ		R8, #4
		BEQ		loc_1052E8

		CMP		R4, #1
		MOVEQ		R8, #3
		MOVNE		R8, #2


loc_1052E8				; CODE XREF: sub_1052C4+14j
		ADD		R9, R1,	R1,LSL#1
		ADD		R0, R0,	#3
		ADD		R3, R3,	#2
		MOV		R6, #0


loc_1052F8				; CODE XREF: sub_1052C4+128j
		CMP		R6, R2
		BGE		locret_1053F0

		MOV		LR, R3
		MOV		R12, R0
		MOV		R7, #0


loc_10530C				; CODE XREF: sub_1052C4+118j
		CMP		R7, R1
		BGE		loc_1053E0

		CMP		R4, #0
		BEQ		loc_105324

		CMP		R4, #1
		BNE		loc_10533C


loc_105324				; CODE XREF: sub_1052C4+54j
		LDRB		R5, [LR,#-2]
		STRB		R5, [R12,#-3]
		LDRB		R5, [LR,#-1]
		STRB		R5, [R12,#-2]
		LDRB		R5, [LR]
		B		loc_1053CC

; ---------------------------------------------------------------------------

loc_10533C				; CODE XREF: sub_1052C4+5Cj
		CMP		R4, #2
		BNE		loc_105364

		LDRB		R11, [LR,#-1]
		LDRB		R5, [LR,#-2]
		ORR		R5, R5,	R11,LSL#8
		MOV		R11, R5,LSL#3
		STRB		R11, [R12,#-3]
		MOV		R11, R5,LSR#3
		BIC		R11, R11, #3
		B		loc_10538C

; ---------------------------------------------------------------------------

loc_105364				; CODE XREF: sub_1052C4+7Cj
		CMP		R4, #3
		BNE		loc_10539C

		LDRB		R11, [LR,#-1]
		LDRB		R5, [LR,#-2]
		ORR		R5, R5,	R11,LSL#8
		MOV		R11, R5,LSL#2
		BIC		R11, R11, #7
		STRB		R11, [R12,#-3]
		MOV		R11, R5,LSR#3
		BIC		R11, R11, #7


loc_10538C				; CODE XREF: sub_1052C4+9Cj
		MOV		R5, R5,LSR#8
		STRB		R11, [R12,#-2]
		BIC		R5, R5,	#7
		B		loc_1053CC

; ---------------------------------------------------------------------------

loc_10539C				; CODE XREF: sub_1052C4+A4j
		CMP		R4, #4
		BNE		loc_1053D0

		LDRB		R11, [LR,#-1]
		LDRB		R5, [LR,#-2]
		ORR		R5, R5,	R11,LSL#8
		BIC		R11, R5, #0xF
		STRB		R11, [R12,#-3]
		MOV		R11, R5,LSR#4
		MOV		R5, R5,LSR#8
		BIC		R5, R5,	#0xF
		BIC		R11, R11, #0xF
		STRB		R11, [R12,#-2]


loc_1053CC				; CODE XREF: sub_1052C4+74j
					; sub_1052C4+D4j
		STRB		R5, [R12,#-1]


loc_1053D0				; CODE XREF: sub_1052C4+DCj
		ADD		R7, R7,	#1
		ADD		R12, R12, #3
		ADD		LR, LR,	R10
		B		loc_10530C

; ---------------------------------------------------------------------------

loc_1053E0				; CODE XREF: sub_1052C4+4Cj
		ADD		R6, R6,	#1
		ADD		R0, R0,	R9
		ADD		R3, R3,	R8
		B		loc_1052F8

; ---------------------------------------------------------------------------

locret_1053F0				; CODE XREF: sub_1052C4+38j
		LDMFD		SP!, {R4-R11,PC}

; End of function sub_1052C4


; =============== S U B	R O U T	I N E =======================================


; int get_screenshot_index(void)
get_screenshot_index			; CODE XREF: init_builtin_screenshot_plugin+38p
		STMFD		SP!, {R4,LR}
		MOV		R4, #0
		SUB		SP, SP,	#0x40


loc_105400				; CODE XREF: get_screenshot_index+38j
		MOV		R0, SP
		LDR		R1, =aTop_04d_bmp ; "/top_%04d.bmp"
		MOV		R2, R4
		BL		xsprintf

		MOV		R0, SP	; filename
		MOV		R1, #3	; mode
		BL		create_file

		CMP		R0, #0
		BLE		loc_105430

		BL		j_FSFile_Close

		ADD		R4, R4,	#1
		B		loc_105400

; ---------------------------------------------------------------------------

loc_105430				; CODE XREF: get_screenshot_index+2Cj
		MOV		R0, R4
		ADD		SP, SP,	#0x40
		LDMFD		SP!, {R4,PC}

; End of function get_screenshot_index

; ---------------------------------------------------------------------------
off_10543C	DCD aTop_04d_bmp	; DATA XREF: get_screenshot_index+10r
					; "/top_%04d.bmp"

; =============== S U B	R O U T	I N E =======================================


; int create_screenshot(void)
create_screenshot			; CODE XREF: create_screenshot_callback+6Cp

var_78		= -0x78
var_74		= -0x74
var_70		= -0x70
var_6C		= -0x6C
var_68		= -0x68
var_64		= -0x64
var_60		= -0x60
var_20		= -0x20

		STMFD		SP!, {R4-R9,LR}
		SUB		SP, SP,	#0x5C
		LDR		R4, =p_screenshot_buf
		LDR		R0, [R4]
		CMP		R0, #0
		BEQ		loc_10558C

		LDR		R8, =va_mapped_io_PDC
		ADD		R0, R0,	#0x50000 ; dst
		LDR		R3, [R8]
		LDR		R2, [R3,#0x468]
		ADD		R2, R2,	#0xC0000000
		STR		R2, [SP,#0x78+var_70]
		LDR		R2, [R3,#0x46C]
		ADD		R2, R2,	#0xC0000000
		STR		R2, [SP,#0x78+var_6C]
		LDR		R2, [R3,#0x568]
		ADD		R2, R2,	#0xC0000000
		STR		R2, [SP,#0x78+var_68]
		LDR		R2, [R3,#0x56C]
		LDR		R7, [R3,#0x470]
		LDR		R5, [R3,#0x570]
		LDR		R9, [R3,#0x490]
		LDR		R6, [R3,#0x590]
		LDR		R3, [R3,#0x478]
		ADD		R2, R2,	#0xC0000000
		AND		R3, R3,	#1
		STR		R2, [SP,#0x78+var_64]
		ADD		R2, SP,	#0x78+var_20
		ADD		R3, R2,	R3,LSL#2
		LDR		R2, =0x46500 ; number of pixels
		LDR		R1, [R3,#-0x50]	; src
		BL		arm11k_memcpy

		LDR		R3, [R4]
		STR		R7, [SP,#0x78+var_74]
		LDR		R7, =bmp_idx
		ADD		R0, R3,	#0x36
		MOV		R1, #0x190
		ADD		R3, R3,	#0x50000
		MOV		R2, #0xF0 ; 'ð'
		STR		R9, [SP,#0x78+var_78]
		BL		sub_1052C4

		ADD		R0, SP,	#0x78+var_60
		LDR		R1, =aTop_04d_bmp ; "/top_%04d.bmp"
		LDR		R2, [R7]
		BL		xsprintf

		LDR		R0, [R4]
		MOV		R1, #0x190
		MOV		R2, #0xF0 ; 'ð'
		ADD		R3, SP,	#0x78+var_60
		BL		write_to_file

		LDR		R3, [R8]
		ADD		R2, SP,	#0x78+var_20
		LDR		R0, [R4]
		LDR		R3, [R3,#0x578]
		ADD		R0, R0,	#0x50000 ; dst
		AND		R3, R3,	#1
		ADD		R3, R2,	R3,LSL#2
		MOV		R2, #0x38400 ; number of pixels
		LDR		R1, [R3,#-0x48]	; src
		BL		arm11k_memcpy

		LDR		R3, [R4]
		MOV		R1, #0x140
		ADD		R0, R3,	#0x36
		MOV		R2, #0xF0 ; 'ð'
		ADD		R3, R3,	#0x50000
		STR		R6, [SP,#0x78+var_78]
		STR		R5, [SP,#0x78+var_74]
		BL		sub_1052C4

		ADD		R0, SP,	#0x78+var_60
		LDR		R1, =aBot_04d_bmp ; "/bot_%04d.bmp"
		LDR		R2, [R7]
		BL		xsprintf

		ADD		R3, SP,	#0x78+var_60
		LDR		R0, [R4]
		MOV		R1, #0x140
		MOV		R2, #0xF0 ; 'ð'
		BL		write_to_file

		MOV		R0, #0x64 ; 'd'
		LDR		R1, =0x1FF00FF
		BL		lcd_solid_fill

		LDR		R3, [R7]
		ADD		R3, R3,	#1
		STR		R3, [R7]


loc_10558C				; CODE XREF: create_screenshot+14j
		ADD		SP, SP,	#0x5C
		LDMFD		SP!, {R4-R9,PC}

; End of function create_screenshot

; ---------------------------------------------------------------------------
off_105594	DCD p_screenshot_buf	; DATA XREF: create_screenshot+8r
off_105598	DCD va_mapped_io_PDC	; DATA XREF: create_screenshot+18r
; unsigned int count
count		DCD 0x46500		; DATA XREF: create_screenshot+74r
off_1055A0	DCD bmp_idx		; DATA XREF: create_screenshot+88r
off_1055A4	DCD aTop_04d_bmp	; DATA XREF: create_screenshot+A8r
					; "/top_%04d.bmp"
off_1055A8	DCD aBot_04d_bmp	; DATA XREF: create_screenshot+114r
					; "/bot_%04d.bmp"
dword_1055AC	DCD 0x1FF00FF		; DATA XREF: create_screenshot+138r

; =============== S U B	R O U T	I N E =======================================


create_screenshot_callback		; DATA XREF: init_builtin_screenshot_plugin+10o
					; ROM:callbacko

var_14		= -0x14

		STMFD		SP!, {R0-R2,R4,R5,LR}
		LDR		R4, =p_screenshot_buf
		LDR		R3, [R4]
		CMP		R3, #0
		BNE		loc_1055E0

		MOV		R0, #0x100000 ;	size
		BL		plgRequestMemory

		MOV		R5, R0
		MOV		R1, R5
		LDR		R0, =aOut_addr08x ; "    out_addr: %08x"
		BL		nsDbgPrint

		STR		R5, [R4]


loc_1055E0				; CODE XREF: create_screenshot_callback+10j
		MOV		R3, #0


loc_1055E4				; CODE XREF: create_screenshot_callback+48j
		STR		R3, [SP,#0x18+var_14]
		LDR		R3, [SP,#0x18+var_14]
		CMP		R3, #0x1000000
		LDRCC		R3, [SP,#0x18+var_14]
		ADDCC		R3, R3,	#1
		BCC		loc_1055E4

		MOV		R1, #0	; arg1
		MOV		R2, R1	; arg2
		MOV		R3, R1	; arg3
		MOV		R0, #2	; cmd
		BL		controlVideo ;
					; #define CONTROLVIDEO_ACQUIREVIDEO 1
					; #define CONTROLVIDEO_RELEASEVIDEO 2
					; #define CONTROLVIDEO_GETFRAMEBUFFER 3
					; #define CONTROLVIDEO_SETFRAMEBUFFER 4
					; #define CONTROLVIDEO_UPDATESCREEN 5
					;
					;
					; this code is messy since it corrupts memory
					; at N3DS physical memory 0x1F000000

		LDR		R0, =0x5F5E100
		MOV		R1, #0
		BL		SleepThread

		BL		create_screenshot

		MOV		R1, #0	; arg1
		MOV		R2, R1	; arg2
		MOV		R3, R1	; arg3
		MOV		R0, #1	; cmd
		BL		controlVideo ;
					; #define CONTROLVIDEO_ACQUIREVIDEO 1
					; #define CONTROLVIDEO_RELEASEVIDEO 2
					; #define CONTROLVIDEO_GETFRAMEBUFFER 3
					; #define CONTROLVIDEO_SETFRAMEBUFFER 4
					; #define CONTROLVIDEO_UPDATESCREEN 5
					;
					;
					; this code is messy since it corrupts memory
					; at N3DS physical memory 0x1F000000

		MOV		R0, #1
		ADD		SP, SP,	#0xC
		LDMFD		SP!, {R4,R5,PC}

; End of function create_screenshot_callback

; ---------------------------------------------------------------------------
off_105640	DCD p_screenshot_buf	; DATA XREF: create_screenshot_callback+4r
off_105644	DCD aOut_addr08x	; DATA XREF: create_screenshot_callback+24r
					; "    out_addr: %08x"
dword_105648	DCD 0x5F5E100		; DATA XREF: create_screenshot_callback+60r

; =============== S U B	R O U T	I N E =======================================


init_builtin_screenshot_plugin		; CODE XREF: thread_NTR_home_injectee+D0p
		STMFD		SP!, {R4,LR}
		LDR		R0, =aInitializingSc ; "initializing screenshot plugin\n"
		LDR		R4, =hFSUser
		BL		nsDbgPrint

		LDR		R2, =create_screenshot_callback	; callback
		LDR		R1, =aTakeScreenshot ; "Take Screenshot"
		MOV		R0, #1	; catalog
		BL		plgRegisterMenuEntry

		MOV		R1, R4
		LDR		R0, =aFsUser ; "fs:USER"
		BL		plgGetSharedServiceHandle

		LDR		R1, [R4]
		LDR		R0, =aFsuserhandle08 ; "fsUserHandle: %08x\n"
		BL		nsDbgPrint

		BL		get_screenshot_index

		LDR		R3, =bmp_idx
		MOV		R1, R0
		STR		R0, [R3]
		LDR		R0, =aBmpIndexIsD ; "bmp index is: %d"
		BL		nsDbgPrint

		LDMFD		SP!, {R4,PC}

; End of function init_builtin_screenshot_plugin

; ---------------------------------------------------------------------------
off_1056A0	DCD aInitializingSc	; DATA XREF: init_builtin_screenshot_plugin+4r
					; "initializing screenshot plugin\n"
off_1056A4	DCD hFSUser		; DATA XREF: init_builtin_screenshot_plugin+8r
; void *callback
callback	DCD create_screenshot_callback
					; DATA XREF: init_builtin_screenshot_plugin+10r
; char *title
title		DCD aTakeScreenshot	; DATA XREF: init_builtin_screenshot_plugin+14r
					; "Take Screenshot"
off_1056B0	DCD aFsUser		; DATA XREF: init_builtin_screenshot_plugin+24r
					; "fs:USER"
off_1056B4	DCD aFsuserhandle08	; DATA XREF: init_builtin_screenshot_plugin+30r
					; "fsUserHandle: %08x\n"
off_1056B8	DCD bmp_idx		; DATA XREF: init_builtin_screenshot_plugin+3Cr
off_1056BC	DCD aBmpIndexIsD	; DATA XREF: init_builtin_screenshot_plugin+48r
					; "bmp index is: %d"

; =============== S U B	R O U T	I N E =======================================


initSharedFunc				; CODE XREF: load_all_plugins_and_inject_ntr_into_pm+10p
					; init_all_plugins+4p
		LDR		R3, =p_config_memory
		LDR		R2, =showDbg
		LDR		R3, [R3]
		STR		R2, [R3,#NS_CONFIG.sharedFunc]
		LDR		R2, =nsDbgPrint
		STR		R2, [R3,#NS_CONFIG.sharedFunc+4]
		LDR		R2, =plgRegisterMenuEntry
		STR		R2, [R3,#NS_CONFIG.sharedFunc+8]
		LDR		R2, =plgGetSharedServiceHandle
		STR		R2, [R3,#NS_CONFIG.sharedFunc+0xC]
		LDR		R2, =plgRequestMemory
		STR		R2, [R3,#NS_CONFIG.sharedFunc+0x10]
		LDR		R2, =plgRegisterCallback ; not implemented
		STR		R2, [R3,#NS_CONFIG.sharedFunc+0x14]
		LDR		R2, =xsprintf
		STR		R2, [R3,#NS_CONFIG.sharedFunc+0x18]
		LDR		R2, =controlVideo ;
					; #define CONTROLVIDEO_ACQUIREVIDEO 1
					; #define CONTROLVIDEO_RELEASEVIDEO 2
					; #define CONTROLVIDEO_GETFRAMEBUFFER 3
					; #define CONTROLVIDEO_SETFRAMEBUFFER 4
					; #define CONTROLVIDEO_UPDATESCREEN 5
					;
					;
					; this code is messy since it corrupts memory
					; at N3DS physical memory 0x1F000000
		STR		R2, [R3,#NS_CONFIG.sharedFunc+0x1C]
		LDR		R2, =plgGetIoBase ; old: io_get_mapped_register_va
					;
					; u32 plgGetIoBase(u32 IoType);
					; #define IO_BASE_PAD	  1
					; #define IO_BASE_LCD	  2
					; #define IO_BASE_PDC	  3
					; #define IO_BASE_GSPHEAP 4
					;
		STR		R2, [R3,#NS_CONFIG.sharedFunc+0x20]
		BX		LR

; End of function initSharedFunc

; ---------------------------------------------------------------------------
off_105714	DCD p_config_memory	; DATA XREF: initSharedFuncr
off_105718	DCD showDbg		; DATA XREF: initSharedFunc+4r
off_10571C	DCD nsDbgPrint		; DATA XREF: initSharedFunc+10r
off_105720	DCD plgRegisterMenuEntry ; DATA	XREF: initSharedFunc+18r
off_105724	DCD plgGetSharedServiceHandle ;	DATA XREF: initSharedFunc+20r
off_105728	DCD plgRequestMemory	; DATA XREF: initSharedFunc+28r
off_10572C	DCD plgRegisterCallback	; DATA XREF: initSharedFunc+30r
					; not implemented
off_105730	DCD xsprintf		; DATA XREF: initSharedFunc+38r
off_105734	DCD controlVideo	; DATA XREF: initSharedFunc+40r
					;
					; #define CONTROLVIDEO_ACQUIREVIDEO 1
					; #define CONTROLVIDEO_RELEASEVIDEO 2
					; #define CONTROLVIDEO_GETFRAMEBUFFER 3
					; #define CONTROLVIDEO_SETFRAMEBUFFER 4
					; #define CONTROLVIDEO_UPDATESCREEN 5
					;
					;
					; this code is messy since it corrupts memory
					; at N3DS physical memory 0x1F000000
off_105738	DCD plgGetIoBase	; DATA XREF: initSharedFunc+48r
					; old: io_get_mapped_register_va
					;
					; u32 plgGetIoBase(u32 IoType);
					; #define IO_BASE_PAD	  1
					; #define IO_BASE_LCD	  2
					; #define IO_BASE_PDC	  3
					; #define IO_BASE_GSPHEAP 4
					;

; =============== S U B	R O U T	I N E =======================================


SOC_GetErrno				; CODE XREF: socket+5Cp close+44p ...
		CMP		R0, #0
		BXGE		LR

		CMN		R0, #0x4E ; 'N'
		BLS		loc_105760

		LDR		R2, =unk_109AF0
		RSB		R3, R0,	#0
		LDRB		R3, [R2,R3]
		CMP		R3, #0
		BNE		loc_10576C


loc_105760				; CODE XREF: SOC_GetErrno+Cj
		SUB		R0, R0,	#0x2700
		SUB		R0, R0,	#0x10
		BX		LR

; ---------------------------------------------------------------------------

loc_10576C				; CODE XREF: SOC_GetErrno+20j
		RSB		R0, R3,	#0
		BX		LR

; End of function SOC_GetErrno

; ---------------------------------------------------------------------------
off_105774	DCD unk_109AF0		; DATA XREF: SOC_GetErrno+10r

; =============== S U B	R O U T	I N E =======================================


SOC_InitializeSockets			; CODE XREF: SOC_Initialize+54p
		STMFD		SP!, {R4-R6,LR}
		MOV		R6, R1
		MOV		R5, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0x10044
		STMIA		R0, {R3,R6}
		MOV		R3, #0x20 ; ' '
		STR		R3, [R0,#8]
		MOV		R3, #0
		STR		R3, [R0,#0x10]
		LDR		R3, =hSession
		MOV		R4, R0
		STR		R5, [R0,#0x14]
		LDR		R0, [R3]
		BL		SendSyncRequest

		CMP		R0, #0
		LDREQ		R0, [R4,#4]
		LDMFD		SP!, {R4-R6,PC}

; End of function SOC_InitializeSockets

; ---------------------------------------------------------------------------
dword_1057C0	DCD 0x10044		; DATA XREF: SOC_InitializeSockets+10r
off_1057C4	DCD hSession		; DATA XREF: SOC_InitializeSockets+28r
; ---------------------------------------------------------------------------
		STMFD		SP!, {R3-R5,LR}
		BL		read_tid_and_pid_reg

		LDR		R5, =hSession
		MOV		R3, #0x190000
		STR		R3, [R0]
		MOV		R4, R0
		LDR		R0, [R5]
		BL		SendSyncRequest

		CMP		R0, #0
		LDMNEFD		SP!, {R3-R5,PC}

		LDR		R0, [R5]
		BL		CloseHandle

		LDR		R0, [R4,#4]
		LDMFD		SP!, {R3-R5,PC}

; ---------------------------------------------------------------------------
off_105800	DCD hSession		; DATA XREF: ROM:001057D0r

; =============== S U B	R O U T	I N E =======================================


SOC_Initialize				; CODE XREF: setup_ntr_network_server+B0p

var_18		= -0x18
var_C		= -0xC
var_8		= -8

		STMFD		SP!, {R0-R4,LR}
		MOV		R2, R0
		ADD		R0, SP,	#0x18+var_8
		MOV		R3, #0
		MOV		R4, R1
		MOV		R1, #3
		STR		R3, [R0,#-4]!
		STR		R1, [SP,#0x18+var_18]
		MOV		R1, R2
		MOV		R2, R4
		BL		CreateMemoryBlock

		SUBS		R3, R0,	#0
		MOVNE		R0, R3
		BNE		loc_10585C

		LDR		R1, =hSession
		LDR		R2, =aSocU ; "soc:U"
		BL		get_service_session_handle

		CMP		R0, #0
		BNE		loc_10585C

		LDR		R0, [SP,#0x18+var_C]
		MOV		R1, R4
		BL		SOC_InitializeSockets


loc_10585C				; CODE XREF: SOC_Initialize+34j
					; SOC_Initialize+48j
		ADD		SP, SP,	#0x10
		LDMFD		SP!, {R4,PC}

; End of function SOC_Initialize

; ---------------------------------------------------------------------------
off_105864	DCD hSession		; DATA XREF: SOC_Initialize+38r
off_105868	DCD aSocU		; DATA XREF: SOC_Initialize+3Cr
					; "soc:U"

; =============== S U B	R O U T	I N E =======================================


sub_10586C				; CODE XREF: recv_+44p	sub_104C40+40p
		LDR		R3, =hSession
		LDR		R0, [R3,#(dword_10B0C0 - 0x10B0BC)]
		BX		LR

; End of function sub_10586C

; ---------------------------------------------------------------------------
off_105878	DCD hSession		; DATA XREF: sub_10586Cr

; =============== S U B	R O U T	I N E =======================================


socket					; CODE XREF: handle_network_client+14p
		STMFD		SP!, {R3-R7,LR}
		MOV		R5, R2
		MOV		R6, R1
		MOV		R7, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0x200C2
		STR		R5, [R0,#0xC]
		LDR		R5, =hSession
		STMIA		R0, {R3,R7}
		MOV		R3, #0x20 ; ' '
		STR		R6, [R0,#8]
		STR		R3, [R0,#0x10]
		MOV		R4, R0
		LDR		R0, [R5]
		BL		SendSyncRequest

		CMP		R0, #0
		LDMNEFD		SP!, {R3-R7,PC}

		LDR		R3, [R4,#4]
		CMP		R3, #0
		STR		R3, [R5,#4]
		BNE		loc_1058DC

		LDR		R0, [R4,#8]
		LDMFD		SP!, {R3-R7,LR}
		B		SOC_GetErrno

; ---------------------------------------------------------------------------

loc_1058DC				; CODE XREF: socket+50j
		MOV		R0, #0xFFFFFFFF
		LDMFD		SP!, {R3-R7,PC}

; End of function socket

; ---------------------------------------------------------------------------
dword_1058E4	DCD 0x200C2		; DATA XREF: socket+14r
off_1058E8	DCD hSession		; DATA XREF: socket+1Cr

; =============== S U B	R O U T	I N E =======================================


close					; CODE XREF: handle_reload_packet+28p
					; handle_reload_packet+38p ...
		STMFD		SP!, {R3-R5,LR}
		MOV		R5, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0xB0042
		STMIA		R0, {R3,R5}
		LDR		R5, =hSession
		MOV		R3, #0x20 ; ' '
		STR		R3, [R0,#8]
		MOV		R4, R0
		LDR		R0, [R5]
		BL		SendSyncRequest

		CMP		R0, #0
		LDMNEFD		SP!, {R3-R5,PC}

		LDR		R0, [R4,#4]
		CMP		R0, #0
		BNE		loc_105934

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno


loc_105934				; CODE XREF: close+3Cj
		STR		R0, [R5,#4]
		MOVS		R0, R0
		MOVNE		R0, #0xFFFFFFFF
		LDMFD		SP!, {R3-R5,PC}

; End of function close

; ---------------------------------------------------------------------------
dword_105944	DCD 0xB0042		; DATA XREF: close+Cr
off_105948	DCD hSession		; DATA XREF: close+14r
; ---------------------------------------------------------------------------
		STMFD		SP!, {R4-R6,LR}
		MOV		R5, R1
		MOV		R6, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0xC0082
		STR		R5, [R0,#8]
		LDR		R5, =hSession
		STMIA		R0, {R3,R6}
		MOV		R3, #0x20 ; ' '
		STR		R3, [R0,#0xC]
		MOV		R4, R0
		LDR		R0, [R5]
		BL		SendSyncRequest

		CMP		R0, #0
		LDMNEFD		SP!, {R4-R6,PC}

		LDR		R0, [R4,#4]
		CMP		R0, #0
		BNE		loc_10599C

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno


loc_10599C				; CODE XREF: ROM:00105990j
		STR		R0, [R5,#4]
		MOVS		R0, R0
		MOVNE		R0, #0xFFFFFFFF
		LDMFD		SP!, {R4-R6,PC}

; ---------------------------------------------------------------------------
dword_1059AC	DCD 0xC0082		; DATA XREF: ROM:0010595Cr
off_1059B0	DCD hSession		; DATA XREF: ROM:00105964r

; =============== S U B	R O U T	I N E =======================================


listen_					; CODE XREF: handle_network_client+7Cp
		STMFD		SP!, {R4-R6,LR}
		MOV		R5, R1
		MOV		R6, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0x30082
		STR		R5, [R0,#8]
		LDR		R5, =hSession
		STMIA		R0, {R3,R6}
		MOV		R3, #0x20 ; ' '
		STR		R3, [R0,#0xC]
		MOV		R4, R0
		LDR		R0, [R5]
		BL		SendSyncRequest

		CMP		R0, #0
		LDMNEFD		SP!, {R4-R6,PC}

		LDR		R0, [R4,#4]
		CMP		R0, #0
		BNE		loc_105A04

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno


loc_105A04				; CODE XREF: listen_+44j
		STR		R0, [R5,#4]
		MOVS		R0, R0
		MOVNE		R0, #0xFFFFFFFF
		LDMFD		SP!, {R4-R6,PC}

; End of function listen_

; ---------------------------------------------------------------------------
dword_105A14	DCD 0x30082		; DATA XREF: listen_+10r
off_105A18	DCD hSession		; DATA XREF: listen_+18r

; =============== S U B	R O U T	I N E =======================================


accept					; CODE XREF: handle_network_client+F4p

var_44		= -0x44
var_43		= -0x43

		STMFD		SP!, {R4-R11,LR}
		SUB		SP, SP,	#0x24
		MOV		R6, R0
		MOV		R8, R1
		MOV		R9, R2
		BL		read_tid_and_pid_reg

		ADD		R7, SP,	#0x48+var_44
		MOV		R4, #0x1C
		MOV		R1, #0
		MOV		R2, R4
		MOV		R5, R0
		MOV		R0, R7
		BL		memset_

		LDR		R3, =0x40082
		LDR		R11, [R5,#0x100]
		LDR		R10, [R5,#0x104]
		STMIA		R5, {R3,R6}
		MOV		R3, #0x20 ; ' '
		LDR		R6, =hSession
		STR		R3, [R5,#0xC]
		LDR		R3, =0x70002
		STR		R4, [R5,#8]
		STR		R3, [R5,#0x100]
		STR		R7, [R5,#0x104]
		LDR		R0, [R6]
		BL		SendSyncRequest

		CMP		R0, #0
		BNE		loc_105B0C

		LDR		R4, [R5,#4]
		STR		R11, [R5,#0x100]
		CMP		R4, #0
		STR		R10, [R5,#0x104]
		BNE		loc_105AAC

		LDR		R0, [R5,#8]
		BL		SOC_GetErrno

		MOV		R4, R0


loc_105AAC				; CODE XREF: accept+80j
		CMP		R4, #0
		MVN		R3, R4
		STRLT		R4, [R6,#4]
		CMP		R8, #0
		MOV		R3, R3,LSR#31
		MOVEQ		R3, #0
		CMP		R3, #0
		BEQ		loc_105B00

		LDRB		R3, [SP,#0x48+var_43]
		LDR		R2, [R9]
		ADD		R0, R8,	#2
		STRH		R3, [R8]
		LDRB		R3, [SP,#0x48+var_44]
		ADD		R1, R7,	#2
		CMP		R2, R3
		STRGT		R3, [R9]
		LDR		R2, [R9]
		SUB		R2, R2,	#2
		BL		memcpy

		MOV		R0, R4
		B		loc_105B0C

; ---------------------------------------------------------------------------

loc_105B00				; CODE XREF: accept+ACj
		CMP		R4, #0
		MOVGE		R0, R4
		MOVLT		R0, #0xFFFFFFFF


loc_105B0C				; CODE XREF: accept+6Cj accept+E0j
		ADD		SP, SP,	#0x24
		LDMFD		SP!, {R4-R11,PC}

; End of function accept

; ---------------------------------------------------------------------------
dword_105B14	DCD 0x40082		; DATA XREF: accept+34r
off_105B18	DCD hSession		; DATA XREF: accept+48r
dword_105B1C	DCD 0x70002		; DATA XREF: accept+50r

; =============== S U B	R O U T	I N E =======================================


bind_					; CODE XREF: handle_network_client+64p

var_3C		= -0x3C
var_3B		= -0x3B

		STMFD		SP!, {R4-R9,LR}
		SUB		SP, SP,	#0x24
		MOV		R6, R2
		MOV		R8, R1
		MOV		R9, R0
		BL		read_tid_and_pid_reg

		ADD		R7, SP,	#0x40+var_3C
		MOV		R1, #0
		MOV		R2, #0x1C
		MOV		R5, R0
		MOV		R0, R7
		BL		memset_

		LDRH		R3, [R8]
		CMP		R3, #2
		MOVEQ		R4, #8
		MOVNE		R4, #0x1C
		CMP		R6, R4
		LDR		R6, =hSession
		MOVLT		R3, #0xFFFFFFEA
		MOVLT		R0, #0xFFFFFFFF
		STRLT		R3, [R6,#(dword_10B0C0 - 0x10B0BC)]
		BLT		loc_105BE0

		SUB		R2, R4,	#2
		ADD		R1, R8,	#2
		ADD		R0, R7,	#2
		STRB		R4, [SP,#0x40+var_3C]
		STRB		R3, [SP,#0x40+var_3B]
		BL		memcpy

		LDR		R3, =0x50084
		STR		R4, [R5,#8]
		MOV		R4, R4,LSL#14
		STMIA		R5, {R3,R9}
		ORR		R4, R4,	#2
		MOV		R3, #0x20 ; ' '
		STR		R3, [R5,#0xC]
		STR		R4, [R5,#0x14]
		STR		R7, [R5,#0x18]
		LDR		R0, [R6]
		BL		SendSyncRequest

		CMP		R0, #0
		BNE		loc_105BE0

		LDR		R0, [R5,#4]
		CMP		R0, #0
		BNE		loc_105BD8

		LDR		R0, [R5,#8]
		BL		SOC_GetErrno


loc_105BD8				; CODE XREF: bind_+ACj
		STR		R0, [R6,#4]
		MOV		R0, R0,ASR#31


loc_105BE0				; CODE XREF: bind_+54j	bind_+A0j
		ADD		SP, SP,	#0x24
		LDMFD		SP!, {R4-R9,PC}

; End of function bind_

; ---------------------------------------------------------------------------
off_105BE8	DCD hSession		; DATA XREF: bind_+44r
dword_105BEC	DCD 0x50084		; DATA XREF: bind_+70r

; =============== S U B	R O U T	I N E =======================================


sub_105BF0

var_3C		= -0x3C
var_3B		= -0x3B

		STMFD		SP!, {R4-R10,LR}
		SUB		SP, SP,	#0x20
		MOV		R9, R1
		MOV		R8, R2
		MOV		R10, R0
		BL		read_tid_and_pid_reg

		ADD		R7, SP,	#0x40+var_3C
		MOV		R1, #0
		MOV		R2, #0x1C
		LDR		R6, =hSession
		MOV		R4, R0
		MOV		R0, R7
		BL		memset_

		LDRH		R3, [R9]
		CMP		R3, #2
		MOVEQ		R5, #8
		MOVNE		R5, #0x1C
		CMP		R8, R5
		MOVLT		R3, #0xFFFFFFEA
		STRLT		R3, [R6,#(dword_10B0C0 - 0x10B0BC)]
		MOVLT		R0, #0xFFFFFFFF
		BLT		loc_105CB0

		SUB		R2, R5,	#2
		ADD		R1, R9,	#2
		ADD		R0, R7,	#2
		STRB		R5, [SP,#0x40+var_3C]
		STRB		R3, [SP,#0x40+var_3B]
		BL		memcpy

		LDR		R3, =0x60084
		MOV		R5, R5,LSL#14
		ORR		R5, R5,	#2
		STMIA		R4, {R3,R10}
		MOV		R3, #0x20 ; ' '
		STR		R8, [R4,#8]
		STR		R3, [R4,#0xC]
		STR		R5, [R4,#0x14]
		STR		R7, [R4,#0x18]
		LDR		R0, [R6]
		BL		SendSyncRequest

		CMP		R0, #0
		BNE		loc_105CB0

		LDR		R0, [R4,#4]
		CMP		R0, #0
		BNE		loc_105CA8

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno


loc_105CA8				; CODE XREF: sub_105BF0+ACj
		STR		R0, [R6,#4]
		MOV		R0, R0,ASR#31


loc_105CB0				; CODE XREF: sub_105BF0+54j
					; sub_105BF0+A0j
		ADD		SP, SP,	#0x20
		LDMFD		SP!, {R4-R10,PC}

; End of function sub_105BF0

; ---------------------------------------------------------------------------
off_105CB8	DCD hSession		; DATA XREF: sub_105BF0+24r
dword_105CBC	DCD 0x60084		; DATA XREF: sub_105BF0+70r

; =============== S U B	R O U T	I N E =======================================


recvfrom_other				; CODE XREF: _recvfrom_wrapper+28p

var_44		= -0x44
var_43		= -0x43
arg_0		=  0
arg_4		=  4

		STMFD		SP!, {R4-R11,LR}
		SUB		SP, SP,	#0x24
		MOV		R10, R3
		MOV		R9, R1
		MOV		R5, R2
		MOV		R11, R0
		LDR		R6, [SP,#0x48+arg_0]
		LDR		R8, [SP,#0x48+arg_4]
		BL		read_tid_and_pid_reg

		ADD		R7, SP,	#0x48+var_44
		MOV		R1, #0
		MOV		R2, #0x1C
		MOV		R4, R0
		MOV		R0, R7
		BL		memset_

		CMP		R6, #0
		MOVNE		R12, #0x1C
		MOVEQ		R12, #0
		LDR		R3, =0x70104
		STR		R9, [R4,#0x20]
		LDR		R9, =hSession
		STR		R5, [R4,#8]
		MOV		R5, R5,LSL#4
		STMIA		R4, {R3,R11}
		ORR		R5, R5,	#0xC
		MOV		R3, #0x20 ; ' '
		STR		R10, [R4,#0xC]
		LDR		R11, [R4,#0x100]
		LDR		R10, [R4,#0x104]
		STR		R3, [R4,#0x14]
		STR		R5, [R4,#0x1C]
		STR		R7, [R4,#0x104]
		LDR		R0, [R9]
		STR		R12, [R4,#0x10]
		MOV		R12, R12,LSL#14
		ORR		R12, R12, #2
		STR		R12, [R4,#0x100]
		BL		SendSyncRequest

		CMP		R0, #0
		BNE		loc_105DD4

		LDR		R5, [R4,#4]
		STR		R11, [R4,#0x100]
		CMP		R5, #0
		STR		R10, [R4,#0x104]
		BNE		loc_105D80

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno

		MOV		R5, R0


loc_105D80				; CODE XREF: recvfrom_other+B0j
		CMP		R5, #0
		STRLT		R5, [R9,#4]
		CMP		R6, #0
		CMPNE		R5, #0
		BLE		loc_105DC8

		LDRB		R3, [SP,#0x48+var_43]
		LDR		R2, [R8]
		ADD		R0, R6,	#2
		STRH		R3, [R6]
		LDRB		R3, [SP,#0x48+var_44]
		ADD		R1, R7,	#2
		CMP		R2, R3
		STRGT		R3, [R8]
		LDR		R2, [R8]
		SUB		R2, R2,	#2
		BL		memcpy

		MOV		R0, R5
		B		loc_105DD4

; ---------------------------------------------------------------------------

loc_105DC8				; CODE XREF: recvfrom_other+D0j
		CMP		R5, #0
		MOVGE		R0, R5
		MOVLT		R0, #0xFFFFFFFF


loc_105DD4				; CODE XREF: recvfrom_other+9Cj
					; recvfrom_other+104j
		ADD		SP, SP,	#0x24
		LDMFD		SP!, {R4-R11,PC}

; End of function recvfrom_other

; ---------------------------------------------------------------------------
dword_105DDC	DCD 0x70104		; DATA XREF: recvfrom_other+48r
off_105DE0	DCD hSession		; DATA XREF: recvfrom_other+50r

; =============== S U B	R O U T	I N E =======================================


recvfrom				; CODE XREF: _recvfrom_wrapper+18p

var_54		= -0x54
var_50		= -0x50
var_4C		= -0x4C
var_44		= -0x44
var_43		= -0x43
arg_0		=  0
arg_4		=  4

		STMFD		SP!, {R4-R11,LR}
		SUB		SP, SP,	#0x34
		MOV		R10, R3
		MOV		R6, R2
		MOV		R11, R0
		STR		R1, [SP,#0x58+var_4C]
		LDR		R7, [SP,#0x58+arg_0]
		LDR		R9, [SP,#0x58+arg_4]
		BL		read_tid_and_pid_reg

		ADD		R8, SP,	#0x58+var_44
		CMP		R7, #0
		MOV		R1, #0
		MOV		R2, #0x1C
		MOVNE		R5, #0x1C
		MOVEQ		R5, #0
		MOV		R4, R0
		MOV		R0, R8
		BL		memset_

		LDR		R3, =0x80102
		STR		R6, [R4,#8]
		MOV		R6, R6,LSL#14
		ORR		R6, R6,	#2
		LDR		R2, [R4,#0x100]
		STR		R6, [R4,#0x100]
		LDR		R6, =hSession
		STMIA		R4, {R3,R11}
		STR		R5, [R4,#0x10]
		MOV		R3, #0x20 ; ' '
		LDR		R12, [SP,#0x58+var_4C]
		MOV		R5, R5,LSL#14
		STR		R3, [R4,#0x14]
		ORR		R5, R5,	#2
		LDR		R3, [R4,#0x104]
		STR		R10, [R4,#0xC]
		LDR		R11, [R4,#0x108]
		LDR		R10, [R4,#0x10C]
		STR		R12, [R4,#0x104]
		STR		R5, [R4,#0x108]
		STR		R8, [R4,#0x10C]
		LDR		R0, [R6]
		STR		R2, [SP,#0x58+var_50]
		STR		R3, [SP,#0x58+var_54]
		BL		SendSyncRequest

		CMP		R0, #0
		BNE		loc_105F1C

		LDR		R5, [R4,#4]
		LDR		R2, [SP,#0x58+var_50]
		LDR		R3, [SP,#0x58+var_54]
		CMP		R5, #0
		STR		R2, [R4,#0x100]
		STR		R3, [R4,#0x104]
		STR		R11, [R4,#0x108]
		STR		R10, [R4,#0x10C]
		BNE		loc_105EC8

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno

		MOV		R5, R0


loc_105EC8				; CODE XREF: recvfrom+D4j
		CMP		R5, #0
		STRLT		R5, [R6,#4]
		CMP		R7, #0
		CMPNE		R5, #0
		BLE		loc_105F10

		LDRB		R3, [SP,#0x58+var_43]
		LDR		R2, [R9]
		ADD		R0, R7,	#2
		STRH		R3, [R7]
		LDRB		R3, [SP,#0x58+var_44]
		ADD		R1, R8,	#2
		CMP		R2, R3
		STRGT		R3, [R9]
		LDR		R2, [R9]
		SUB		R2, R2,	#2
		BL		memcpy

		MOV		R0, R5
		B		loc_105F1C

; ---------------------------------------------------------------------------

loc_105F10				; CODE XREF: recvfrom+F4j
		CMP		R5, #0
		MOVGE		R0, R5
		MOVLT		R0, #0xFFFFFFFF


loc_105F1C				; CODE XREF: recvfrom+B0j
					; recvfrom+128j
		ADD		SP, SP,	#0x34
		LDMFD		SP!, {R4-R11,PC}

; End of function recvfrom

; ---------------------------------------------------------------------------
dword_105F24	DCD 0x80102		; DATA XREF: recvfrom+48r
off_105F28	DCD hSession		; DATA XREF: recvfrom+60r

; =============== S U B	R O U T	I N E =======================================


sendto_other				; CODE XREF: _sendto_wrapper+28p

var_4C		= -0x4C
var_44		= -0x44
var_43		= -0x43
arg_0		=  0
arg_4		=  4

		STMFD		SP!, {R4-R11,LR}
		SUB		SP, SP,	#0x2C
		MOV		R10, R3
		LDR		R3, [SP,#0x50+arg_0]
		MOV		R8, R1
		STR		R3, [SP,#0x50+var_4C]
		MOV		R7, R2
		MOV		R11, R0
		BL		read_tid_and_pid_reg

		ADD		R9, SP,	#0x50+var_44
		MOV		R1, #0
		MOV		R2, #0x1C
		LDR		R6, =hSession
		MOV		R4, R0
		MOV		R0, R9
		BL		memset_

		LDR		R3, [SP,#0x50+var_4C]
		CMP		R3, #0
		BEQ		loc_105FB8

		LDRH		R2, [R3]
		LDR		R1, [SP,#0x50+arg_4]
		CMP		R2, #2
		MOVEQ		R5, #8
		MOVNE		R5, #0x1C
		CMP		R1, R5
		MOVCC		R3, #0xFFFFFFEA
		STRCC		R3, [R6,#(dword_10B0C0 - 0x10B0BC)]
		BCC		loc_10602C

		STRB		R2, [SP,#0x50+var_43]
		ADD		R0, R9,	#2
		ADD		R1, R3,	#2
		SUB		R2, R5,	#2
		STRB		R5, [SP,#0x50+var_44]
		BL		memcpy

		B		loc_105FBC

; ---------------------------------------------------------------------------

loc_105FB8				; CODE XREF: sendto_other+48j
		MOV		R5, R3


loc_105FBC				; CODE XREF: sendto_other+88j
		LDR		R3, =0x90106
		STR		R5, [R4,#0x10]
		MOV		R5, R5,LSL#14
		STR		R7, [R4,#8]
		ORR		R5, R5,	#0x400
		MOV		R7, R7,LSL#4
		STMIA		R4, {R3,R11}
		ORR		R5, R5,	#2
		MOV		R3, #0x20 ; ' '
		ORR		R7, R7,	#0xA
		STR		R10, [R4,#0xC]
		STR		R3, [R4,#0x14]
		STR		R5, [R4,#0x1C]
		STR		R9, [R4,#0x20]
		STR		R7, [R4,#0x24]
		STR		R8, [R4,#0x28]
		LDR		R0, [R6]
		BL		SendSyncRequest

		CMP		R0, #0
		BNE		loc_106030

		LDR		R0, [R4,#4]
		CMP		R0, #0
		BNE		loc_106020

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno


loc_106020				; CODE XREF: sendto_other+E8j
		CMP		R0, #0
		BGE		loc_106030

		STR		R0, [R6,#4]


loc_10602C				; CODE XREF: sendto_other+6Cj
		MOV		R0, #0xFFFFFFFF


loc_106030				; CODE XREF: sendto_other+DCj
					; sendto_other+F8j
		ADD		SP, SP,	#0x2C
		LDMFD		SP!, {R4-R11,PC}

; End of function sendto_other

; ---------------------------------------------------------------------------
off_106038	DCD hSession		; DATA XREF: sendto_other+30r
dword_10603C	DCD 0x90106		; DATA XREF: sendto_other:loc_105FBCr

; =============== S U B	R O U T	I N E =======================================


sendto					; CODE XREF: _sendto_wrapper+18p

var_4C		= -0x4C
var_44		= -0x44
var_43		= -0x43
arg_0		=  0
arg_4		=  4

		STMFD		SP!, {R4-R11,LR}
		SUB		SP, SP,	#0x2C
		MOV		R10, R3
		LDR		R3, [SP,#0x50+arg_0]
		MOV		R9, R1
		STR		R3, [SP,#0x50+var_4C]
		MOV		R7, R2
		MOV		R11, R0
		BL		read_tid_and_pid_reg

		ADD		R8, SP,	#0x50+var_44
		MOV		R1, #0
		MOV		R2, #0x1C
		LDR		R6, =hSession
		MOV		R4, R0
		MOV		R0, R8
		BL		memset_

		LDR		R3, [SP,#0x50+var_4C]
		CMP		R3, #0
		BEQ		loc_1060CC

		LDRH		R2, [R3]
		LDR		R1, [SP,#0x50+arg_4]
		CMP		R2, #2
		MOVEQ		R5, #8
		MOVNE		R5, #0x1C
		CMP		R1, R5
		MOVCC		R3, #0xFFFFFFEA
		STRCC		R3, [R6,#(dword_10B0C0 - 0x10B0BC)]
		BCC		loc_106144

		STRB		R2, [SP,#0x50+var_43]
		ADD		R0, R8,	#2
		ADD		R1, R3,	#2
		SUB		R2, R5,	#2
		STRB		R5, [SP,#0x50+var_44]
		BL		memcpy

		B		loc_1060D0

; ---------------------------------------------------------------------------

loc_1060CC				; CODE XREF: sendto+48j
		MOV		R5, R3


loc_1060D0				; CODE XREF: sendto+88j
		LDR		R3, =0xA0106
		STR		R7, [R4,#8]
		STR		R5, [R4,#0x10]
		MOV		R7, R7,LSL#14
		MOV		R5, R5,LSL#14
		ORR		R7, R7,	#0x800
		ORR		R5, R5,	#0x400
		STMIA		R4, {R3,R11}
		ORR		R7, R7,	#2
		MOV		R3, #0x20 ; ' '
		ORR		R5, R5,	#2
		STR		R10, [R4,#0xC]
		STR		R3, [R4,#0x14]
		STR		R7, [R4,#0x1C]
		STR		R9, [R4,#0x20]
		STR		R5, [R4,#0x24]
		STR		R8, [R4,#0x28]
		LDR		R0, [R6]
		BL		SendSyncRequest

		CMP		R0, #0
		BNE		loc_106148

		LDR		R0, [R4,#4]
		CMP		R0, #0
		BNE		loc_106138

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno


loc_106138				; CODE XREF: sendto+ECj
		CMP		R0, #0
		BGE		loc_106148

		STR		R0, [R6,#4]


loc_106144				; CODE XREF: sendto+6Cj
		MOV		R0, #0xFFFFFFFF


loc_106148				; CODE XREF: sendto+E0j sendto+FCj
		ADD		SP, SP,	#0x2C
		LDMFD		SP!, {R4-R11,PC}

; End of function sendto

; ---------------------------------------------------------------------------
off_106150	DCD hSession		; DATA XREF: sendto+30r
dword_106154	DCD 0xA0106		; DATA XREF: sendto:loc_1060D0r

; =============== S U B	R O U T	I N E =======================================


_recvfrom_wrapper			; CODE XREF: recvfrom_wrapper+10p

var_4		= -4
arg_0		=  0
arg_4		=  4

		STR		LR, [SP,#var_4]!
		CMP		R2, #0x2000
		LDR		LR, [SP,#4+arg_0]
		LDR		R12, [SP,#4+arg_4]
		BGE		loc_106174

		LDR		LR, [SP+4+var_4],#4
		B		recvfrom

; ---------------------------------------------------------------------------

loc_106174				; CODE XREF: _recvfrom_wrapper+10j
		STR		LR, [SP,#4+arg_0]
		STR		R12, [SP,#4+arg_4]
		LDR		LR, [SP+4+var_4],#4
		B		recvfrom_other

; End of function _recvfrom_wrapper


; =============== S U B	R O U T	I N E =======================================


_sendto_wrapper				; CODE XREF: sendto_wrapper+10p

var_4		= -4
arg_0		=  0
arg_4		=  4

		STR		LR, [SP,#var_4]!
		CMP		R2, #0x2000
		LDR		LR, [SP,#4+arg_0]
		LDR		R12, [SP,#4+arg_4]
		BGE		loc_1061A0

		LDR		LR, [SP+4+var_4],#4
		B		sendto

; ---------------------------------------------------------------------------

loc_1061A0				; CODE XREF: _sendto_wrapper+10j
		STR		LR, [SP,#4+arg_0]
		STR		R12, [SP,#4+arg_4]
		LDR		LR, [SP+4+var_4],#4
		B		sendto_other

; End of function _sendto_wrapper


; =============== S U B	R O U T	I N E =======================================


recvfrom_wrapper			; CODE XREF: recv_+30p

var_10		= -0x10
var_C		= -0xC
var_4		= -4

		MOV		R12, #0
		STMFD		SP!, {R0-R2,LR}
		STR		R12, [SP,#0x10+var_10]
		STR		R12, [SP,#0x10+var_C]
		BL		_recvfrom_wrapper

		ADD		SP, SP,	#0xC
		LDR		PC, [SP+4+var_4],#4

; End of function recvfrom_wrapper


; =============== S U B	R O U T	I N E =======================================


sendto_wrapper				; CODE XREF: sub_104C40+30p

var_10		= -0x10
var_C		= -0xC
var_4		= -4

		MOV		R12, #0
		STMFD		SP!, {R0-R2,LR}
		STR		R12, [SP,#0x10+var_10]
		STR		R12, [SP,#0x10+var_C]
		BL		_sendto_wrapper

		ADD		SP, SP,	#0xC
		LDR		PC, [SP+4+var_4],#4

; End of function sendto_wrapper


; =============== S U B	R O U T	I N E =======================================


getsockopt

arg_0		=  0

		STMFD		SP!, {R3-R9,LR}
		MOV		R8, R1
		MOV		R7, R2
		MOV		R5, R3
		MOV		R9, R0
		LDR		R6, [SP,#0x20+arg_0]
		BL		read_tid_and_pid_reg

		LDR		R3, =0x110102
		LDR		R2, [R6]
		STR		R7, [R0,#0xC]
		LDR		R7, [R0,#0x104]
		STR		R5, [R0,#0x104]
		LDR		R5, =hSession
		STR		R2, [R0,#0x10]
		MOV		R2, R2,LSL#14
		STMIA		R0, {R3,R9}
		ORR		R2, R2,	#2
		MOV		R3, #0x20 ; ' '
		STR		R8, [R0,#8]
		STR		R3, [R0,#0x14]
		LDR		R8, [R0,#0x100]
		MOV		R4, R0
		STR		R2, [R0,#0x100]
		LDR		R0, [R5]
		BL		SendSyncRequest

		CMP		R0, #0
		LDMNEFD		SP!, {R3-R9,PC}

		LDR		R0, [R4,#4]
		STR		R8, [R4,#0x100]
		CMP		R0, #0
		STR		R7, [R4,#0x104]
		BNE		loc_106290

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno

		CMP		R0, #0
		BGE		loc_106284


loc_106278				; CODE XREF: getsockopt:loc_106290j
		STR		R0, [R5,#4]
		MOV		R0, #0xFFFFFFFF
		LDMFD		SP!, {R3-R9,PC}

; ---------------------------------------------------------------------------

loc_106284				; CODE XREF: getsockopt+8Cj
		LDREQ		R3, [R4,#0xC]
		STREQ		R3, [R6]
		LDMFD		SP!, {R3-R9,PC}

; ---------------------------------------------------------------------------

loc_106290				; CODE XREF: getsockopt+7Cj
		BLT		loc_106278

		LDMFD		SP!, {R3-R9,PC}

; End of function getsockopt

; ---------------------------------------------------------------------------
dword_106298	DCD 0x110102		; DATA XREF: getsockopt+1Cr
off_10629C	DCD hSession		; DATA XREF: getsockopt+30r

; =============== S U B	R O U T	I N E =======================================


setsockopt

arg_0		=  0

		STMFD		SP!, {R3-R9,LR}
		MOV		R8, R1
		MOV		R7, R2
		MOV		R6, R3
		LDR		R5, [SP,#0x20+arg_0]
		MOV		R9, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0x120104
		STR		R5, [R0,#0x10]
		MOV		R5, R5,LSL#14
		ORR		R5, R5,	#0x2400
		ORR		R5, R5,	#2
		STR		R5, [R0,#0x1C]
		LDR		R5, =hSession
		STMIA		R0, {R3,R9}
		MOV		R3, #0x20 ; ' '
		STR		R8, [R0,#8]
		STR		R7, [R0,#0xC]
		STR		R3, [R0,#0x14]
		STR		R6, [R0,#0x20]
		MOV		R4, R0
		LDR		R0, [R5]
		BL		SendSyncRequest

		CMP		R0, #0
		LDMNEFD		SP!, {R3-R9,PC}

		LDR		R0, [R4,#4]
		CMP		R0, #0
		BNE		loc_106318

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno


loc_106318				; CODE XREF: setsockopt+6Cj
		CMP		R0, #0
		STRLT		R0, [R5,#4]
		MOVLT		R0, #0xFFFFFFFF
		LDMFD		SP!, {R3-R9,PC}

; End of function setsockopt

; ---------------------------------------------------------------------------
dword_106328	DCD 0x120104		; DATA XREF: setsockopt+1Cr
off_10632C	DCD hSession		; DATA XREF: setsockopt+34r

; =============== S U B	R O U T	I N E =======================================


fcntl

var_24		= -0x24
varg_r1		= -0xC
varg_r2		= -8
varg_r3		= -4

		STMFD		SP!, {R1-R3}
		STMFD		SP!, {R0,R1,R4-R7,LR}
		MOV		R7, R0
		LDR		R6, [SP,#0x28+varg_r1]
		BL		read_tid_and_pid_reg

		SUB		R2, R6,	#3
		ADD		R3, SP,	#0x28+varg_r2
		CMP		R2, #1
		STR		R3, [SP,#0x28+var_24]
		LDR		R5, =hSession
		BLS		loc_106368


loc_10635C				; CODE XREF: fcntl+58j
		MOV		R3, #0xFFFFFFEA
		STR		R3, [R5,#(dword_10B0C0 - 0x10B0BC)]
		B		loc_1063DC

; ---------------------------------------------------------------------------

loc_106368				; CODE XREF: fcntl+28j
		CMP		R6, #4
		MOV		R4, R0
		MOVNE		R3, #0
		BNE		loc_106394

		LDR		R3, [R3]
		ADD		R2, SP,	#0x28+varg_r3
		STR		R2, [SP,#0x28+var_24]
		BICS		R2, R3,	#0x4000
		BNE		loc_10635C

		CMP		R3, #0x4000
		MOVEQ		R3, #4


loc_106394				; CODE XREF: fcntl+44j
		LDR		R2, =0x1300C2
		STR		R3, [R4,#0xC]
		MOV		R3, #0x20 ; ' '
		STMIA		R4, {R2,R7}
		STR		R6, [R4,#8]
		STR		R3, [R4,#0x10]
		LDR		R0, [R5]
		BL		SendSyncRequest

		CMP		R0, #0
		BNE		loc_1063E0

		LDR		R0, [R4,#4]
		CMP		R0, #0
		BNE		loc_1063D0

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno


loc_1063D0				; CODE XREF: fcntl+94j
		CMP		R0, #0
		BGE		loc_1063E0

		STR		R0, [R5,#4]


loc_1063DC				; CODE XREF: fcntl+34j
		MOV		R0, #0xFFFFFFFF


loc_1063E0				; CODE XREF: fcntl+88j	fcntl+A4j
		ADD		SP, SP,	#8
		LDMFD		SP!, {R4-R7,LR}
		ADD		SP, SP,	#0xC
		BX		LR

; End of function fcntl

; ---------------------------------------------------------------------------
off_1063F0	DCD hSession		; DATA XREF: fcntl+24r
dword_1063F4	DCD 0x1300C2		; DATA XREF: fcntl:loc_106394r

; =============== S U B	R O U T	I N E =======================================


sockatmark
		STMFD		SP!, {R3-R5,LR}
		MOV		R5, R0
		BL		read_tid_and_pid_reg

		LDR		R3, =0x150042
		STMIA		R0, {R3,R5}
		LDR		R5, =hSession
		MOV		R3, #0x20 ; ' '
		STR		R3, [R0,#8]
		MOV		R4, R0
		LDR		R0, [R5]
		BL		SendSyncRequest

		CMP		R0, #0
		LDMNEFD		SP!, {R3-R5,PC}

		LDR		R0, [R4,#4]
		CMP		R0, #0
		BNE		loc_106440

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno


loc_106440				; CODE XREF: sockatmark+3Cj
		CMP		R0, #0
		STRLT		R0, [R5,#4]
		MOVLT		R0, #0xFFFFFFFF
		LDMFD		SP!, {R3-R5,PC}

; End of function sockatmark

; ---------------------------------------------------------------------------
dword_106450	DCD 0x150042		; DATA XREF: sockatmark+Cr
off_106454	DCD hSession		; DATA XREF: sockatmark+14r

; =============== S U B	R O U T	I N E =======================================


gethostid
		STMFD		SP!, {R4,LR}
		BL		read_tid_and_pid_reg

		MOV		R3, #0x160000
		STR		R3, [R0]
		LDR		R3, =hSession
		MOV		R4, R0
		LDR		R0, [R3]
		BL		SendSyncRequest

		CMP		R0, #0
		LDMNEFD		SP!, {R4,PC}

		LDR		R3, [R4,#4]
		CMP		R3, #0
		LDREQ		R0, [R4,#8]
		MOVNE		R0, R3
		LDMFD		SP!, {R4,PC}

; End of function gethostid

; ---------------------------------------------------------------------------
off_106494	DCD hSession		; DATA XREF: gethostid+10r

; =============== S U B	R O U T	I N E =======================================


getsockname

var_3C		= -0x3C
var_3B		= -0x3B

		STMFD		SP!, {R4-R10,LR}
		SUB		SP, SP,	#0x20
		MOV		R5, R0
		MOV		R6, R1
		MOV		R7, R2
		BL		read_tid_and_pid_reg

		LDR		R3, =0x170082
		ADD		R8, SP,	#0x40+var_3C
		STMIA		R0, {R3,R5}
		MOV		R3, #0x1C
		STR		R3, [R0,#8]
		LDR		R5, =hSession
		MOV		R3, #0x20 ; ' '
		STR		R3, [R0,#0xC]
		LDR		R3, =0x70002
		LDR		R10, [R0,#0x100]
		LDR		R9, [R0,#0x104]
		STR		R3, [R0,#0x100]
		STR		R8, [R0,#0x104]
		MOV		R4, R0
		LDR		R0, [R5]
		BL		SendSyncRequest

		CMP		R0, #0
		BNE		loc_106574

		LDR		R0, [R4,#4]
		STR		R10, [R4,#0x100]
		CMP		R0, #0
		STR		R9, [R4,#0x104]
		BNE		loc_106570

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno

		CMP		R0, #0
		BGE		loc_106528


loc_10651C				; CODE XREF: getsockname:loc_106570j
		STR		R0, [R5,#(dword_10B0C0 - 0x10B0BC)]
		MOV		R0, #0xFFFFFFFF
		B		loc_106574

; ---------------------------------------------------------------------------

loc_106528				; CODE XREF: getsockname+80j
		BNE		loc_106574

		LDRB		R3, [SP,#0x40+var_3B]
		LDR		R2, [R7]
		MOV		R1, #0
		STRH		R3, [R6]
		LDRB		R3, [SP,#0x40+var_3C]
		MOV		R0, R6
		CMP		R2, R3
		STRGT		R3, [R7]
		MOV		R2, #0x10
		BL		memset_

		LDR		R2, [R7]
		ADD		R0, R6,	#2
		ADD		R1, R8,	#2
		SUB		R2, R2,	#2
		BL		memcpy

		MOV		R0, #0
		B		loc_106574

; ---------------------------------------------------------------------------

loc_106570				; CODE XREF: getsockname+70j
		BLT		loc_10651C


loc_106574				; CODE XREF: getsockname+5Cj
					; getsockname+8Cj ...
		ADD		SP, SP,	#0x20
		LDMFD		SP!, {R4-R10,PC}

; End of function getsockname

; ---------------------------------------------------------------------------
dword_10657C	DCD 0x170082		; DATA XREF: getsockname+18r
off_106580	DCD hSession		; DATA XREF: getsockname+2Cr
dword_106584	DCD 0x70002		; DATA XREF: getsockname+38r

; =============== S U B	R O U T	I N E =======================================


getpeername

var_3C		= -0x3C
var_3B		= -0x3B

		STMFD		SP!, {R4-R10,LR}
		SUB		SP, SP,	#0x20
		MOV		R5, R0
		MOV		R6, R1
		MOV		R7, R2
		BL		read_tid_and_pid_reg

		LDR		R3, =0x180082
		ADD		R8, SP,	#0x40+var_3C
		STMIA		R0, {R3,R5}
		MOV		R3, #0x1C
		STR		R3, [R0,#8]
		LDR		R5, =hSession
		MOV		R3, #0x20 ; ' '
		STR		R3, [R0,#0xC]
		LDR		R3, =0x70002
		LDR		R10, [R0,#0x100]
		LDR		R9, [R0,#0x104]
		STR		R3, [R0,#0x100]
		STR		R8, [R0,#0x104]
		MOV		R4, R0
		LDR		R0, [R5]
		BL		SendSyncRequest

		CMP		R0, #0
		BNE		loc_106664

		LDR		R0, [R4,#4]
		STR		R10, [R4,#0x100]
		CMP		R0, #0
		STR		R9, [R4,#0x104]
		BNE		loc_106660

		LDR		R0, [R4,#8]
		BL		SOC_GetErrno

		CMP		R0, #0
		BGE		loc_106618


loc_10660C				; CODE XREF: getpeername:loc_106660j
		STR		R0, [R5,#(dword_10B0C0 - 0x10B0BC)]
		MOV		R0, #0xFFFFFFFF
		B		loc_106664

; ---------------------------------------------------------------------------

loc_106618				; CODE XREF: getpeername+80j
		BNE		loc_106664

		LDRB		R3, [SP,#0x40+var_3B]
		LDR		R2, [R7]
		MOV		R1, #0
		STRH		R3, [R6]
		LDRB		R3, [SP,#0x40+var_3C]
		MOV		R0, R6
		CMP		R2, R3
		STRGT		R3, [R7]
		MOV		R2, #0x10
		BL		memset_

		LDR		R2, [R7]
		ADD		R0, R6,	#2
		ADD		R1, R8,	#2
		SUB		R2, R2,	#2
		BL		memcpy

		MOV		R0, #0
		B		loc_106664

; ---------------------------------------------------------------------------

loc_106660				; CODE XREF: getpeername+70j
		BLT		loc_10660C


loc_106664				; CODE XREF: getpeername+5Cj
					; getpeername+8Cj ...
		ADD		SP, SP,	#0x20
		LDMFD		SP!, {R4-R10,PC}

; End of function getpeername

; ---------------------------------------------------------------------------
dword_10666C	DCD 0x180082		; DATA XREF: getpeername+18r
off_106670	DCD hSession		; DATA XREF: getpeername+2Cr
dword_106674	DCD 0x70002		; DATA XREF: getpeername+38r

; =============== S U B	R O U T	I N E =======================================


close_srv_handle			; CODE XREF: close_all_srv_handles_+Cp
		LDR		R3, =h_srv
		STMFD		SP!, {R4,LR}
		MOV		R4, R3
		LDR		R0, [R3]
		CMP		R0, #0
		BEQ		loc_106694

		BL		CloseHandle


loc_106694				; CODE XREF: close_srv_handle+14j
		MOV		R3, #0
		STR		R3, [R4]
		LDMFD		SP!, {R4,PC}

; End of function close_srv_handle

; ---------------------------------------------------------------------------
off_1066A0	DCD h_srv		; DATA XREF: close_srv_handler

; =============== S U B	R O U T	I N E =======================================


srv_initialize				; CODE XREF: get_srv_handle+20p
		STMFD		SP!, {R3-R5,LR}
		CMP		R0, #0
		LDR		R5, =h_srv
		MOVNE		R5, R0
		BL		read_tid_and_pid_reg

		LDR		R2, =0x10002
		MOV		R3, #0x20 ; ' '
		MOV		R4, R0
		STMIA		R0, {R2,R3}
		LDR		R0, [R5]
		BL		SendSyncRequest

		CMP		R0, #0
		LDREQ		R0, [R4,#4]
		LDMFD		SP!, {R3-R5,PC}

; End of function srv_initialize

; ---------------------------------------------------------------------------
off_1066DC	DCD h_srv		; DATA XREF: srv_initialize+8r
dword_1066E0	DCD 0x10002		; DATA XREF: srv_initialize+14r

; =============== S U B	R O U T	I N E =======================================


get_srv_handle				; CODE XREF: thread_NTR_home_injectee+ACp
					; close_all_srv_handles_:loc_1014C8p ...
		STMFD		SP!, {R3,LR}
		LDR		R0, =h_srv
		LDR		R1, =aSrv ; "srv:"
		BL		ConnectToPort

		CMP		R0, #0
		BNE		err

		LDR		R0, =h_srv
		LDMFD		SP!, {R3,LR}
		B		srv_initialize

; ---------------------------------------------------------------------------

err					; CODE XREF: get_srv_handle+14j
		MOV		R0, #0
		LDMFD		SP!, {R3,PC}

; End of function get_srv_handle

; ---------------------------------------------------------------------------
off_106710	DCD h_srv		; DATA XREF: get_srv_handle+4r
					; get_srv_handle+18r
off_106714	DCD aSrv		; DATA XREF: get_srv_handle+8r
					; "srv:"

; =============== S U B	R O U T	I N E =======================================


get_service_session_handle		; CODE XREF: get_wifi_status+18p
					; get_fs_user_handle_0+34p ...
		CMP		R0, #0
		STMFD		SP!, {R3-R9,LR}
		MOV		R7, R1
		LDR		R6, =h_srv
		MOVNE		R6, R0
		MOV		R0, R2	; a1
		MOV		R9, R2
		BL		strlen_

		CLZ		R3, R7
		MOV		R3, R3,LSR#5
		UXTB		R8, R0
		CMP		R8, #8
		MOVLS		R4, R3
		ORRHI		R4, R3,	#1
		CMP		R4, #0
		BNE		loc_106794

		BL		read_tid_and_pid_reg

		LDR		R3, =0x50100 ; GetServiceSessionHandle(8-byte servicename, u32 strlen, u32 flags).
					; Flags	bit0: if not set, return port-handle instead of	session-handle
					; when session-handle unavailable (max sessions/timeout?).
		MOV		R1, R9
		MOV		R5, R0
		STR		R3, [R0],#4
		BL		strncpy_

		STR		R8, [R5,#0xC]
		STR		R4, [R5,#0x10]
		LDR		R0, [R6]
		BL		SendSyncRequest

		CMP		R0, #0
		LDREQ		R3, [R5,#0xC]
		STREQ		R3, [R7]
		LDREQ		R0, [R5,#4]
		LDMFD		SP!, {R3-R9,PC}

; ---------------------------------------------------------------------------

loc_106794				; CODE XREF: get_service_session_handle+3Cj
		MOV		R0, #0xFFFFFFFF
		LDMFD		SP!, {R3-R9,PC}

; End of function get_service_session_handle

; ---------------------------------------------------------------------------
off_10679C	DCD h_srv		; DATA XREF: get_service_session_handle+Cr
dword_1067A0	DCD 0x50100		; DATA XREF: get_service_session_handle+44r
		ALIGN 0x10

; =============== S U B	R O U T	I N E =======================================


read_tid_and_pid_reg			; CODE XREF: sub_100518+Cp
					; sub_100568+10p ...
		MRC		p15, 0,	R0,c13,c0, 3 ; Read User read-only Thread and Process ID Register
		ADD		R0, R0,	#0x80
		BX		LR

; End of function read_tid_and_pid_reg


; =============== S U B	R O U T	I N E =======================================


; int __cdecl ControlMemory(unsigned int *outaddr, unsigned int	addr0, unsigned	int addr1, unsigned int	size, unsigned int operation, unsigned int permissions)
ControlMemory				; CODE XREF: prepare_config_mem+44p
					; handle_reload_packet+E4p ...

var_8		= -8
var_4		= -4
operation	=  0
permissions	=  4

		STMFD		SP!, {R0,R4}
		LDR		R0, [SP,#8+operation]
		LDR		R4, [SP,#8+permissions]
		SVC		1
		LDR		R2, [SP+8+var_8],#4
		STR		R1, [R2]
		LDR		R4, [SP+4+var_4],#4
		BX		LR

; End of function ControlMemory

; ---------------------------------------------------------------------------
		SVC		3
		BX		LR


; =============== S U B	R O U T	I N E =======================================


CreateThread				; CODE XREF: install_ntr+1D8p
					; install_ntr+228p ...

var_8		= -8
var_4		= -4
arg_0		=  0
arg_4		=  4

		STMFD		SP!, {R0,R4}
		LDR		R0, [SP,#8+arg_0]
		LDR		R4, [SP,#8+arg_4]
		SVC		8
		LDR		R2, [SP+8+var_8],#4
		STR		R1, [R2]
		LDR		R4, [SP+4+var_4],#4
		BX		LR

; End of function CreateThread


; =============== S U B	R O U T	I N E =======================================

; Attributes: noreturn

ExitThread				; CODE XREF: thread_setup_ntr_network_server+28p
					; check_plugin_exit_flag+14j ...
		SVC		9
		BX		LR

; End of function ExitThread


; =============== S U B	R O U T	I N E =======================================


SleepThread				; CODE XREF: lcd_solid_fill+2Cp
					; thread_NTR_home_injectee+C0p	...
		SVC		0xA
		BX		LR

; End of function SleepThread

; ---------------------------------------------------------------------------
		STR		R0, [SP,#-4]!
		SVC		0x13
		LDR		R3, [SP],#4
		STR		R1, [R3]
		BX		LR

; ---------------------------------------------------------------------------
		SVC		0x14
		BX		LR

; ---------------------------------------------------------------------------
		STR		R0, [SP,#-4]!
		SVC		0x16
		LDR		R2, [SP],#4
		STR		R1, [R2]
		BX		LR

; ---------------------------------------------------------------------------
		STR		R0, [SP,#-4]!
		SVC		0x17
		LDR		R2, [SP],#4
		STR		R1, [R2]
		BX		LR

; ---------------------------------------------------------------------------
		SVC		0x18
		BX		LR

; ---------------------------------------------------------------------------
		SVC		0x19
		BX		LR


; =============== S U B	R O U T	I N E =======================================


CreateMemoryBlock			; CODE XREF: SOC_Initialize+28p

var_4		= -4
arg_0		=  0

		STR		R0, [SP,#var_4]!
		LDR		R0, [SP,#4+arg_0]
		SVC		0x1E
		LDR		R2, [SP+4+var_4],#4
		STR		R1, [R2]
		BX		LR

; End of function CreateMemoryBlock

; ---------------------------------------------------------------------------
		SVC		0x1F
		BX		LR

; ---------------------------------------------------------------------------
		SVC		0x20 ; ' '
		BX		LR

; ---------------------------------------------------------------------------
		SVC		0x22 ; '"'
		BX		LR


; =============== S U B	R O U T	I N E =======================================


CloseHandle				; CODE XREF: get_wifi_status+48p
					; get_nintendo_home_version_info+170p ...
		SVC		0x23 ; '#'
		BX		LR

; End of function CloseHandle

; ---------------------------------------------------------------------------
		SVC		0x24 ; '$'
		BX		LR

; ---------------------------------------------------------------------------
		STR		R5, [SP,#-4]!
		MOV		R5, R0
		LDR		R0, [SP,#4]
		LDR		R4, [SP,#8]
		SVC		0x25 ; '%'
		STR		R1, [R5]
		LDR		R5, [SP],#4
		BX		LR

; ---------------------------------------------------------------------------
		SVC		0x28 ; '('
		BX		LR

; ---------------------------------------------------------------------------
		STMFD		SP!, {R0,R4}
		SVC		0x2A ; '*'
		LDR		R4, [SP],#4
		STR		R1, [R4]
		STR		R2, [R4,#4]
		LDR		R4, [SP],#4
		BX		LR

; ---------------------------------------------------------------------------
		STMFD		SP!, {R0,R4}
		SVC		0x2B ; '+'
		LDR		R4, [SP],#4
		STR		R1, [R4]
		STR		R2, [R4,#4]
		LDR		R4, [SP],#4
		BX		LR


; =============== S U B	R O U T	I N E =======================================


ConnectToPort				; CODE XREF: get_srv_handle+Cp

var_4		= -4

		STR		R0, [SP,#var_4]!
		SVC		0x2D ; '-'
		LDR		R3, [SP+4+var_4],#4
		STR		R1, [R3]
		BX		LR

; End of function ConnectToPort


; =============== S U B	R O U T	I N E =======================================


SendSyncRequest				; CODE XREF: sub_100518+34p
					; sub_100568+40p ...
		SVC		0x32 ; '2'
		BX		LR

; End of function SendSyncRequest


; =============== S U B	R O U T	I N E =======================================


GetProcessId				; CODE XREF: get_current_process_id+10p
					; get_current_process_handle+24p

var_4		= -4

		STR		R0, [SP,#var_4]!
		SVC		0x35 ; '5'
		LDR		R3, [SP+4+var_4],#4
		STR		R1, [R3]
		BX		LR

; End of function GetProcessId

; ---------------------------------------------------------------------------
		STR		R0, [SP,#-4]!
		SVC		0x37 ; '7'
		LDR		R3, [SP],#4
		STR		R1, [R3]
		BX		LR

; ---------------------------------------------------------------------------
		SVC		0x10
		BX		LR


; =============== S U B	R O U T	I N E =======================================


OpenThread				; CODE XREF: get_thread_context+1Cp

var_4		= -4

		STR		R0, [SP,#var_4]!
		SVC		0x34 ; '4'
		LDR		R3, [SP+4+var_4],#4
		STR		R1, [R3]
		BX		LR

; End of function OpenThread


; =============== S U B	R O U T	I N E =======================================


FlushProcessDataCache			; CODE XREF: inter_process_dma_copy+44p
					; inter_process_dma_copy+60p ...
		SVC		0x54 ; 'T'
		BX		LR

; End of function FlushProcessDataCache


; =============== S U B	R O U T	I N E =======================================


InvalidateProcessDataCache		; CODE XREF: inter_process_dma_copy+138p
		SVC		0x52 ; 'R'
		BX		LR

; End of function InvalidateProcessDataCache

; ---------------------------------------------------------------------------
		SVC		2
		BX		LR

; ---------------------------------------------------------------------------
		SVC		0x7A ; 'z'
		BX		LR

; ---------------------------------------------------------------------------
		SVC		0x76 ; 'v'
		BX		LR


; =============== S U B	R O U T	I N E =======================================


OpenProcess				; CODE XREF: get_nintendo_home_version_info+20p
					; set_KProcess_refcount_to_1+Cp ...

var_4		= -4

		STR		R0, [SP,#var_4]!
		SVC		0x33 ; '3'
		LDR		R3, [SP+4+var_4],#4
		STR		R1, [R3]
		BX		LR

; End of function OpenProcess


; =============== S U B	R O U T	I N E =======================================


; int __cdecl ControlProcessMemory(unsigned int	hKProcess, unsigned int	Addr0, unsigned	int Addr1, unsigned int	Size, unsigned int Type, unsigned int Permissions)
ControlProcessMemory			; CODE XREF: protectRemoteMemory+18p

Type		=  0
Permissions	=  4

		STMFD		SP!, {R0,R4,R5}
		LDR		R4, [SP,#0xC+Type]
		LDR		R5, [SP,#0xC+Permissions]
		SVC		0x70 ; 'p'
		LDMFD		SP!, {R2,R4,R5}
		BX		LR

; End of function ControlProcessMemory

; ---------------------------------------------------------------------------
		SVC		0x71 ; 'q'
		BX		LR


; =============== S U B	R O U T	I N E =======================================


; int __cdecl StartInterProcessDma(unsigned int	*hdma, unsigned	int hdstProcess, void *dst, unsigned int hsrcProcess, const void *src, unsigned	int size, unsigned int config)
StartInterProcessDma			; CODE XREF: inter_process_dma_copy+94p

src		=  0
size		=  4
config		=  8

		STMFD		SP!, {R0,R4,R5}
		LDR		R0, [SP,#0xC+src]
		LDR		R4, [SP,#0xC+size]
		LDR		R5, [SP,#0xC+config]
		SVC		0x55 ; 'U'
		LDMFD		SP!, {R2,R4,R5}
		STR		R1, [R2]
		BX		LR

; End of function StartInterProcessDma


; =============== S U B	R O U T	I N E =======================================


GetDmaState				; CODE XREF: inter_process_dma_copy+BCp

var_4		= -4

		STR		R0, [SP,#var_4]!
		SVC		0x57 ; 'W'
		LDR		R3, [SP+4+var_4],#4
		STR		R1, [R3]
		BX		LR

; End of function GetDmaState


; =============== S U B	R O U T	I N E =======================================


Backdoor				; CODE XREF: arm11k_unknown_cmd5+1Cp
					; arm11k_set_current_kprocess+18j ...
		SVC		0x7B ; '{'
		BX		LR

; End of function Backdoor


; =============== S U B	R O U T	I N E =======================================


GetProcessList				; CODE XREF: handle_listprocess_packet+18p
					; ntr_cmd_process+28p

var_4		= -4

		STR		R0, [SP,#var_4]!
		SVC		0x65 ; 'e'
		LDR		R3, [SP+4+var_4],#4
		STR		R1, [R3]
		BX		LR

; End of function GetProcessList


; =============== S U B	R O U T	I N E =======================================


GetThreadList				; CODE XREF: get_remote_PC+24p
					; handle_listthread_packet+58p

var_4		= -4

		STR		R0, [SP,#var_4]!
		SVC		0x66 ; 'f'
		LDR		R3, [SP+4+var_4],#4
		STR		R1, [R3]
		BX		LR

; End of function GetThreadList

; ---------------------------------------------------------------------------
		SVC		0x3B ; ';'
		BX		LR


; =============== S U B	R O U T	I N E =======================================


DebugActiveProcess			; CODE XREF: ROM:00104618p

var_4		= -4

		STR		R0, [SP,#var_4]!
		SVC		0x60 ; '`'
		LDR		R3, [SP+4+var_4],#4
		STR		R1, [R3]
		BX		LR

; End of function DebugActiveProcess


; =============== S U B	R O U T	I N E =======================================


ReadProcessMemory			; CODE XREF: ROM:00104694p
		SVC		0x6A ; 'j'
		BX		LR

; End of function ReadProcessMemory

; ---------------------------------------------------------------------------
		SVC		0x6B ; 'k'
		BX		LR

; ---------------------------------------------------------------------------
		ALIGN 0x10

; =============== S U B	R O U T	I N E =======================================

; returns ptr to kernel	object referenced by handle

; int __cdecl get_kernel_object_ptr(void *kprocesshandletable, unsigned	int hProcess)
get_kernel_object_ptr			; CODE XREF: dispatch_arm11_kernel_cmd+5Cp
		LDR		R3, [R0] ; r3 now holds	handledata *?
		MOV		R1, R1,LSL#17
		ADD		R1, R3,	R1,LSR#14 ; hProcess * 8
		LDR		R0, [R1,#4] ; get Pointer to the kernel	object that the	handle references.
		BX		LR

; End of function get_kernel_object_ptr

; ---------------------------------------------------------------------------
		BX		LR

; ---------------------------------------------------------------------------
		ADD		R0, R0,	#0xC0000000
		BX		LR


; =============== S U B	R O U T	I N E =======================================


mmu_stuff				; CODE XREF: install_SVC_6D_hook+14p
					; install_SVC_6D_hook+24p ...
		LDR		R12, =0x1FFFC000 ; -> DFFFC7FC
		LDR		R3, =0x1FFF8000	; -> DFFF87FC
		CMP		R0, #0
		MOVEQ		R0, R3
		MOVNE		R0, R12
		ADD		R0, R0,	#0x7F0
		STMFD		SP!, {R4-R6,LR}
		ADD		R2, R2,	R1
		ADD		R0, R0,	#0xC000000C
		MOV		LR, #0x20000000


loc_106AA8				; CODE XREF: mmu_stuff+D8j
		LDR		R3, [R0,#4]!
		AND		R12, R3, #3
		CMP		R12, #2
		BNE		loc_106AE0

		CMP		LR, R2
		MOVCC		R12, #1
		MOVCS		R12, #0
		CMP		LR, R1
		MOVCC		R12, #0
		CMP		R12, #0
		BICNE		R3, R3,	#0x8C00
		ORRNE		R3, R3,	#0xC00
		STRNE		R3, [R0]
		B		loc_106B54

; ---------------------------------------------------------------------------

loc_106AE0				; CODE XREF: mmu_stuff+34j
		CMP		R12, #1
		BNE		loc_106B54

		BIC		R3, R3,	#0x3FC
		BIC		R3, R3,	#3
		SUB		R4, R3,	#0x40000004
		ADD		R3, R3,	#0xC0000000
		ADD		R12, R3, #0x3FC
		MOV		R5, LR


loc_106B00				; CODE XREF: mmu_stuff+D0j
		CMP		R5, R2
		MOVCC		R6, #1
		MOVCS		R6, #0
		CMP		R5, R1
		MOVCC		R6, #0
		CMP		R6, #0
		LDR		R3, [R4,#4]!
		BEQ		loc_106B48

		AND		R6, R3,	#3
		CMP		R6, #1
		BICEQ		R3, R3,	#0x8200
		BICEQ		R3, R3,	#0x30
		BEQ		loc_106B40

		BLS		loc_106B48

		BIC		R3, R3,	#0x230
		BIC		R3, R3,	#1


loc_106B40				; CODE XREF: mmu_stuff+B0j
		ORR		R3, R3,	#0x30
		STR		R3, [R4]


loc_106B48				; CODE XREF: mmu_stuff+9Cj
					; mmu_stuff+B4j
		CMP		R4, R12
		ADD		R5, R5,	#0x1000
		BNE		loc_106B00


loc_106B54				; CODE XREF: mmu_stuff+5Cj
					; mmu_stuff+64j
		ADDS		LR, LR,	#0x100000
		BNE		loc_106AA8

		LDMFD		SP!, {R4-R6,PC}

; End of function mmu_stuff

; ---------------------------------------------------------------------------
dword_106B60	DCD 0x1FFFC000		; DATA XREF: mmu_stuffr
dword_106B64	DCD 0x1FFF8000		; DATA XREF: mmu_stuff+4r

; =============== S U B	R O U T	I N E =======================================


install_SVC_6D_hook			; CODE XREF: dispatch_arm11_kernel_cmd+D4p
		STMFD		SP!, {R4,LR}
		MOV		R0, #0
		LDR		R4, =va_arm11_kernel_base_W
		LDR		R1, =0xFFFBA000	; mapped IO I2C
		MOV		R2, #0x10000
		BL		mmu_stuff

		MOV		R0, #1
		LDR		R1, =0xFFFBA000
		MOV		R2, #0x10000
		BL		mmu_stuff

		LDR		R3, [R4] ; get va_arm11_kernel_base
		MOV		R2, #0
		ADD		R3, R3,	#0x8000
		LDR		R0, =0xE10F0000
		STR		R2, [R3,#0x4EC]	; patch	error code 0xE0E01BEE
		LDR		R3, [R4]
		ADD		R3, R3,	#0x8000
		STR		R2, [R3,#0x4F0]	; patch	error code 0xE0E01BF5
		LDR		R2, [R4,#(offs_to_SVC_6D - 0x10837C)]
		LDR		R3, [R4]
		ADD		R1, R2,	R3

patch svc 6D handler's code to force it	to disable FIQ and IRQ

MRS		R0, CPSR
ORR		R0, R0,	#0xC0
MSR		CPSR_cf, R0

		STR		R0, [R2,R3]
		LDR		R2, =0xE38000C0
		LDR		R3, =0xE129F000
		LDR		R0, =dispatch_arm11_kernel_cmd ; dst
		STMIB		R1, {R2,R3}

then redirect to arm11 cmd dispatcher

		ADD		R1, R1,	#0xC ; src
		BL		rtGenerateJumpCode ; hook SVC 6D

		LDR		R3, [R4,#(offs_to_SVC_6D - 0x10837C)]
		LDR		R2, [R4,#(va_arm11_kernel_base_X - 0x10837C)]
		ADD		R3, R3,	R2

let arm11 cb point to modified handler 6D code

		STR		R3, [R4,#(p_cb - 0x10837C)]
		BL		InvalidateEntireInstructionCache

		LDMFD		SP!, {R4,LR}
		B		CleanEntireDataCache

; End of function install_SVC_6D_hook

; ---------------------------------------------------------------------------
off_106BF4	DCD va_arm11_kernel_base_W ; DATA XREF:	install_SVC_6D_hook+8r
dword_106BF8	DCD 0xFFFBA000		; DATA XREF: install_SVC_6D_hook+Cr
					; install_SVC_6D_hook+1Cr
dword_106BFC	DCD 0xE10F0000		; DATA XREF: install_SVC_6D_hook+34r
dword_106C00	DCD 0xE38000C0		; DATA XREF: install_SVC_6D_hook+58r
dword_106C04	DCD 0xE129F000		; DATA XREF: install_SVC_6D_hook+5Cr
; void *dst
dst		DCD dispatch_arm11_kernel_cmd ;	DATA XREF: install_SVC_6D_hook+60r
					; cmd 1: memcpy
					; cmd 2: get kernel object by handle
					; cmd 3: get current kprocess
					; cmd 4: set current kprocess
					; cmd 5: ?
					; cmd 6: hook SVC 6D

; =============== S U B	R O U T	I N E =======================================


clean_cache				; CODE XREF: dispatch_arm11_kernel_cmd+E8p
		STMFD		SP!, {R3,LR}
		MOV		R0, #0
		LDR		R1, =0xFFFBA000
		MOV		R2, #0x10000
		BL		mmu_stuff

		MOV		R0, #1
		LDR		R1, =0xFFFBA000
		MOV		R2, #0x10000
		BL		mmu_stuff

		LDR		R1, =va_arm11_kernel_base_W
		MOV		R2, #0
		LDR		R3, [R1]
		ADD		R3, R3,	#0x8000
		STR		R2, [R3,#0x158]
		LDR		R3, [R1]
		ADD		R3, R3,	#0x8000
		STR		R2, [R3,#0x15C]
		BL		InvalidateEntireInstructionCache

		LDMFD		SP!, {R3,LR}
		B		CleanEntireDataCache

; End of function clean_cache

; ---------------------------------------------------------------------------
dword_106C5C	DCD 0xFFFBA000		; DATA XREF: clean_cache+8r
					; clean_cache+18r
off_106C60	DCD va_arm11_kernel_base_W ; DATA XREF:	clean_cache+24r

; =============== S U B	R O U T	I N E =======================================

; cmd 1: memcpy
; cmd 2: get kernel object by handle
; cmd 3: get current kprocess
; cmd 4: set current kprocess
; cmd 5: ?
; cmd 6: hook SVC 6D

dispatch_arm11_kernel_cmd		; CODE XREF: cb_arm11_dispatch+10p
					; DATA XREF: install_SVC_6D_hook+60o ...
		STMFD		SP!, {R4,LR}
		LDR		R4, =g_arm11_cmd
		LDR		R3, [R4]
		CMP		R3, #1
		BNE		loc_106CA0

handle_cmd_1:
		LDR		R2, [R4,#(g_arm11_param3 - 0x10B0C8)]
		LDR		R1, [R4,#(g_arm11_param1 - 0x10B0C8)]
		LDR		R0, [R4,#(g_arm11_param2 - 0x10B0C8)]
		MOV		R3, #0


_memcpy					; CODE XREF: dispatch_arm11_kernel_cmd+34j
		CMP		R3, R2
		LDRCC		R12, [R3,R0]
		STRCC		R12, [R3,R1]
		ADDCC		R3, R3,	#4
		BCC		_memcpy

		LDMFD		SP!, {R4,PC}

; ---------------------------------------------------------------------------

loc_106CA0				; CODE XREF: dispatch_arm11_kernel_cmd+10j
		CMP		R3, #2
		BNE		0x106CCC

handle_cmd_2:
		LDR		R3, =va_arm11_kernel_base_W
		LDR		R1, [R4,#(g_arm11_param1 - 0x10B0C8)] ;	hProcess
		LDR		R0, [R3,#(offs_KProcessHandleTable - 0x10837C)]
		MOV		R3, #0xFFFF9FFF
		LDR		R3, [R3,#-0xFFB] ; KProcess
		ADD		R0, R0,	R3 ; r0	points to KProcessHandleTable
		BL		get_kernel_object_ptr ;	returns	ptr to kernel object referenced	by handle

		STR		R0, [R4,#(g_arm11_param1 - 0x10B0C8)]
		LDMFD		SP!, {R4,PC}

; ---------------------------------------------------------------------------
		CMP		R3, #3	; CODE XREF: dispatch_arm11_kernel_cmd+40j
handle_cmd_3:
		MOVEQ		R3, #0xFFFF9FFF
		LDREQ		R3, [R3,#-0xFFB]
		STREQ		R3, [R4,#(g_arm11_param1 - 0x10B0C8)]
		LDMEQFD		SP!, {R4,PC}

set_kprocess:
		CMP		R3, #4
handle_cmd_4:
		MOVEQ		R3, #0xFFFF9FFF
		LDREQ		R2, [R4,#4]
		STREQ		R2, [R3,#-0xFFB]
		LDMEQFD		SP!, {R4,PC}

		CMP		R3, #5
		BNE		loc_106D1C

handle_cmd_5:
		LDR		R1, =va_arm11_kernel_base_W
		LDR		R3, [R4,#4] ; param 1
		LDR		R2, [R4,#8] ; param 2
		LDR		R1, [R1,#(some_offs_0 -	0x10837C)]
		LDR		R1, [R1,R3]
		STR		R1, [R4,#8] ; param 3
		STR		R2, [R3,#0xAC]
		LDMFD		SP!, {R4,PC}

; ---------------------------------------------------------------------------

loc_106D1C				; CODE XREF: dispatch_arm11_kernel_cmd+94j
		CMP		R3, #6
		LDMNEFD		SP!, {R4,PC}

handle_cmd_6:
		LDR		R3, =firmware_version_internal
		MOV		R4, R3
		LDR		R2, [R3]
		CMP		R2, #0x5C ; '\'
		BNE		loc_106D3C

		BL		install_SVC_6D_hook


loc_106D3C				; CODE XREF: dispatch_arm11_kernel_cmd+D0j
		LDR		R3, [R4]
		CMP		R3, #0x51 ; 'Q'
		LDMNEFD		SP!, {R4,PC}

		LDMFD		SP!, {R4,LR}
		B		clean_cache

; End of function dispatch_arm11_kernel_cmd

; ---------------------------------------------------------------------------
off_106D50	DCD g_arm11_cmd		; DATA XREF: dispatch_arm11_kernel_cmd+4r
off_106D54	DCD va_arm11_kernel_base_W ; DATA XREF:	dispatch_arm11_kernel_cmd+44r
					; dispatch_arm11_kernel_cmd+98r
off_106D58	DCD firmware_version_internal ;	DATA XREF: dispatch_arm11_kernel_cmd+C0r

; =============== S U B	R O U T	I N E =======================================


arm11k_unknown_cmd5
		STMFD		SP!, {R4,LR}
		MOV		R3, #5
		LDR		R4, =g_arm11_cmd
		STR		R3, [R4]
		LDR		R3, =va_arm11_kernel_base_W
		STMIB		R4, {R0,R1}
		LDR		R0, [R3,#(p_cb - 0x10837C)]
		BL		Backdoor

		LDR		R0, [R4,#(g_arm11_param2 - 0x10B0C8)]
		LDMFD		SP!, {R4,PC}

; End of function arm11k_unknown_cmd5

; ---------------------------------------------------------------------------
off_106D84	DCD g_arm11_cmd		; DATA XREF: arm11k_unknown_cmd5+8r
off_106D88	DCD va_arm11_kernel_base_W ; DATA XREF:	arm11k_unknown_cmd5+10r

; =============== S U B	R O U T	I N E =======================================


arm11k_set_current_kprocess		; CODE XREF: map_remote_memory+30p
					; map_remote_memory+5Cp
		LDR		R3, =g_arm11_cmd
		MOV		R2, #4
		STR		R0, [R3,#(g_arm11_param1 - 0x10B0C8)]
		STR		R2, [R3]
		LDR		R3, =va_arm11_kernel_base_W
		LDR		R0, [R3,#(p_cb - 0x10837C)]
		B		Backdoor

; End of function arm11k_set_current_kprocess

; ---------------------------------------------------------------------------
off_106DA8	DCD g_arm11_cmd		; DATA XREF: arm11k_set_current_kprocessr
off_106DAC	DCD va_arm11_kernel_base_W ; DATA XREF:	arm11k_set_current_kprocess+10r

; =============== S U B	R O U T	I N E =======================================


arm11k_get_current_kprocess		; CODE XREF: ROM:00104054j
					; map_remote_memory+24p
		STMFD		SP!, {R4,LR}
		MOV		R3, #3
		LDR		R4, =g_arm11_cmd
		STR		R3, [R4]
		LDR		R3, =va_arm11_kernel_base_W
		LDR		R0, [R3,#(p_cb - 0x10837C)]
		BL		Backdoor

		LDR		R0, [R4,#(g_arm11_param1 - 0x10B0C8)]
		LDMFD		SP!, {R4,PC}

; End of function arm11k_get_current_kprocess

; ---------------------------------------------------------------------------
off_106DD4	DCD g_arm11_cmd		; DATA XREF: arm11k_get_current_kprocess+8r
off_106DD8	DCD va_arm11_kernel_base_W ; DATA XREF:	arm11k_get_current_kprocess+10r

; =============== S U B	R O U T	I N E =======================================

; r0 = handle
; returns ptr to kernel	object

; int __cdecl arm11k_get_kernel_object(unsigned	int handle)
arm11k_get_kernel_object		; CODE XREF: set_KProcess_refcount_to_1+30p
					; handle_queryhandle_packet+48p ...
		STMFD		SP!, {R4,LR}
		MOV		R3, #2
		LDR		R4, =g_arm11_cmd
		STR		R3, [R4]
		LDR		R3, =va_arm11_kernel_base_W
		STR		R0, [R4,#(g_arm11_param1 - 0x10B0C8)]
		LDR		R0, [R3,#(p_cb - 0x10837C)]
		BL		Backdoor

		LDR		R0, [R4,#(g_arm11_param1 - 0x10B0C8)]
		LDMFD		SP!, {R4,PC}

; End of function arm11k_get_kernel_object

; ---------------------------------------------------------------------------
off_106E04	DCD g_arm11_cmd		; DATA XREF: arm11k_get_kernel_object+8r
off_106E08	DCD va_arm11_kernel_base_W ; DATA XREF:	arm11k_get_kernel_object+10r

; =============== S U B	R O U T	I N E =======================================


; int __cdecl arm11k_memcpy(void *dst, void *src, unsigned int count)
arm11k_memcpy				; CODE XREF: set_KProcess_refcount_to_1+4Cp
					; set_KProcess_refcount_to_1+64p ...
		LDR		R3, =g_arm11_cmd
		MOV		R12, #1
		STMIB		R3, {R0-R2} ; param1-3
					; dst, src, count
		STR		R12, [R3]
		LDR		R3, =va_arm11_kernel_base_W
		LDR		R0, [R3,#(p_cb - 0x10837C)]
		B		Backdoor

; End of function arm11k_memcpy

; ---------------------------------------------------------------------------
off_106E28	DCD g_arm11_cmd		; DATA XREF: arm11k_memcpyr
off_106E2C	DCD va_arm11_kernel_base_W ; DATA XREF:	arm11k_memcpy+10r

; =============== S U B	R O U T	I N E =======================================


arm11k_replacel_svc_6D_handler		; CODE XREF: install_ntr:loc_10160Cp
		LDR		R3, =g_arm11_cmd
		MOV		R2, #6
		STR		R2, [R3]
		LDR		R3, =va_arm11_kernel_base_W
		LDR		R0, [R3,#(p_cb - 0x10837C)]
		B		Backdoor

; End of function arm11k_replacel_svc_6D_handler

; ---------------------------------------------------------------------------
off_106E48	DCD g_arm11_cmd		; DATA XREF: arm11k_replacel_svc_6D_handlerr
off_106E4C	DCD va_arm11_kernel_base_W ; DATA XREF:	arm11k_replacel_svc_6D_handler+Cr
; ---------------------------------------------------------------------------
		BX		LR


; =============== S U B	R O U T	I N E =======================================


pa_to_va				; CODE XREF: update_screen+10p
					; update_screen+20p ...
		ADD		R3, R0,	#0xEC000000
		CMN		R3, #0xF8000001
		BHI		loc_106E68

		ADD		R0, R0,	#0xC000000
		BX		LR

; ---------------------------------------------------------------------------

loc_106E68				; CODE XREF: pa_to_va+8j
		ADD		R3, R0,	#0xD0000000
		CMN		R3, #0xF0000001
		BHI		loc_106E7C

		ADD		R0, R0,	#0xF0000000
		BX		LR

; ---------------------------------------------------------------------------

loc_106E7C				; CODE XREF: pa_to_va+1Cj
		ADD		R3, R0,	#0xE1000000
		CMP		R3, #0x600000
		BCS		locret_106E90

		ADD		R0, R0,	#0xF9000000
		BX		LR

; ---------------------------------------------------------------------------

locret_106E90				; CODE XREF: pa_to_va+30j
		BX		LR

; End of function pa_to_va


; =============== S U B	R O U T	I N E =======================================


assign_rwx_to_0x1F000000		; CODE XREF: thread_NTR_home_injectee+80p
		STMFD		SP!, {R3,LR}
		MOV		R1, #0x600000 ;	size
		MOV		R0, #0x1F000000	; addr
		BL		protectMemory ;	assigns	RWX to addr : addr+size

		CMP		R0, #0
		MOVEQ		R2, #1
		LDREQ		R3, =is_NTR_OSD_requested
		STREQ		R2, [R3]
		LDMFD		SP!, {R3,PC}

; End of function assign_rwx_to_0x1F000000

; ---------------------------------------------------------------------------
off_106EB8	DCD is_NTR_OSD_requested ; DATA	XREF: assign_rwx_to_0x1F000000+18r

; =============== S U B	R O U T	I N E =======================================


sub_106EBC				; CODE XREF: display_OSD_menu+8p
					; wait_pad_input+1Cp

var_4		= -4

		LDR		R2, =0x7FFFFF
		SUB		SP, SP,	#8
		MOV		R3, #0
		STR		R3, [SP,#8+var_4]


loc_106ECC				; CODE XREF: sub_106EBC+24j
		LDR		R3, [SP,#8+var_4]
		CMP		R3, R2
		LDRLS		R3, [SP,#8+var_4]
		ADDLS		R3, R3,	#1
		STRLS		R3, [SP,#8+var_4]
		BLS		loc_106ECC

		ADD		SP, SP,	#8
		BX		LR

; End of function sub_106EBC

; ---------------------------------------------------------------------------
dword_106EEC	DCD 0x7FFFFF		; DATA XREF: sub_106EBCr

; =============== S U B	R O U T	I N E =======================================


update_screen				; CODE XREF: ROM:00104680p
					; controlVideo+50p ...
		STMFD		SP!, {R4-R6,LR}
		LDR		R5, =pa_N3DS
		LDR		R4, =va_mapped_io_PDC
		LDR		R0, [R5]
		BL		pa_to_va

		LDR		R6, [R4]
		STR		R0, [R6,#0x568]
		LDR		R0, [R5]
		BL		pa_to_va

		LDR		R6, [R4]
		LDR		R2, =0x80301
		STR		R0, [R6,#0x56C]
		LDR		R3, [R4]
		LDR		R0, =0xFFFF8001
		STR		R2, [R3,#0x570]
		LDR		R3, [R4]
		LDR		R2, =0x14000F0
		STR		R2, [R3,#0x55C]
		LDR		R3, [R4]
		MOV		R2, #0x2D0
		STR		R2, [R3,#0x590]
		MOV		R2, #0x38400
		LDR		R1, [R5]
		LDMFD		SP!, {R4-R6,LR}
		B		FlushProcessDataCache

; End of function update_screen

; ---------------------------------------------------------------------------
off_106F54	DCD pa_N3DS		; DATA XREF: update_screen+4r
off_106F58	DCD va_mapped_io_PDC	; DATA XREF: update_screen+8r
dword_106F5C	DCD 0x80301		; DATA XREF: update_screen+28r
dword_106F60	DCD 0xFFFF8001		; DATA XREF: update_screen+34r
dword_106F64	DCD 0x14000F0		; DATA XREF: update_screen+40r

; =============== S U B	R O U T	I N E =======================================


sub_106F68				; CODE XREF: dump_process_to_file+C8p
					; dump_memory_to_file+114p
		STMFD		SP!, {R3,LR}
		LDR		R3, =some_callback
		LDR		R3, [R3]
		CMP		R3, #0
		LDMEQFD		SP!, {R3,PC}

		BLX		R3

		LDMFD		SP!, {R3,PC}

; End of function sub_106F68

; ---------------------------------------------------------------------------
off_106F84	DCD some_callback	; DATA XREF: sub_106F68+4r

; =============== S U B	R O U T	I N E =======================================


acquire_video				; CODE XREF: fatal_LR+8p
					; display_OSD_menu:loc_10345Cp	...
		STMFD		SP!, {R4-R8,LR}
		LDR		R5, =is_NTR_OSD_requested
		LDR		R7, [R5,#(dword_10B14C - 0x10B148)]
		CMP		R7, #0
		BNE		loc_10703C

		LDR		R3, =va_mapped_io_LCD
		LDR		R6, =va_mapped_io_PDC
		LDR		R8, =pa_N3DS
		LDR		R2, [R3]
		STR		R7, [R2,#0x204]	; REG_LCDCOLORFILLMAIN
		LDR		R3, [R3]
		STR		R7, [R3,#0xA04]	; REG_LCDCOLORFILLSUB
		LDR		R4, [R6]
		LDR		R3, =dword_10B158
		LDR		R0, [R8]
		LDR		R2, [R4,#0x568]
		STR		R2, [R3]
		LDR		R2, [R4,#0x56C]
		STR		R2, [R3,#(dword_10B15C - 0x10B158)]
		LDR		R2, [R4,#0x570]
		STR		R2, [R3,#(dword_10B160 - 0x10B158)]
		LDR		R2, [R4,#0x55C]
		STR		R2, [R3,#(dword_10B164 - 0x10B158)]
		LDR		R2, [R4,#0x590]
		STR		R2, [R3,#(dword_10B168 - 0x10B158)]
		BL		pa_to_va

		STR		R0, [R4,#0x568]
		LDR		R0, [R8]
		BL		pa_to_va

		LDR		R4, [R6]
		LDR		R2, =0x80301
		MOV		R1, R7
		STR		R0, [R4,#0x56C]
		LDR		R3, [R6]
		MOV		R0, R7
		STR		R2, [R3,#0x570]
		LDR		R3, [R6]
		LDR		R2, =0x14000F0
		STR		R2, [R3,#0x55C]
		LDR		R3, [R6]
		MOV		R2, #0x2D0
		STR		R2, [R3,#0x590]
		MOV		R2, #0x140
		MOV		R3, #0xF0 ; 'ð'
		BL		sub_100270


loc_10703C				; CODE XREF: acquire_video+10j
		LDR		R3, [R5,#4]
		ADD		R3, R3,	#1
		STR		R3, [R5,#4]
		LDMFD		SP!, {R4-R8,PC}

; End of function acquire_video

; ---------------------------------------------------------------------------
off_10704C	DCD is_NTR_OSD_requested ; DATA	XREF: acquire_video+4r
off_107050	DCD va_mapped_io_LCD	; DATA XREF: acquire_video+14r
off_107054	DCD va_mapped_io_PDC	; DATA XREF: acquire_video+18r
off_107058	DCD pa_N3DS		; DATA XREF: acquire_video+1Cr
off_10705C	DCD dword_10B158	; DATA XREF: acquire_video+34r
dword_107060	DCD 0x80301		; DATA XREF: acquire_video+78r
dword_107064	DCD 0x14000F0		; DATA XREF: acquire_video+94r

; =============== S U B	R O U T	I N E =======================================


release_video				; CODE XREF: fatal_LR+20p
					; display_OSD_menu:loc_103478p	...
		LDR		R2, =is_NTR_OSD_requested
		LDR		R3, [R2,#(dword_10B14C - 0x10B148)]
		SUB		R3, R3,	#1
		CMP		R3, #0
		STR		R3, [R2,#(dword_10B14C - 0x10B148)]
		BXNE		LR

		LDR		R2, =va_mapped_io_PDC
		LDR		R3, =dword_10B158
		LDR		R1, [R2]
		LDR		R0, [R3]
		STR		R0, [R1,#0x568]
		LDR		R1, [R2]
		LDR		R0, [R3,#(dword_10B15C - 0x10B158)]
		STR		R0, [R1,#0x56C]
		LDR		R1, [R2]
		LDR		R0, [R3,#(dword_10B160 - 0x10B158)]
		STR		R0, [R1,#0x570]
		LDR		R1, [R2]
		LDR		R0, [R3,#(dword_10B164 - 0x10B158)]
		STR		R0, [R1,#0x55C]
		LDR		R2, [R2]
		LDR		R3, [R3,#(dword_10B168 - 0x10B158)]
		STR		R3, [R2,#0x590]
		BX		LR

; End of function release_video

; ---------------------------------------------------------------------------
off_1070C8	DCD is_NTR_OSD_requested ; DATA	XREF: release_videor
off_1070CC	DCD va_mapped_io_PDC	; DATA XREF: release_video+18r
off_1070D0	DCD dword_10B158	; DATA XREF: release_video+1Cr

; =============== S U B	R O U T	I N E =======================================

;
; #define CONTROLVIDEO_ACQUIREVIDEO 1
; #define CONTROLVIDEO_RELEASEVIDEO 2
; #define CONTROLVIDEO_GETFRAMEBUFFER 3
; #define CONTROLVIDEO_SETFRAMEBUFFER 4
; #define CONTROLVIDEO_UPDATESCREEN 5
;
;
; this code is messy since it corrupts memory
; at N3DS physical memory 0x1F000000

; int __cdecl controlVideo(unsigned int	cmd, unsigned int arg1,	unsigned int arg2, unsigned int	arg3)
controlVideo				; CODE XREF: create_screenshot_callback+5Cp
					; create_screenshot_callback+80p
					; DATA XREF: ...
		CMP		R0, #1
		STMFD		SP!, {R3,LR}
		BNE		loc_1070E8

		BL		acquire_video

		B		loc_107128

; ---------------------------------------------------------------------------

loc_1070E8				; CODE XREF: controlVideo+8j
		CMP		R0, #2
		BNE		loc_1070F8

		BL		release_video

		B		loc_107128

; ---------------------------------------------------------------------------

loc_1070F8				; CODE XREF: controlVideo+18j
		CMP		R0, #3
		BNE		set_framebuffer

get_framebuffer
		LDR		R3, =pa_N3DS
		LDR		R0, [R3]
		LDMFD		SP!, {R3,PC}

; ---------------------------------------------------------------------------

set_framebuffer				; CODE XREF: controlVideo+28j
		CMP		R0, #4
		LDREQ		R3, =pa_N3DS
		STREQ		R1, [R3]
		BEQ		loc_107128

		CMP		R0, #5
		BNE		locret_107130

		BL		update_screen


loc_107128				; CODE XREF: controlVideo+10j
					; controlVideo+20j ...
		MOV		R0, #0
		LDMFD		SP!, {R3,PC}

; ---------------------------------------------------------------------------

locret_107130				; CODE XREF: controlVideo+4Cj
		LDMFD		SP!, {R3,PC}

; End of function controlVideo

; ---------------------------------------------------------------------------
off_107134	DCD pa_N3DS		; DATA XREF: controlVideo+2Cr
					; controlVideo+3Cr

; =============== S U B	R O U T	I N E =======================================

; #define BUTTON_A     0x00000001
; #define BUTTON_B     0x00000002
; #define BUTTON_SE    0x00000004
; #define BUTTON_ST    0x00000008
; #define BUTTON_DR	0x00000010
; #define BUTTON_DL	0x00000020
; #define BUTTON_DU    0x00000040
; #define BUTTON_DD    0x00000080
; #define BUTTON_R    0x00000100
; #define BUTTON_L    0x00000200
; #define BUTTON_X     0x00000400
; #define BUTTON_Y     0x00000800

read_pad				; CODE XREF: is_BUTTON_DL_pressed+4p
					; thread_NTR_home_injectee:check_hotkey_loopp ...
		LDR		R3, =va_mapped_io_PAD
		LDR		R3, [R3]
		LDR		R0, [R3]
		MVN		R0, R0
		MOV		R0, R0,LSL#20
		MOV		R0, R0,LSR#20
		BX		LR

; End of function read_pad

; ---------------------------------------------------------------------------
off_107154	DCD va_mapped_io_PAD	; DATA XREF: read_padr

; =============== S U B	R O U T	I N E =======================================


wait_pad_input				; CODE XREF: get_process_list_action:loc_107274p
					; invoke_osd_wait_for_input+94p
		STMFD		SP!, {R4,LR}


loc_10715C				; CODE XREF: wait_pad_input+Cj
		BL		read_pad ; #define BUTTON_A	0x00000001
					; #define BUTTON_B     0x00000002
					; #define BUTTON_SE    0x00000004
					; #define BUTTON_ST    0x00000008
					; #define BUTTON_DR	0x00000010
					; #define BUTTON_DL	0x00000020
					; #define BUTTON_DU    0x00000040
					; #define BUTTON_DD    0x00000080
					; #define BUTTON_R    0x00000100
					; #define BUTTON_L    0x00000200
					; #define BUTTON_X     0x00000400
					; #define BUTTON_Y     0x00000800

		CMP		R0, #0
		BNE		loc_10715C


loc_107168				; CODE XREF: wait_pad_input+18j
					; wait_pad_input+28j
		BL		read_pad ; #define BUTTON_A	0x00000001
					; #define BUTTON_B     0x00000002
					; #define BUTTON_SE    0x00000004
					; #define BUTTON_ST    0x00000008
					; #define BUTTON_DR	0x00000010
					; #define BUTTON_DL	0x00000020
					; #define BUTTON_DU    0x00000040
					; #define BUTTON_DD    0x00000080
					; #define BUTTON_R    0x00000100
					; #define BUTTON_L    0x00000200
					; #define BUTTON_X     0x00000400
					; #define BUTTON_Y     0x00000800

		SUBS		R4, R0,	#0
		BEQ		loc_107168

		BL		sub_106EBC

		BL		read_pad ; #define BUTTON_A	0x00000001
					; #define BUTTON_B     0x00000002
					; #define BUTTON_SE    0x00000004
					; #define BUTTON_ST    0x00000008
					; #define BUTTON_DR	0x00000010
					; #define BUTTON_DL	0x00000020
					; #define BUTTON_DU    0x00000040
					; #define BUTTON_DD    0x00000080
					; #define BUTTON_R    0x00000100
					; #define BUTTON_L    0x00000200
					; #define BUTTON_X     0x00000400
					; #define BUTTON_Y     0x00000800

		CMP		R4, R0
		BNE		loc_107168

		LDMFD		SP!, {R4,PC}

; End of function wait_pad_input


; =============== S U B	R O U T	I N E =======================================

; returns
; 0 - dump
; 1 - info

get_process_list_action			; CODE XREF: sub_100F48+148p
					; display_OSD_menu+7Cp	...

var_100		= -0x100
var_FC		= -0xFC
var_F4		= -0xF4
var_F0		= -0xF0

		STMFD		SP!, {R4-R11,LR}
		MOV		R6, R1
		LDR		R9, =asc_10A88D	; " * "
		LDR		R10, =asc_10A891 ; "   "
		SUB		SP, SP,	#0xDC
		MOV		R8, R2
		MOV		R4, #0
		STR		R0, [SP,#0x100+var_F4]


loc_1071A8				; CODE XREF: get_process_list_action+10Cj
					; get_process_list_action+120j	...
		MOV		R0, #0
		MOV		R1, R0
		MOV		R2, #0x140
		MOV		R3, #0xF0 ; 'ð'
		BL		sub_100270

		MOV		R5, #0
		MOV		R1, #0xA
		MOV		R2, R1
		STR		R5, [SP,#0x100+var_100]
		STR		R5, [SP,#0x100+var_FC]
		MOV		R3, #0xFF
		LDR		R0, [SP,#0x100+var_F4]
		BL		display_stuff

		MOV		R3, #0xFF
		STR		R5, [SP,#0x100+var_100]
		STR		R3, [SP,#0x100+var_FC]
		MOV		R1, #0xA
		MOV		R3, R5
		MOV		R2, #0xDC ; 'Ü'
		LDR		R0, =aHttp44670_orgN ; "http://44670.org/ntr"
		BL		display_stuff

		MOV		R0, R4
		MOV		R1, #0x12
		BL		sub_108224

		MOV		R5, #0x12
		MOV		R7, #0x1E
		MUL		R5, R5,	R0
		ADD		R11, R5, #0x12
		CMP		R11, R6
		MOVCS		R11, R6


loc_107220				; CODE XREF: get_process_list_action+E4j
		CMP		R5, R11
		BCS		loc_107270

		CMP		R5, R4
		MOVEQ		R1, R9
		MOVNE		R1, R10
		ADD		R0, SP,	#0x100+var_F0
		BL		strncpy_

		LDR		R1, [R8,R5,LSL#2]
		ADD		R0, SP,	#0x100+var_F0
		BL		sub_107E2C

		MOV		R3, #0
		MOV		R2, R7
		STR		R3, [SP,#0x100+var_100]
		STR		R3, [SP,#0x100+var_FC]
		ADD		R0, SP,	#0x100+var_F0
		MOV		R1, #0xA
		BL		display_stuff

		ADD		R7, R7,	#0xA
		ADD		R5, R5,	#1
		B		loc_107220

; ---------------------------------------------------------------------------

loc_107270				; CODE XREF: get_process_list_action+9Cj
		BL		update_screen


loc_107274				; CODE XREF: get_process_list_action+F4j
		BL		wait_pad_input

		CMP		R0, #0
		BEQ		loc_107274

		CMP		R0, #0x80 ; '€'
		BNE		loc_107298

		ADD		R4, R4,	#1
		CMP		R4, R6
		MOVCS		R4, #0
		B		loc_1071A8

; ---------------------------------------------------------------------------

loc_107298				; CODE XREF: get_process_list_action+FCj
		CMP		R0, #0x40 ; '@'
		BNE		loc_1072AC

		SUBS		R4, R4,	#1
		SUBMI		R4, R6,	#1
		B		loc_1071A8

; ---------------------------------------------------------------------------

loc_1072AC				; CODE XREF: get_process_list_action+114j
		CMP		R0, #1
		BEQ		loc_1072C4

		CMP		R0, #2
		BNE		loc_1071A8

		MOV		R0, #0xFFFFFFFF
		B		loc_1072C8

; ---------------------------------------------------------------------------

loc_1072C4				; CODE XREF: get_process_list_action+128j
		MOV		R0, R4


loc_1072C8				; CODE XREF: get_process_list_action+138j
		ADD		SP, SP,	#0xDC
		LDMFD		SP!, {R4-R11,PC}

; End of function get_process_list_action

; ---------------------------------------------------------------------------
off_1072D0	DCD asc_10A88D		; DATA XREF: get_process_list_action+8r
					; " * "
off_1072D4	DCD asc_10A891		; DATA XREF: get_process_list_action+Cr
					; "   "
off_1072D8	DCD aHttp44670_orgN	; DATA XREF: get_process_list_action+6Cr
					; "http://44670.org/ntr"

; =============== S U B	R O U T	I N E =======================================


invoke_osd_wait_for_input		; CODE XREF: sub_100F48:loc_101078p
					; ROM:00101160p ...

var_18		= -0x18
var_14		= -0x14

		LDR		R3, =some_callback
		STMFD		SP!, {R0-R2,R4,R5,LR}
		LDR		R4, [R3]
		CMP		R4, #0
		BEQ		loc_107304

		BLX		R4

		LDR		R0, =0x3B9ACA00
		MOV		R1, #0
		BL		SleepThread

		B		loc_107384

; ---------------------------------------------------------------------------

loc_107304				; CODE XREF: invoke_osd_wait_for_input+10j
		LDR		R3, =is_NTR_OSD_requested
		LDR		R3, [R3]
		CMP		R3, #0
		BEQ		loc_107384

		MOV		R5, R0
		BL		acquire_video


loc_10731C				; CODE XREF: invoke_osd_wait_for_input+9Cj
		MOV		R0, #0
		MOV		R1, R0
		MOV		R2, #0x140
		MOV		R3, #0xF0 ; 'ð'
		BL		sub_100270

		MOV		R1, #0xA
		MOV		R2, R1
		MOV		R3, #0xFF
		STR		R4, [SP,#0x18+var_18]
		STR		R4, [SP,#0x18+var_14]
		MOV		R0, R5
		BL		display_stuff

		MOV		R3, #0xFF
		MOV		R1, #0xA
		MOV		R2, #0xDC ; 'Ü'
		STR		R3, [SP,#0x18+var_14]
		STR		R4, [SP,#0x18+var_18]
		MOV		R3, #0
		LDR		R0, =aPressBToClose_ ; "Press [B] to close."
		BL		display_stuff

		BL		update_screen

		BL		wait_pad_input

		CMP		R0, #2
		BNE		loc_10731C

		BL		release_video

		MOV		R0, #0


loc_107384				; CODE XREF: invoke_osd_wait_for_input+24j
					; invoke_osd_wait_for_input+34j
		ADD		SP, SP,	#0xC
		LDMFD		SP!, {R4,R5,PC}

; End of function invoke_osd_wait_for_input

; ---------------------------------------------------------------------------
off_10738C	DCD some_callback	; DATA XREF: invoke_osd_wait_for_inputr
dword_107390	DCD 0x3B9ACA00		; DATA XREF: invoke_osd_wait_for_input+18r
off_107394	DCD is_NTR_OSD_requested ; DATA	XREF: invoke_osd_wait_for_input:loc_107304r
off_107398	DCD aPressBToClose_	; DATA XREF: invoke_osd_wait_for_input+88r
					; "Press [B] to close."

; =============== S U B	R O U T	I N E =======================================


showDbg					; CODE XREF: fatal_LR+18p
					; set_KProcess_refcount_to_1+24p ...
		STMFD		SP!, {R4-R6,LR}
		MOV		R6, R0
		SUB		SP, SP,	#0x190
		MOV		R5, R1
		MOV		R4, R2
		BL		nsDbgPrint

		MOV		R0, SP
		MOV		R1, R6
		MOV		R2, R5
		MOV		R3, R4
		BL		xsprintf

		MOV		R0, SP
		BL		invoke_osd_wait_for_input

		ADD		SP, SP,	#0x190
		LDMFD		SP!, {R4-R6,PC}

; End of function showDbg


; =============== S U B	R O U T	I N E =======================================


sub_1073D8

var_4		= -4

		LDR		R3, =va_mapped_io_LCD
		LDR		R1, =0x1869F
		SUB		SP, SP,	#8
		LDR		R2, [R3]
		STR		R0, [R2,#0x204]
		MOV		R2, #0
		STR		R2, [SP,#8+var_4]


loc_1073F4				; CODE XREF: sub_1073D8+30j
		LDR		R2, [SP,#8+var_4]
		CMP		R2, R1
		LDRLS		R2, [SP,#8+var_4]
		ADDLS		R2, R2,	#1
		STRLS		R2, [SP,#8+var_4]
		BLS		loc_1073F4

		LDR		R2, [R3]
		MOV		R3, #0
		STR		R3, [R2,#0x204]
		LDR		R2, =0x1869F
		STR		R3, [SP,#8+var_4]


loc_107420				; CODE XREF: sub_1073D8+5Cj
		LDR		R3, [SP,#8+var_4]
		CMP		R3, R2
		LDRLS		R3, [SP,#8+var_4]
		ADDLS		R3, R3,	#1
		STRLS		R3, [SP,#8+var_4]
		BLS		loc_107420

		ADD		SP, SP,	#8
		BX		LR

; End of function sub_1073D8

; ---------------------------------------------------------------------------
off_107440	DCD va_mapped_io_LCD	; DATA XREF: sub_1073D8r
dword_107444	DCD 0x1869F		; DATA XREF: sub_1073D8+4r
					; sub_1073D8+40r

; =============== S U B	R O U T	I N E =======================================


sub_107448				; CODE XREF: sub_107448+10j
					; ROM:001074D8p ...
		MOV		R3, R0
		ADD		R0, R0,	#1
		LDRB		R2, [R3]
		CMP		R2, #0
		BNE		sub_107448

		SUB		R1, R1,	#1


loc_107460				; CODE XREF: sub_107448+24j
		LDRB		R2, [R1,#1]!
		CMP		R2, #0
		STRNEB		R2, [R3],#1
		BNE		loc_107460

		STRB		R2, [R3]
		BX		LR

; End of function sub_107448


; =============== S U B	R O U T	I N E =======================================


sub_107478				; CODE XREF: ROM:001074F0p

var_4		= -4

		STR		LR, [SP,#var_4]!
		MOV		R3, R1
		ADD		LR, R1,	#8


loc_107484				; CODE XREF: sub_107478+28j
		MOV		R12, R0,LSR#28
		ADD		R2, R12, #0x30
		CMP		R2, #0x39 ; '9'
		ADDHI		R2, R12, #0x37
		STRB		R2, [R3],#1
		CMP		R3, LR
		MOV		R0, R0,LSL#4
		BNE		loc_107484

		MOV		R3, #0
		STRB		R3, [R1,#8]
		LDR		PC, [SP+4+var_4],#4

; End of function sub_107478

; ---------------------------------------------------------------------------
		STMFD		SP!, {R4-R7,LR}
		SUB		SP, SP,	#0x11C
		ADD		R4, SP,	#0x118
		MOV		R5, #0
		STRB		R5, [R4,#-0xC8]!
		MOV		R7, R0
		MOV		R6, R1
		MOV		R0, R4
		LDR		R1, =aDbg ; "/dbg"
		STR		R5, [SP,#0x2C]
		BL		sub_107448

		MOV		R0, R4
		MOV		R1, R7
		BL		sub_107448

		MOV		R0, R6
		ADD		R1, SP,	#0x3C
		BL		sub_107478

		ADD		R1, SP,	#0x3C
		MOV		R0, R4
		BL		sub_107448

		MOV		R3, #3
		MOV		R0, R4
		STRB		R3, [SP,#0x30]
		BL		strlen_

		ADD		R2, SP,	#0x30
		STR		R4, [SP,#0x38]
		ADD		R3, SP,	#0x10
		LDR		R12, =dword_108364
		ADD		R0, R0,	#1
		STR		R0, [SP,#0x34]
		LDMIA		R2, {R0-R2}
		STMIA		R3, {R0-R2}
		MOV		R3, #7
		STR		R3, [SP,#0x1C]
		ADD		R3, R12, #8
		STR		R5, [SP,#0x20]
		LDMIA		R3, {R0-R3}
		STMEA		SP, {R0-R3}
		LDR		R1, =hFSUser
		LDMIA		R12, {R2,R3}
		LDR		R0, [R1]
		ADD		R1, SP,	#0x2C
		BL		openFile_

		LDR		R0, [SP,#0x2C]
		CMP		R0, R5
		BEQ		loc_10756C

		BL		FSFile_Close


loc_10756C				; CODE XREF: ROM:00107564j
		ADD		SP, SP,	#0x11C
		LDMFD		SP!, {R4-R7,PC}

; ---------------------------------------------------------------------------
off_107574	DCD aDbg		; DATA XREF: ROM:001074D0r
					; "/dbg"
off_107578	DCD dword_108364	; DATA XREF: ROM:0010751Cr
off_10757C	DCD hFSUser		; DATA XREF: ROM:00107548r

; =============== S U B	R O U T	I N E =======================================


call_plugin_callback			; CODE XREF: sub_1075BC+14p
					; ROM:00107600p ...
		LDR		R2, =dword_10B180
		MOV		R1, R0
		LDR		R3, [R2]
		CMP		R3, #0
		ADDNE		R0, R3,	#1
		STRNE		R0, [R2]
		STRNEB		R1, [R3]
		BXNE		LR

		LDR		R3, =cb_plugin_info ; will point to update_plugin_info
		LDR		R3, [R3] ; will	point to update_plugin_info
		CMP		R3, #0
		BXEQ		LR

		BX		R3

; End of function call_plugin_callback

; ---------------------------------------------------------------------------
off_1075B4	DCD dword_10B180	; DATA XREF: call_plugin_callbackr
off_1075B8	DCD cb_plugin_info	; DATA XREF: call_plugin_callback+20r
					; will point to	update_plugin_info

; =============== S U B	R O U T	I N E =======================================


sub_1075BC				; CODE XREF: sub_107614+140p
		STMFD		SP!, {R4,LR}
		SUB		R4, R0,	#1


loc_1075C4				; CODE XREF: sub_1075BC+18j
		LDRB		R0, [R4,#1]!
		CMP		R0, #0
		BEQ		locret_1075D8

		BL		call_plugin_callback

		B		loc_1075C4

; ---------------------------------------------------------------------------

locret_1075D8				; CODE XREF: sub_1075BC+10j
		LDMFD		SP!, {R4,PC}

; End of function sub_1075BC

; ---------------------------------------------------------------------------
		LDR		R3, =cb_plugin_info ; will point to update_plugin_info
		STMFD		SP!, {R4-R6,LR}
		SUB		R5, R1,	#1
		MOV		R4, R3
		LDR		R6, [R3] ; will	point to update_plugin_info
		STR		R0, [R3] ; will	point to update_plugin_info


loc_1075F4				; CODE XREF: ROM:00107604j
		LDRB		R0, [R5,#1]!
		CMP		R0, #0
		BEQ		loc_107608

		BL		call_plugin_callback

		B		loc_1075F4

; ---------------------------------------------------------------------------

loc_107608				; CODE XREF: ROM:001075FCj
		STR		R6, [R4] ; will	point to update_plugin_info
		LDMFD		SP!, {R4-R6,PC}

; ---------------------------------------------------------------------------
off_107610	DCD cb_plugin_info	; DATA XREF: ROM:001075DCr
					; will point to	update_plugin_info

; =============== S U B	R O U T	I N E =======================================


sub_107614				; CODE XREF: nsDbgPrint+3Cp
					; sub_1078D0+14p ...

var_40		= -0x40
var_3C		= -0x3C
var_38		= -0x38
var_28		= -0x28

		STMFD		SP!, {R4-R11,LR}
		MOV		R3, R0
		SUB		SP, SP,	#0x1C
		MOV		R5, R1


loc_107624				; CODE XREF: sub_107614+154j
		LDRB		R0, [R3]
		CMP		R0, #0
		BEQ		loc_1078C8

		CMP		R0, #0x25 ; '%'
		ADDNE		R7, R3,	#1
		BNE		loc_107798

		LDRB		R4, [R3,#1]
		CMP		R4, #0x30 ; '0'
		ADDEQ		R7, R3,	#3
		LDREQB		R4, [R3,#2]
		MOVEQ		R9, #1
		BEQ		loc_10766C

		CMP		R4, #0x2D ; '-'
		ADDNE		R7, R3,	#2
		LDREQB		R4, [R3,#2]
		MOVNE		R9, #0
		ADDEQ		R7, R3,	#3
		MOVEQ		R9, #2


loc_10766C				; CODE XREF: sub_107614+3Cj
		MOV		R8, #0
		MOV		R2, #0xA


loc_107674				; CODE XREF: sub_107614+74j
		SUB		R3, R4,	#0x30
		CMP		R3, #9
		MLALS		R8, R2,	R8, R4
		LDRLSB		R4, [R7],#1
		SUBLS		R8, R8,	#0x30
		BLS		loc_107674

		AND		R2, R4,	#0xDF
		CMP		R2, #0x4C ; 'L'
		MOV		R3, R7
		ORREQ		R9, R9,	#4
		LDREQB		R4, [R3]
		ADDEQ		R7, R7,	#1
		CMP		R4, #0
		BEQ		loc_1078C8

		CMP		R4, #0x60 ; '`'
		SUBHI		R3, R4,	#0x20
		MOVLS		R3, R4
		UXTBHI		R3, R3
		CMP		R3, #0x4F ; 'O'
		BEQ		loc_107710

		BHI		loc_1076E8

		CMP		R3, #0x43 ; 'C'
		BEQ		loc_10777C

		CMP		R3, #0x44 ; 'D'
		BEQ		loc_1077A4

		CMP		R3, #0x42 ; 'B'
		MOVEQ		R11, #2
		BEQ		loc_1077A8

		B		loc_107794

; ---------------------------------------------------------------------------

loc_1076E8				; CODE XREF: sub_107614+B0j
		CMP		R3, #0x55 ; 'U'
		BEQ		loc_1077A4

		CMP		R3, #0x58 ; 'X'
		BEQ		loc_10778C

		CMP		R3, #0x53 ; 'S'
		BNE		loc_107794

		ADD		R6, R5,	#4
		LDR		R5, [R5]
		MOV		R3, R5
		B		loc_107718

; ---------------------------------------------------------------------------

loc_107710				; CODE XREF: sub_107614+ACj
		MOV		R11, #8
		B		loc_1077A8

; ---------------------------------------------------------------------------

loc_107718				; CODE XREF: sub_107614+F8j
					; sub_107614+110j
		RSB		R4, R5,	R3
		LDRB		R2, [R3],#1
		CMP		R2, #0
		BNE		loc_107718

		TST		R9, #2
		BNE		loc_107750


loc_107730				; CODE XREF: sub_107614+134j
		CMP		R4, R8
		ADD		R9, R4,	#1
		BCS		loc_10774C

		MOV		R0, #0x20 ; ' '
		BL		call_plugin_callback

		MOV		R4, R9
		B		loc_107730

; ---------------------------------------------------------------------------

loc_10774C				; CODE XREF: sub_107614+124j
		MOV		R4, R9


loc_107750				; CODE XREF: sub_107614+118j
		MOV		R0, R5
		BL		sub_1075BC


loc_107758				; CODE XREF: sub_107614+164j
		CMP		R4, R8
		BCC		loc_10776C


loc_107760				; CODE XREF: sub_107614+174j
					; sub_107614+18Cj ...
		MOV		R5, R6
		MOV		R3, R7
		B		loc_107624

; ---------------------------------------------------------------------------

loc_10776C				; CODE XREF: sub_107614+148j
		MOV		R0, #0x20 ; ' '
		BL		call_plugin_callback

		ADD		R4, R4,	#1
		B		loc_107758

; ---------------------------------------------------------------------------

loc_10777C				; CODE XREF: sub_107614+B8j
		LDRB		R0, [R5]
		ADD		R6, R5,	#4
		BL		call_plugin_callback

		B		loc_107760

; ---------------------------------------------------------------------------

loc_10778C				; CODE XREF: sub_107614+E0j
		MOV		R11, #0x10
		B		loc_1077A8

; ---------------------------------------------------------------------------

loc_107794				; CODE XREF: sub_107614+D0j
					; sub_107614+E8j
		MOV		R0, R4


loc_107798				; CODE XREF: sub_107614+24j
		BL		call_plugin_callback

		MOV		R6, R5
		B		loc_107760

; ---------------------------------------------------------------------------

loc_1077A4				; CODE XREF: sub_107614+C0j
					; sub_107614+D8j
		MOV		R11, #0xA


loc_1077A8				; CODE XREF: sub_107614+CCj
					; sub_107614+100j ...
		LDR		R10, [R5]
		SUB		R3, R3,	#0x44
		CLZ		R3, R3
		MOV		R3, R3,LSR#5
		ANDS		R3, R3,	R10,LSR#31
		ADD		R6, R5,	#4
		RSBNE		R10, R10, #0
		ORRNE		R9, R9,	#8
		MOV		R5, #0


loc_1077CC				; CODE XREF: sub_107614+22Cj
		MOV		R0, R10
		MOV		R1, R11
		BL		sub_108318

		MOV		R0, R10
		UXTB		R3, R1
		STR		R1, [SP,#0x40+var_3C]
		MOV		R1, R11
		STR		R3, [SP,#0x40+var_40]
		BL		sub_108224

		LDR		R2, [SP,#0x40+var_3C]
		LDR		R3, [SP,#0x40+var_40]
		CMP		R2, #9
		MOV		R10, R0
		BLS		loc_107818

		CMP		R4, #0x78 ; 'x'
		MOVEQ		R2, #0x27 ; '''
		MOVNE		R2, #7
		ADD		R3, R2,	R3
		UXTB		R3, R3


loc_107818				; CODE XREF: sub_107614+1ECj
		ADD		R5, R5,	#1
		ADD		R2, SP,	#0x40+var_38
		ADD		R2, R2,	R5
		ADD		R3, R3,	#0x30
		STRB		R3, [R2,#-1]
		MOVS		R3, R10
		MOVNE		R3, #1
		CMP		R5, #0xF
		MOVHI		R3, #0
		CMP		R3, #0
		BNE		loc_1077CC

		TST		R9, #8
		ADDNE		R2, SP,	#0x40+var_28
		MOV		R3, R5
		ADDNE		R3, R2,	R3
		MOVNE		R2, #0x2D ; '-'
		ADDNE		R5, R5,	#1
		STRNEB		R2, [R3,#-0x10]
		TST		R9, #1
		MOVNE		R10, #0x30 ; '0'
		MOVEQ		R10, #0x20 ; ' '
		TST		R9, #2
		MOV		R4, R5
		BNE		loc_107898


loc_107878				; CODE XREF: sub_107614+27Cj
		CMP		R4, R8
		ADD		R9, R4,	#1
		BCS		loc_107894

		MOV		R0, R10
		BL		call_plugin_callback

		MOV		R4, R9
		B		loc_107878

; ---------------------------------------------------------------------------

loc_107894				; CODE XREF: sub_107614+26Cj
		MOV		R4, R9


loc_107898				; CODE XREF: sub_107614+260j
					; sub_107614+298j
		SUB		R5, R5,	#1
		ADD		R3, SP,	#0x40+var_38
		LDRB		R0, [R3,R5]
		BL		call_plugin_callback

		CMP		R5, #0
		BNE		loc_107898


loc_1078B0				; CODE XREF: sub_107614+2B0j
		CMP		R4, R8
		BCS		loc_107760

		MOV		R0, #0x20 ; ' '
		BL		call_plugin_callback

		ADD		R4, R4,	#1
		B		loc_1078B0

; ---------------------------------------------------------------------------

loc_1078C8				; CODE XREF: sub_107614+18j
					; sub_107614+94j
		ADD		SP, SP,	#0x1C
		LDMFD		SP!, {R4-R11,PC}

; End of function sub_107614


; =============== S U B	R O U T	I N E =======================================


sub_1078D0				; CODE XREF: printf_hexnum+14p
					; printf_hexnum+48p ...

var_1C		= -0x1C
var_14		= -0x14
varg_r0		= -0x10
varg_r1		= -0xC
varg_r2		= -8
varg_r3		= -4

		STMFD		SP!, {R0-R3}
		STMFD		SP!, {R0-R2,LR}
		ADD		R1, SP,	#0x20+varg_r1
		LDR		R0, [SP,#0x20+varg_r0]
		STR		R1, [SP,#0x20+var_1C]
		BL		sub_107614

		ADD		SP, SP,	#0xC
		LDR		LR, [SP+0x14+var_14],#4
		ADD		SP, SP,	#0x10
		BX		LR

; End of function sub_1078D0


; =============== S U B	R O U T	I N E =======================================


xsprintf				; CODE XREF: sub_100F48+9Cp
					; sub_100F48+168p ...

var_1C		= -0x1C
varg_r1		= -0xC
varg_r2		= -8
varg_r3		= -4

		STMFD		SP!, {R1-R3}
		STMFD		SP!, {R0-R2,R4,LR}
		ADD		R1, SP,	#0x20+varg_r2
		LDR		R4, =dword_10B180
		STR		R1, [SP,#0x20+var_1C]
		STR		R0, [R4]
		LDR		R0, [SP,#0x20+varg_r1]
		BL		sub_107614

		LDR		R2, [R4]
		MOV		R3, #0
		STR		R3, [R4]
		STRB		R3, [R2]
		ADD		SP, SP,	#0xC
		LDMFD		SP!, {R4,LR}
		ADD		SP, SP,	#0xC
		BX		LR

; End of function xsprintf

; ---------------------------------------------------------------------------
off_107938	DCD dword_10B180	; DATA XREF: xsprintf+Cr
; ---------------------------------------------------------------------------
		STMFD		SP!, {R1-R3}
		STMFD		SP!, {R0,R1,R4,R5,LR}
		ADD		R1, SP,	#0x18
		LDR		R4, =cb_plugin_info ; will point to update_plugin_info
		STR		R1, [SP,#4]
		LDR		R5, [R4] ; will	point to update_plugin_info
		STR		R0, [R4] ; will	point to update_plugin_info
		LDR		R0, [SP,#0x14]
		BL		sub_107614

		STR		R5, [R4] ; will	point to update_plugin_info
		ADD		SP, SP,	#8
		LDMFD		SP!, {R4,R5,LR}
		ADD		SP, SP,	#0xC
		BX		LR

; ---------------------------------------------------------------------------
off_107974	DCD cb_plugin_info	; DATA XREF: ROM:00107948r
					; will point to	update_plugin_info

; =============== S U B	R O U T	I N E =======================================


printf_hexnum
		STMFD		SP!, {R4-R6,LR}
		MOV		R6, R3
		MOV		R5, R0
		LDR		R0, =a08lx ; "%08lX "
		MOV		R4, R2
		BL		sub_1078D0

		CMP		R6, #2
		BEQ		loc_1079FC

		CMP		R6, #4
		BEQ		loc_107A14

		CMP		R6, #1
		MOVEQ		R6, R5
		BNE		loc_107A28


loc_1079AC				; CODE XREF: printf_hexnum+4Cj
		RSB		R3, R5,	R6
		CMP		R3, R4
		BGE		loc_1079C8

		LDR		R0, =a02x ; " %02X"
		LDRB		R1, [R6],#1
		BL		sub_1078D0

		B		loc_1079AC

; ---------------------------------------------------------------------------

loc_1079C8				; CODE XREF: printf_hexnum+3Cj
		MOV		R0, #0x20 ; ' '
		BL		call_plugin_callback

		MOV		R6, R5


loc_1079D4				; CODE XREF: printf_hexnum+80j
		RSB		R3, R5,	R6
		CMP		R3, R4
		BGE		loc_107A28

		LDRB		R3, [R6],#1
		SUB		R0, R3,	#0x20
		CMP		R0, #0x5E ; '^'
		MOVLS		R0, R3
		MOVHI		R0, #0x2E ; '.'
		BL		call_plugin_callback

		B		loc_1079D4

; ---------------------------------------------------------------------------

loc_1079FC				; CODE XREF: printf_hexnum+1Cj
					; printf_hexnum+94j
		LDR		R0, =a04x ; " %04X"
		LDRH		R1, [R5],#2
		BL		sub_1078D0

		SUBS		R4, R4,	#1
		BNE		loc_1079FC

		B		loc_107A28

; ---------------------------------------------------------------------------

loc_107A14				; CODE XREF: printf_hexnum+24j
					; printf_hexnum+ACj
		LDR		R0, =a08lx_0 ; " %08LX"
		LDR		R1, [R5],#4
		BL		sub_1078D0

		SUBS		R4, R4,	#1
		BNE		loc_107A14


loc_107A28				; CODE XREF: printf_hexnum+30j
					; printf_hexnum+64j ...
		MOV		R0, #0xA
		LDMFD		SP!, {R4-R6,LR}
		B		call_plugin_callback

; End of function printf_hexnum

; ---------------------------------------------------------------------------
off_107A34	DCD a08lx		; DATA XREF: printf_hexnum+Cr
					; "%08lX "
off_107A38	DCD a02x		; DATA XREF: printf_hexnum+40r
					; " %02X"
off_107A3C	DCD a04x		; DATA XREF: printf_hexnum:loc_1079FCr
					; " %04X"
off_107A40	DCD a08lx_0		; DATA XREF: printf_hexnum:loc_107A14r
					; " %08LX"

; =============== S U B	R O U T	I N E =======================================


sub_107A44				; CODE XREF: ROM:00107B10p
		LDR		R3, =off_10B184
		LDR		R2, [R3]
		CMP		R2, #0
		BEQ		loc_107AEC

		STMFD		SP!, {R4-R8,LR}
		MOV		R7, R3
		MOV		R6, R0
		MOV		R4, #0
		SUB		R5, R1,	#1


loc_107A68				; CODE XREF: sub_107A44+68j
					; sub_107A44+70j ...
		LDR		R3, [R7]
		BLX		R3

		SUBS		R3, R0,	#0
		BNE		loc_107A80

		MOV		R0, #0
		LDMFD		SP!, {R4-R8,PC}

; ---------------------------------------------------------------------------

loc_107A80				; CODE XREF: sub_107A44+30j
		CMP		R3, #0xD
		BEQ		loc_107AD4

		CMP		R4, #0
		SUB		R2, R3,	#8
		CLZ		R2, R2
		MOV		R2, R2,LSR#5
		MOVEQ		R2, #0
		CMP		R2, #0
		BEQ		loc_107AB0

		SUB		R4, R4,	#1
		BL		call_plugin_callback

		B		loc_107A68

; ---------------------------------------------------------------------------

loc_107AB0				; CODE XREF: sub_107A44+5Cj
		CMP		R3, #0x1F
		BLE		loc_107A68

		CMP		R4, R5
		BGE		loc_107A68

		STRB		R3, [R6,R4]
		ADD		R8, R4,	#1
		BL		call_plugin_callback

		MOV		R4, R8
		B		loc_107A68

; ---------------------------------------------------------------------------

loc_107AD4				; CODE XREF: sub_107A44+40j
		MOV		R3, #0
		STRB		R3, [R6,R4]
		MOV		R0, #0xA
		BL		call_plugin_callback

		MOV		R0, #1
		LDMFD		SP!, {R4-R8,PC}

; ---------------------------------------------------------------------------

loc_107AEC				; CODE XREF: sub_107A44+Cj
		MOV		R0, #0
		BX		LR

; End of function sub_107A44

; ---------------------------------------------------------------------------
off_107AF4	DCD off_10B184		; DATA XREF: sub_107A44r
; ---------------------------------------------------------------------------
		STMFD		SP!, {R3-R5,LR}
		LDR		R4, =off_10B184
		LDR		R5, [R4]
		STR		R0, [R4]
		MOV		R0, R1
		MOV		R1, R2
		BL		sub_107A44

		STR		R5, [R4]
		LDMFD		SP!, {R3-R5,PC}

; ---------------------------------------------------------------------------
off_107B1C	DCD off_10B184		; DATA XREF: ROM:00107AFCr
; ---------------------------------------------------------------------------
		MOV		R3, #0
		STR		R3, [R1]


loc_107B28				; CODE XREF: ROM:00107B3Cj
		LDR		R2, [R0]
		LDRB		R3, [R2]
		CMP		R3, #0x20 ; ' '
		ADDEQ		R2, R2,	#1
		STREQ		R2, [R0]
		BEQ		loc_107B28

		CMP		R3, #0x2D ; '-'
		ADDEQ		R3, R2,	#1
		STMFD		SP!, {R4,LR}
		MOVEQ		R4, #1
		STREQ		R3, [R0]
		LDREQB		R3, [R2,#1]
		MOVNE		R4, #0
		CMP		R3, #0x30 ; '0'
		BNE		loc_107BCC

		LDR		R2, [R0]
		ADD		R3, R2,	#1
		STR		R3, [R0]
		LDRB		R3, [R2,#1]
		CMP		R3, #0x62 ; 'b'
		BEQ		loc_107B98

		CMP		R3, #0x78 ; 'x'
		BNE		loc_107BAC

		ADD		R3, R2,	#2
		STR		R3, [R0]
		MOV		LR, #0x10
		LDRB		R3, [R2,#2]
		B		loc_107BDC

; ---------------------------------------------------------------------------

loc_107B98				; CODE XREF: ROM:00107B78j
		ADD		R3, R2,	#2
		STR		R3, [R0]
		MOV		LR, #2
		LDRB		R3, [R2,#2]
		B		loc_107BDC

; ---------------------------------------------------------------------------

loc_107BAC				; CODE XREF: ROM:00107B80j
		CMP		R3, #0x20 ; ' '
		BLS		loc_107C40

		SUB		R2, R3,	#0x30
		CMP		R2, #9
		MOVLS		LR, #8
		BLS		loc_107BDC


loc_107BC4				; CODE XREF: ROM:00107BD8j
					; ROM:00107C10j ...
		MOV		R0, #0
		LDMFD		SP!, {R4,PC}

; ---------------------------------------------------------------------------

loc_107BCC				; CODE XREF: ROM:00107B60j
		SUB		R2, R3,	#0x30
		CMP		R2, #9
		MOVLS		LR, #0xA
		BHI		loc_107BC4


loc_107BDC				; CODE XREF: ROM:00107B94j
					; ROM:00107BA8j ...
		MOV		R12, #0


loc_107BE0				; CODE XREF: ROM:00107C30j
		CMP		R3, #0x20 ; ' '
		BLS		loc_107C34

		CMP		R3, #0x60 ; '`'
		SUBHI		R3, R3,	#0x20
		UXTBHI		R3, R3
		SUB		R2, R3,	#0x30
		UXTB		R2, R2
		CMP		R2, #0x10
		BLS		loc_107C14

		SUB		R3, R3,	#0x37
		UXTB		R2, R3
		CMP		R2, #9
		BLS		loc_107BC4


loc_107C14				; CODE XREF: ROM:00107C00j
		CMP		R2, LR
		BCS		loc_107BC4

		LDR		R3, [R0]
		MLA		R12, LR, R12, R2
		ADD		R2, R3,	#1
		STR		R2, [R0]
		LDRB		R3, [R3,#1]
		B		loc_107BE0

; ---------------------------------------------------------------------------

loc_107C34				; CODE XREF: ROM:00107BE4j
		CMP		R4, #0
		RSBNE		R12, R12, #0
		STR		R12, [R1]


loc_107C40				; CODE XREF: ROM:00107BB0j
		MOV		R0, #1
		LDMFD		SP!, {R4,PC}


; =============== S U B	R O U T	I N E =======================================


memcpy					; CODE XREF: handle_writemem_packet:loc_102514p
					; handle_readmem_packet:loc_102670p ...
		CMP		R2, #0xF
		STMFD		SP!, {R4-R6,LR}
		BLS		loc_107CFC

		ORR		R3, R0,	R1
		TST		R3, #3
		BNE		loc_107D28

		MOV		LR, R2
		ADD		R12, R0, #0x10
		ADD		R3, R1,	#0x10


loc_107C6C				; CODE XREF: memcpy+54j
		LDR		R4, [R3,#-0x10]
		STR		R4, [R12,#-0x10]
		LDR		R4, [R3,#-0xC]
		STR		R4, [R12,#-0xC]
		LDR		R4, [R3,#-8]
		STR		R4, [R12,#-8]
		SUB		LR, LR,	#0x10
		LDR		R4, [R3,#-4]
		CMP		LR, #0xF
		STR		R4, [R12,#-4]
		ADD		R3, R3,	#0x10
		ADD		R12, R12, #0x10
		BHI		loc_107C6C

		SUB		R3, R2,	#0x10
		BIC		R3, R3,	#0xF
		AND		R6, R2,	#0xF
		ADD		R3, R3,	#0x10
		CMP		R6, #3
		ADD		R1, R1,	R3
		ADD		R3, R0,	R3
		BLS		loc_107D30

		MOV		R4, R1
		MOV		R12, R6
		SUB		LR, R3,	#4


loc_107CCC				; CODE XREF: memcpy+94j
		SUB		R12, R12, #4
		LDR		R5, [R4],#4
		CMP		R12, #3
		STR		R5, [LR,#4]!
		BHI		loc_107CCC

		SUB		R12, R6, #4
		BIC		R12, R12, #3
		ADD		R12, R12, #4
		ADD		R3, R3,	R12
		ADD		R1, R1,	R12
		AND		R2, R2,	#3
		B		loc_107D00

; ---------------------------------------------------------------------------

loc_107CFC				; CODE XREF: memcpy+8j
		MOV		R3, R0


loc_107D00				; CODE XREF: memcpy+B0j memcpy+ECj
		CMP		R2, #0
		BEQ		loc_107D20


loc_107D08				; CODE XREF: memcpy+E4j
		SUB		R3, R3,	#1
		ADD		R2, R1,	R2


loc_107D10				; CODE XREF: memcpy+D4j
		LDRB		R12, [R1],#1
		CMP		R1, R2
		STRB		R12, [R3,#1]!
		BNE		loc_107D10


loc_107D20				; CODE XREF: memcpy+BCj
		LDMFD		SP!, {R4-R6,LR}
		BX		LR

; ---------------------------------------------------------------------------

loc_107D28				; CODE XREF: memcpy+14j
		MOV		R3, R0
		B		loc_107D08

; ---------------------------------------------------------------------------

loc_107D30				; CODE XREF: memcpy+74j
		MOV		R2, R6
		B		loc_107D00

; End of function memcpy


; =============== S U B	R O U T	I N E =======================================


memset_					; CODE XREF: ROM:00101118p
					; thread_NTR_home_injectee+60p	...
		TST		R0, #3
		STMFD		SP!, {R4,LR}
		BEQ		loc_107E24

		CMP		R2, #0
		SUB		R2, R2,	#1
		BEQ		loc_107E1C

		AND		R12, R1, #0xFF
		MOV		R3, R0
		B		loc_107D68

; ---------------------------------------------------------------------------

loc_107D5C				; CODE XREF: memset_+38j
		CMP		R2, #0
		SUB		R2, R2,	#1
		BEQ		loc_107E1C


loc_107D68				; CODE XREF: memset_+20j
		STRB		R12, [R3],#1
		TST		R3, #3
		BNE		loc_107D5C


loc_107D74				; CODE XREF: memset_+F0j
		CMP		R2, #3
		BLS		loc_107E00

		AND		LR, R1,	#0xFF
		ORR		LR, LR,	LR,LSL#8
		CMP		R2, #0xF
		ORR		LR, LR,	LR,LSL#16
		BLS		loc_107DD4

		MOV		R4, R2
		ADD		R12, R3, #0x10


loc_107D98				; CODE XREF: memset_+7Cj
		SUB		R4, R4,	#0x10
		CMP		R4, #0xF
		STR		LR, [R12,#-0x10]
		STR		LR, [R12,#-0xC]
		STR		LR, [R12,#-8]
		STR		LR, [R12,#-4]
		ADD		R12, R12, #0x10
		BHI		loc_107D98

		SUB		R12, R2, #0x10
		BIC		R12, R12, #0xF
		AND		R2, R2,	#0xF
		ADD		R12, R12, #0x10
		CMP		R2, #3
		ADD		R3, R3,	R12
		BLS		loc_107E00


loc_107DD4				; CODE XREF: memset_+54j
		MOV		R4, R3
		MOV		R12, R2


loc_107DDC				; CODE XREF: memset_+B0j
		SUB		R12, R12, #4
		CMP		R12, #3
		STR		LR, [R4],#4
		BHI		loc_107DDC

		SUB		R12, R2, #4
		BIC		R12, R12, #3
		ADD		R12, R12, #4
		ADD		R3, R3,	R12
		AND		R2, R2,	#3


loc_107E00				; CODE XREF: memset_+40j memset_+98j
		CMP		R2, #0
		BEQ		loc_107E1C

		AND		R1, R1,	#0xFF
		ADD		R2, R3,	R2


loc_107E10				; CODE XREF: memset_+E0j
		STRB		R1, [R3],#1
		CMP		R3, R2
		BNE		loc_107E10


loc_107E1C				; CODE XREF: memset_+14j memset_+2Cj ...
		LDMFD		SP!, {R4,LR}
		BX		LR

; ---------------------------------------------------------------------------

loc_107E24				; CODE XREF: memset_+8j
		MOV		R3, R0
		B		loc_107D74

; End of function memset_


; =============== S U B	R O U T	I N E =======================================


sub_107E2C				; CODE XREF: get_process_list_action+BCp
		TST		R0, #3
		STMFD		SP!, {R4,LR}
		MOV		R4, R0
		BNE		loc_107E80

		LDR		R0, [R4]
		LDR		R3, =0xFEFEFEFF
		LDR		R2, =0x80808080
		ADD		R3, R0,	R3
		BIC		R3, R3,	R0
		AND		R2, R2,	R3
		CMP		R2, #0
		MOV		R0, R4
		BNE		loc_107E80


loc_107E60				; CODE XREF: sub_107E2C+50j
		LDR		LR, [R0,#4]!
		LDR		R2, =0xFEFEFEFF
		LDR		R12, =0x80808080
		ADD		R2, LR,	R2
		BIC		R2, R2,	LR
		AND		R12, R12, R2
		CMP		R12, #0
		BEQ		loc_107E60


loc_107E80				; CODE XREF: sub_107E2C+Cj
					; sub_107E2C+30j
		LDRB		R2, [R0]
		CMP		R2, #0
		BEQ		loc_107E98


loc_107E8C				; CODE XREF: sub_107E2C+68j
		LDRB		R2, [R0,#1]!
		CMP		R2, #0
		BNE		loc_107E8C


loc_107E98				; CODE XREF: sub_107E2C+5Cj
		BL		strncpy_

		MOV		R0, R4
		LDMFD		SP!, {R4,LR}
		BX		LR

; End of function sub_107E2C

; ---------------------------------------------------------------------------
dword_107EA8	DCD 0xFEFEFEFF		; DATA XREF: sub_107E2C+14r
					; sub_107E2C+38r
dword_107EAC	DCD 0x80808080		; DATA XREF: sub_107E2C+18r
					; sub_107E2C+3Cr

; =============== S U B	R O U T	I N E =======================================


get_svc_handle_by_name			; CODE XREF: plgGetSharedServiceHandle+Cp

var_4		= -4

		EOR		R12, R0, R1
		TST		R12, #3
		BNE		loc_107F44

		ANDS		R12, R0, #3
		BIC		R0, R0,	#3
		BIC		R1, R1,	#3
		LDR		R2, [R0],#4
		LDREQ		R3, [R1],#4
		BEQ		loc_107EF0

		EOR		R12, R12, #3
		MOV		R3, #0xFFFFFF
		MOV		R12, R12,LSL#3
		MOV		R12, R3,LSR R12
		LDR		R3, [R1],#4
		ORR		R2, R2,	R12
		ORR		R3, R3,	R12


loc_107EF0				; CODE XREF: get_svc_handle_by_name+20j
		STR		R4, [SP,#var_4]!
		MOV		R4, #1
		ORR		R4, R4,	R4,LSL#8
		ORR		R4, R4,	R4,LSL#16


loc_107F00				; CODE XREF: get_svc_handle_by_name+68j
		SUB		R12, R2, R4
		CMP		R2, R3
		BICEQ		R12, R12, R2
		TSTEQ		R12, R4,LSL#7
		LDREQ		R2, [R0],#4
		LDREQ		R3, [R1],#4
		BEQ		loc_107F00


loc_107F1C				; CODE XREF: get_svc_handle_by_name+80j
		MOV		R0, R2,LSL#24
		MOV		R2, R2,LSR#8
		CMP		R0, #1
		CMPCS		R0, R3,LSL#24
		MOVEQ		R3, R3,LSR#8
		BEQ		loc_107F1C

		AND		R3, R3,	#0xFF
		RSB		R0, R3,	R0,LSR#24
		LDR		R4, [SP+4+var_4],#4
		BX		LR

; ---------------------------------------------------------------------------

loc_107F44				; CODE XREF: get_svc_handle_by_name+8j
					; get_svc_handle_by_name+ACj
		TST		R0, #3
		BEQ		loc_107F68

		LDRB		R2, [R0],#1
		LDRB		R3, [R1],#1
		CMP		R2, #1
		CMPCS		R2, R3
		BEQ		loc_107F44

		SUB		R0, R2,	R3
		BX		LR

; ---------------------------------------------------------------------------

loc_107F68				; CODE XREF: get_svc_handle_by_name+98j
		STMFD		SP!, {R4,R5}
		MOV		R4, #1
		ORR		R4, R4,	R4,LSL#8
		ORR		R4, R4,	R4,LSL#16
		LDR		R2, [R0],#4
		AND		R5, R1,	#3
		BIC		R1, R1,	#3
		LDR		R3, [R1],#4
		CMP		R5, #2
		BEQ		loc_107FF0

		BHI		loc_10804C


loc_107F94				; CODE XREF: get_svc_handle_by_name+114j
		BIC		R5, R2,	#0xFF000000
		CMP		R5, R3,LSR#8
		SUB		R12, R2, R4
		BIC		R12, R12, R2
		BNE		loc_107FC8

		ANDS		R12, R12, R4,LSL#7
		LDREQ		R3, [R1],#4
		BNE		loc_107FD0

		EOR		R5, R5,	R2
		CMP		R5, R3,LSL#24
		BNE		loc_107FE4

		LDR		R2, [R0],#4
		B		loc_107F94

; ---------------------------------------------------------------------------

loc_107FC8				; CODE XREF: get_svc_handle_by_name+F4j
		MOV		R3, R3,LSR#8
		B		loc_1080AC

; ---------------------------------------------------------------------------

loc_107FD0				; CODE XREF: get_svc_handle_by_name+100j
		BICS		R12, R12, #0xFF000000
		BNE		loc_1080A0

		LDRB		R3, [R1]
		MOV		R5, R2,LSR#24
		B		loc_1080AC

; ---------------------------------------------------------------------------

loc_107FE4				; CODE XREF: get_svc_handle_by_name+10Cj
		MOV		R5, R2,LSR#24
		AND		R3, R3,	#0xFF
		B		loc_1080AC

; ---------------------------------------------------------------------------

loc_107FF0				; CODE XREF: get_svc_handle_by_name+DCj
					; get_svc_handle_by_name+174j
		MOV		R5, R2,LSL#16
		SUB		R12, R2, R4
		MOV		R5, R5,LSR#16
		BIC		R12, R12, R2
		CMP		R5, R3,LSR#16
		BNE		loc_108044

		ANDS		R12, R12, R4,LSL#7
		LDREQ		R3, [R1],#4
		BNE		loc_108028

		EOR		R5, R5,	R2
		CMP		R5, R3,LSL#16
		BNE		loc_10803C

		LDR		R2, [R0],#4
		B		loc_107FF0

; ---------------------------------------------------------------------------

loc_108028				; CODE XREF: get_svc_handle_by_name+160j
		MOVS		R12, R12,LSL#16
		BNE		loc_1080A0

		LDRH		R3, [R1]
		MOV		R5, R2,LSR#16
		B		loc_1080AC

; ---------------------------------------------------------------------------

loc_10803C				; CODE XREF: get_svc_handle_by_name+16Cj
		MOV		R3, R3,LSL#16
		MOV		R5, R2,LSR#16


loc_108044				; CODE XREF: get_svc_handle_by_name+154j
		MOV		R3, R3,LSR#16
		B		loc_1080AC

; ---------------------------------------------------------------------------

loc_10804C				; CODE XREF: get_svc_handle_by_name+E0j
					; get_svc_handle_by_name+1CCj
		AND		R5, R2,	#0xFF
		CMP		R5, R3,LSR#24
		SUB		R12, R2, R4
		BIC		R12, R12, R2
		BNE		loc_108080

		ANDS		R12, R12, R4,LSL#7
		LDREQ		R3, [R1],#4
		BNE		loc_108088

		EOR		R5, R5,	R2
		CMP		R5, R3,LSL#8
		BNE		loc_108094

		LDR		R2, [R0],#4
		B		loc_10804C

; ---------------------------------------------------------------------------

loc_108080				; CODE XREF: get_svc_handle_by_name+1ACj
		MOV		R3, R3,LSR#24
		B		loc_1080AC

; ---------------------------------------------------------------------------

loc_108088				; CODE XREF: get_svc_handle_by_name+1B8j
		TST		R2, #0xFF
		BEQ		loc_1080A0

		LDR		R3, [R1],#4


loc_108094				; CODE XREF: get_svc_handle_by_name+1C4j
		MOV		R5, R2,LSR#8
		BIC		R3, R3,	#0xFF000000
		B		loc_1080AC

; ---------------------------------------------------------------------------

loc_1080A0				; CODE XREF: get_svc_handle_by_name+124j
					; get_svc_handle_by_name+17Cj ...
		MOV		R0, #0
		LDMFD		SP!, {R4,R5}
		BX		LR

; ---------------------------------------------------------------------------

loc_1080AC				; CODE XREF: get_svc_handle_by_name+11Cj
					; get_svc_handle_by_name+130j ...
		AND		R2, R5,	#0xFF
		AND		R0, R3,	#0xFF
		CMP		R0, #1
		CMPCS		R0, R2
		MOVEQ		R5, R5,LSR#8
		MOVEQ		R3, R3,LSR#8
		BEQ		loc_1080AC

		SUB		R0, R2,	R0
		LDMFD		SP!, {R4,R5}
		BX		LR

; End of function get_svc_handle_by_name


; =============== S U B	R O U T	I N E =======================================


strncpy_				; CODE XREF: get_process_name+94p
					; ntr_cmd_process+80p ...

var_8		= -8
var_4		= -4

		EOR		R2, R0,	R1
		MOV		R12, R0
		TST		R2, #3
		BNE		loc_1081B0

		TST		R1, #3
		BNE		loc_108174


loc_1080EC				; CODE XREF: strncpy_+BCj strncpy_+D4j
		STR		R5, [SP,#var_4]!
		MOV		R5, #1
		ORR		R5, R5,	R5,LSL#8
		ORR		R5, R5,	R5,LSL#16
		STR		R4, [SP,#4+var_8]!
		TST		R1, #4
		LDR		R3, [R1],#4
		BEQ		loc_108124

		SUB		R2, R3,	R5
		BICS		R2, R2,	R3
		TST		R2, R5,LSL#7
		STREQ		R3, [R12],#4
		LDREQ		R3, [R1],#4
		BNE		loc_108158


loc_108124				; CODE XREF: strncpy_+34j strncpy_+7Cj
		LDR		R4, [R1],#4
		SUB		R2, R3,	R5
		BICS		R2, R2,	R3
		TST		R2, R5,LSL#7
		SUB		R2, R4,	R5
		BNE		loc_108158

		STR		R3, [R12],#4
		BICS		R2, R2,	R4
		TST		R2, R5,LSL#7
		LDREQ		R3, [R1],#4
		STREQ		R4, [R12],#4
		BEQ		loc_108124

		MOV		R3, R4


loc_108158				; CODE XREF: strncpy_+4Cj strncpy_+64j ...
		STRB		R3, [R12],#1
		TST		R3, #0xFF
		MOV		R3, R3,ROR#8
		BNE		loc_108158

		LDR		R4, [SP+8+var_8],#4
		LDR		R5, [SP+4+var_4],#4
		BX		LR

; ---------------------------------------------------------------------------

loc_108174				; CODE XREF: strncpy_+14j
		TST		R1, #1
		BEQ		loc_10818C

		LDRB		R2, [R1],#1
		STRB		R2, [R12],#1
		CMP		R2, #0
		BXEQ		LR


loc_10818C				; CODE XREF: strncpy_+A4j
		TST		R1, #2
		BEQ		loc_1080EC

		LDRH		R2, [R1],#2
		TST		R2, #0xFF
		STRNEH		R2, [R12],#2
		STREQB		R2, [R12]
		TSTNE		R2, #0xFF00
		BNE		loc_1080EC

		BX		LR

; ---------------------------------------------------------------------------

loc_1081B0				; CODE XREF: strncpy_+Cj strncpy_+E8j
		LDRB		R2, [R1],#1
		STRB		R2, [R12],#1
		CMP		R2, #0
		BNE		loc_1081B0

		BX		LR

; End of function strncpy_


; =============== S U B	R O U T	I N E =======================================


; int __fastcall strlen_(char *a1)
strlen_					; CODE XREF: sub_100378+30p
					; display_stuff+14p ...
		BIC		R1, R0,	#3
		ANDS		R0, R0,	#3
		RSB		R0, R0,	#0
		LDR		R3, [R1],#4
		ADD		R12, R0, #4
		MOV		R12, R12,LSL#3
		MOV		R2, #0xFFFFFFFF
		ORRNE		R3, R3,	R2,LSR R12
		MOV		R12, #1
		ORR		R12, R12, R12,LSL#8
		ORR		R12, R12, R12,LSL#16


loc_1081F0				; CODE XREF: strlen_+40j
		SUB		R2, R3,	R12
		BIC		R2, R2,	R3
		ANDS		R2, R2,	R12,LSL#7
		LDREQ		R3, [R1],#4
		ADDEQ		R0, R0,	#4
		BEQ		loc_1081F0

		TST		R3, #0xFF
		ADDNE		R0, R0,	#1
		TSTNE		R3, #0xFF00
		ADDNE		R0, R0,	#1
		TSTNE		R3, #0xFF0000
		ADDNE		R0, R0,	#1
		BX		LR

; End of function strlen_


; =============== S U B	R O U T	I N E =======================================


sub_108224				; CODE XREF: get_process_list_action+7Cp
					; sub_107614+1D8p ...

; FUNCTION CHUNK AT 00108338 SIZE 00000004 BYTES

		SUBS		R2, R1,	#1
		BXEQ		LR

		BCC		loc_10830C

		CMP		R0, R1
		BLS		loc_1082C4

		TST		R1, R2
		BEQ		loc_1082D0

		TST		R1, #0xE0000000
		MOVEQ		R1, R1,LSL#3
		MOVEQ		R3, #8
		MOVNE		R3, #1


loc_108250				; CODE XREF: sub_108224+3Cj
		CMP		R1, #0x10000000
		CMPCC		R1, R0
		MOVCC		R1, R1,LSL#4
		MOVCC		R3, R3,LSL#4
		BCC		loc_108250


loc_108264				; CODE XREF: sub_108224+50j
		CMP		R1, #0x80000000
		CMPCC		R1, R0
		MOVCC		R1, R1,LSL#1
		MOVCC		R3, R3,LSL#1
		BCC		loc_108264

		MOV		R2, #0


loc_10827C				; CODE XREF: sub_108224+94j
		CMP		R0, R1
		SUBCS		R0, R0,	R1
		ORRCS		R2, R2,	R3
		CMP		R0, R1,LSR#1
		SUBCS		R0, R0,	R1,LSR#1
		ORRCS		R2, R2,	R3,LSR#1
		CMP		R0, R1,LSR#2
		SUBCS		R0, R0,	R1,LSR#2
		ORRCS		R2, R2,	R3,LSR#2
		CMP		R0, R1,LSR#3
		SUBCS		R0, R0,	R1,LSR#3
		ORRCS		R2, R2,	R3,LSR#3
		CMP		R0, #0
		MOVNES		R3, R3,LSR#4
		MOVNE		R1, R1,LSR#4
		BNE		loc_10827C

		MOV		R0, R2
		BX		LR

; ---------------------------------------------------------------------------

loc_1082C4				; CODE XREF: sub_108224+10j
		MOVEQ		R0, #1
		MOVNE		R0, #0
		BX		LR

; ---------------------------------------------------------------------------

loc_1082D0				; CODE XREF: sub_108224+18j
		CMP		R1, #0x10000
		MOVCS		R1, R1,LSR#16
		MOVCS		R2, #0x10
		MOVCC		R2, #0
		CMP		R1, #0x100
		MOVCS		R1, R1,LSR#8
		ADDCS		R2, R2,	#8
		CMP		R1, #0x10
		MOVCS		R1, R1,LSR#4
		ADDCS		R2, R2,	#4
		CMP		R1, #4
		ADDHI		R2, R2,	#3
		ADDLS		R2, R2,	R1,LSR#1
		MOV		R0, R0,LSR R2
		BX		LR

; ---------------------------------------------------------------------------

loc_10830C				; CODE XREF: sub_108224+8j
					; sub_108318+4j
		CMP		R0, #0
		MOVNE		R0, #0xFFFFFFFF
		B		locret_108338

; End of function sub_108224


; =============== S U B	R O U T	I N E =======================================


sub_108318				; CODE XREF: sub_107614+1C0p
		CMP		R1, #0
		BEQ		loc_10830C

		STMFD		SP!, {R0,R1,LR}
		BL		sub_108224

		LDMFD		SP!, {R1,R2,LR}
		MUL		R3, R2,	R0
		SUB		R1, R1,	R3
		BX		LR

; End of function sub_108318

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_108224

locret_108338				; CODE XREF: sub_108224+F0j
		BX		LR

; END OF FUNCTION CHUNK	FOR sub_108224
; ---------------------------------------------------------------------------
pid_of_home_menu DCD 0xF		; DATA XREF: get_nintendo_home_version_info+18o
					; get_nintendo_home_version_info+1Cr ...
va_mapped_io_LCD DCD 0xFFFC4000		; DATA XREF: lcd_solid_fill+1Cr
					; lcd_solid_fill+40r ...
pid_of_process_manager DCD 2
va_mapped_io_PDC DCD 0xFFFBC000		; DATA XREF: plgGetIoBase+24o
					; ROM:off_1033E8o ...
va_mapped_io_PAD DCD 0xFFFC2000		; DATA XREF: plgGetIoBase+14o
					; ROM:off_1033E4o ...
		DCD 1
		DCD 1
p_plgloader_info_ver_specific DCD 0x6200000 ; DATA XREF: plgRequestMemory+2Co
					; plgRequestMemory+30r	...
plgloader_info	DCD 0x7000000		; DATA XREF: alloc_plugin_memory+14r
					; inject_into_nintendo_home+78r ...
hCurKProcess	DCD 0xFFFF8001		; DATA XREF: inject_ntr_into_remote_process+8Co
					; inject_ntr_into_remote_process+98r ...
dword_108364	DCD 9			; DATA XREF: thread_NTR_home_injectee+40o
					; thread_NTR_home_injectee+68w	...
dword_108368	DCD 1			; DATA XREF: thread_NTR_home_injectee+70w
					; install_ntr+4Cw
dword_10836C	DCD 1			; DATA XREF: thread_NTR_home_injectee+74w
					; install_ntr+50w ...
dword_108370	DCD 0x10A1B6		; DATA XREF: thread_NTR_home_injectee+7Cw
					; install_ntr+58w
		DCD 0
		DCD 0
va_arm11_kernel_base_W DCD 0xDFF80000	; DATA XREF: install_SVC_6D_hook+8o
					; install_SVC_6D_hook+28r ...
offs_to_SVC_6D	DCD 0xA35C		; DATA XREF: install_SVC_6D_hook+48r
					; install_SVC_6D_hook+70r
p_cb		DCD cb_arm11_dispatch	; DATA XREF: install_SVC_6D_hook+7Cw
					; arm11k_unknown_cmd5+18r ...
va_arm11_kernel_base_X DCD 0xFFF00000	; DATA XREF: install_SVC_6D_hook+74r
offs_KProcessHandleTable DCD 0xDC	; DATA XREF: handle_queryhandle_packet+4Co
					; handle_queryhandle_packet+54r ...
some_offs_0	DCD 0xBC		; DATA XREF: dispatch_arm11_kernel_cmd+A4r
offs_KCodeSet	DCD 0xB8		; DATA XREF: sub_1042A4+20o
					; sub_1042A4+2Cr ...
pa_N3DS		DCD 0x1F000000		; DATA XREF: sub_100270+8o
					; sub_100270+1Cr ...
		DCD 4
		DCD 0x109290
		DCD 5
		DCD 0x10926C
		DCD 6
		DCD 0x10920C
		DCD 0xA
		DCD 0x21
		DCD 0xB
		DCD 0x10
		DCD 0x15
		DCD 0
		DCD 0x11
		DCD 0
		DCD 0x12
		DCD 0
		DCD 0x13
		DCD 8
		DCD 0x16
		DCD 0
		DCD 0
		DCD 0
		DCD 0
		DCD 0
		DCD 0
		DCD 0
		DCD 0
		DCD 0
		DCD 0
		DCD 0
		DCD 0
		DCD 0
		DCD 0x10839C
		DCD 0
		DCD 0
offsets_start	DCD off_1001B4,	0x17, off_1001B8, 0x17,	off_1001BC, 0x17
					; DATA XREF: ntr_base+3Co
					; ntr_base:fixup_reloco ...
		DCD off_1002D8,	0x17, off_100374, 0x17,	off_100480, 0x17
		DCD off_100658,	0x17, off_100680, 0x17,	dword_100684, 0x17
		DCD off_100C08,	0x17, off_100C10, 0x17,	off_100C94, 0x17
		DCD off_100C98,	0x17, off_100E28, 0x17,	off_100E2C, 0x17
		DCD off_100E38,	0x17, off_100E40, 0x17,	off_100E48, 0x17
		DCD off_100E5C,	0x17, off_100E94, 0x17,	off_100EE4, 0x17
		DCD off_100F44,	0x17, off_1010F0, 0x17,	off_1010F4, 0x17
		DCD off_1010F8,	0x17, off_1010FC, 0x17,	off_10119C, 0x17
		DCD off_1011A0,	0x17, off_1011A4, 0x17,	off_1011A8, 0x17
		DCD off_1011C4,	0x17, off_101240, 0x17,	off_101348, 0x17
		DCD callback_addr, 0x17, rthook, 0x17, off_101354, 0x17
		DCD off_101358,	0x17, off_10135C, 0x17,	off_101360, 0x17
		DCD off_101364,	0x17, off_101368, 0x17,	off_10136C, 0x17
		DCD off_101374,	0x17, off_101378, 0x17,	off_101400, 0x17
		DCD off_101404,	0x17, off_101488, 0x17,	off_10148C, 0x17
		DCD off_101490,	0x17, off_101494, 0x17,	off_101498, 0x17
		DCD off_101780,	0x17, off_101784, 0x17,	off_101788, 0x17
		DCD off_10178C,	0x17, off_101790, 0x17,	off_101794, 0x17
		DCD off_101798,	0x17, filename,	0x17, off_1017A0, 0x17
		DCD off_1017A4,	0x17, off_1017A8, 0x17,	off_1017B0, 0x17
		DCD off_1017B4,	0x17, off_1017BC, 0x17,	off_1017C0, 0x17
		DCD off_1017C8,	0x17, addr, 0x17, off_1017D0, 0x17, off_1017D8
		DCD 0x17, off_1017E4, 0x17, off_101920,	0x17, off_101980
		DCD 0x17, off_1019A8, 0x17, off_1019F8,	0x17, off_1019FC
		DCD 0x17, off_101A4C, 0x17, off_101A50,	0x17, off_101B7C
		DCD 0x17, off_101B80, 0x17, off_101B84,	0x17, off_101B8C
		DCD 0x17, off_101B90, 0x17, off_101BD0,	0x17, off_101C48
		DCD 0x17, off_101C4C, 0x17, off_101C50,	0x17, off_101CC8
		DCD 0x17, off_101CCC, 0x17, off_101CD0,	0x17, off_101DAC
		DCD 0x17, off_101EAC, 0x17, off_101EB0,	0x17, off_101EB4
		DCD 0x17, off_101EB8, 0x17, off_101F50,	0x17, off_101F54
		DCD 0x17, off_101F58, 0x17, off_102020,	0x17, off_102024
		DCD 0x17, off_102028, 0x17, off_10202C,	0x17, off_102030
		DCD 0x17, off_1020FC, 0x17, off_102100,	0x17, off_102104
		DCD 0x17, off_102108, 0x17, off_10226C,	0x17, off_102270
		DCD 0x17, off_102274, 0x17, off_102278,	0x17, off_10227C
		DCD 0x17, off_102280, 0x17, off_102284,	0x17, off_10228C
		DCD 0x17, off_102290, 0x17, off_102294,	0x17, off_102334
		DCD 0x17, off_102338, 0x17, off_10233C,	0x17, off_102340
		DCD 0x17, off_102408, 0x17, off_10240C,	0x17, off_102410
		DCD 0x17, off_102418, 0x17, off_10241C,	0x17, off_102578
		DCD 0x17, off_10257C, 0x17, off_102584,	0x17, off_10258C
		DCD 0x17, off_102590, 0x17, off_1026F0,	0x17, off_1026F4
		DCD 0x17, off_1026F8, 0x17, off_102704,	0x17, off_102708
		DCD 0x17, off_102894, 0x17, off_102898,	0x17, off_10289C
		DCD 0x17, off_1028A0, 0x17, off_1029C0,	0x17, off_1029C4
		DCD 0x17, off_1029C8, 0x17, off_1029CC,	0x17, off_1029D0
		DCD 0x17, off_1029D4, 0x17, off_1029D8,	0x17, off_102B80
		DCD 0x17, off_102B84, 0x17, off_102B88,	0x17, off_102B8C
		DCD 0x17, off_102B90, 0x17, off_102B94,	0x17, off_102B98
		DCD 0x17, off_102BA0, 0x17, off_102BA4,	0x17, off_102BA8
		DCD 0x17, off_102BB0, 0x17, off_102BB4,	0x17, off_102BBC
		DCD 0x17, off_102C60, 0x17, off_102C68,	0x17, off_102C6C
		DCD 0x17, off_102CC4, 0x17, off_102CC8,	0x17, off_102CCC
		DCD 0x17, off_102CD0, 0x17, off_102D74,	0x17, off_102D78
		DCD 0x17, off_102EA4, 0x17, off_102EA8,	0x17, off_102EAC
		DCD 0x17, off_102FF0, 0x17, off_102FF4,	0x17, off_102FFC
		DCD 0x17, off_103000, 0x17, off_103004,	0x17, off_103060
		DCD 0x17, off_103064, 0x17, off_103068,	0x17, off_10325C
		DCD 0x17, off_103264, 0x17, off_103268,	0x17, off_10326C
		DCD 0x17, off_103270, 0x17, off_103274,	0x17, off_103278
		DCD 0x17, off_10327C, 0x17, off_103280,	0x17, off_103360
		DCD 0x17, off_103364, 0x17, off_103398,	0x17, off_10339C
		DCD 0x17, off_1033E0, 0x17, off_1033E4,	0x17, off_1033E8
		DCD 0x17, off_1034C8, 0x17, off_1034CC,	0x17, off_1034D0
		DCD 0x17, off_1034D4, 0x17, off_1034D8,	0x17, off_10351C
		DCD 0x17, off_103520, 0x17, off_1035C8,	0x17, off_1035CC
		DCD 0x17, off_1035D0, 0x17, off_1035DC,	0x17, off_103640
		DCD 0x17, off_103644, 0x17, off_103648,	0x17, off_10364C
		DCD 0x17, off_103650, 0x17, off_1038B0,	0x17, off_1038B4
		DCD 0x17, off_1038B8, 0x17, off_1038BC,	0x17, off_1038C4
		DCD 0x17, off_1038C8, 0x17, off_1038CC,	0x17, off_1038D4
		DCD 0x17, off_1038D8, 0x17, off_1038DC,	0x17, off_1038E0
		DCD 0x17, off_1038E4, 0x17, off_10390C,	0x17, off_103968
		DCD 0x17, off_10396C, 0x17, off_103970,	0x17, off_10399C
		DCD 0x17, off_1039A0, 0x17, off_1039A4,	0x17, off_103AA8
		DCD 0x17, off_103AAC, 0x17, off_103AB0,	0x17, off_103AEC
		DCD 0x17, off_103AF0, 0x17, off_103AF4,	0x17, off_103AF8
		DCD 0x17, off_103BF8, 0x17, off_103BFC,	0x17, off_103C00
		DCD 0x17, off_103C04, 0x17, off_103C08,	0x17, off_103C0C
		DCD 0x17, off_103C10, 0x17, off_103C94,	0x17, off_103C98
		DCD 0x17, off_103C9C, 0x17, off_103CA0,	0x17, off_103CA4
		DCD 0x17, off_103D24, 0x17, off_103D28,	0x17, off_103DB0
		DCD 0x17, off_103DB4, 0x17, off_103DB8,	0x17, off_103DBC
		DCD 0x17
		DCD off_103DC0
		DCD 0x17
		DCD off_103F14
		DCD 0x17
		DCD off_103F18
		DCD 0x17
		DCD off_103F1C
		DCD 0x17
		DCD off_103F20
		DCD 0x17
		DCD off_103F24
		DCD 0x17
		DCD off_103F28
		DCD 0x17
		DCD off_103F2C
		DCD 0x17
		DCD off_103F30
		DCD 0x17
		DCD off_103F34
		DCD 0x17
		DCD off_103F38
		DCD 0x17
		DCD off_103F3C
		DCD 0x17
		DCD off_103F40
		DCD 0x17
		DCD off_103F44
		DCD 0x17
		DCD off_103F48
		DCD 0x17
		DCD off_103F4C
		DCD 0x17
		DCD off_103F50
		DCD 0x17
		DCD off_103F54
		DCD 0x17
		DCD off_103FB8
		DCD 0x17
		DCD off_103FBC
		DCD 0x17
		DCD off_103FC0
		DCD 0x17
		DCD off_103FE4
		DCD 0x17
		DCD off_104048
		DCD 0x17
		DCD off_104050
		DCD 0x17
		DCD off_1040F4
		DCD 0x17
		DCD 0x1040F8
		DCD 0x17
		DCD 0x104284
		DCD 0x17
		DCD 0x104288
		DCD 0x17
		DCD 0x1042A0
		DCD 0x17
		DCD 0x1042F4
		DCD 0x17
		DCD 0x1043B0
		DCD 0x17
		DCD 0x1043B4
		DCD 0x17
		DCB 0x4C ; L
		DCB 0x45 ; E
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x50 ; P
		DCB 0x45 ; E
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x54 ; T
		DCB 0x45 ; E
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x58 ; X
		DCB 0x45 ; E
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x5C ; \
		DCB 0x45 ; E
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x64 ; d
		DCB 0x45 ; E
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x6C ; l
		DCB 0x45 ; E
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB    8
		DCB 0x47 ; G
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB  0xC
		DCB 0x47 ; G
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x10
		DCB 0x47 ; G
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x14
		DCB 0x47 ; G
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x18
		DCB 0x47 ; G
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x1C
		DCB 0x47 ; G
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x20
		DCB 0x47 ; G
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x24 ; $
		DCB 0x47 ; G
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x6C ; l
		DCB 0x48 ; H
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x70 ; p
		DCB 0x48 ; H
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x74 ; t
		DCB 0x48 ; H
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x78 ; x
		DCB 0x48 ; H
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x7C ; |
		DCB 0x48 ; H
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x84 ; „
		DCB 0x48 ; H
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x88 ; ˆ
		DCB 0x48 ; H
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x64 ; d
		DCB 0x49 ; I
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xB4 ; ´
		DCB 0x4A ; J
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xB8 ; ¸
		DCB 0x4A ; J
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xBC ; ¼
		DCB 0x4A ; J
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xC0 ; À
		DCB 0x4A ; J
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xC4 ; Ä
		DCB 0x4A ; J
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xC8 ; È
		DCB 0x4A ; J
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x90 ; 
		DCB 0x4D ; M
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x94 ; ”
		DCB 0x4D ; M
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x98 ; ˜
		DCB 0x4D ; M
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x9C ; œ
		DCB 0x4D ; M
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xD0 ; Ð
		DCB 0x4E ; N
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xD4 ; Ô
		DCB 0x4E ; N
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xD8 ; Ø
		DCB 0x4E ; N
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xDC ; Ü
		DCB 0x4E ; N
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xE0 ; à
		DCB 0x4E ; N
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xE4 ; ä
		DCB 0x4E ; N
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x64 ; d
		DCB 0x4F ; O
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x10
		DCB 0x51 ; Q
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x14
		DCB 0x51 ; Q
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x3C ; <
		DCB 0x54 ; T
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x94 ; ”
		DCB 0x55 ; U
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x98 ; ˜
		DCB 0x55 ; U
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xA0 ;  
		DCB 0x55 ; U
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xA4 ; ¤
		DCB 0x55 ; U
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xA8 ; ¨
		DCB 0x55 ; U
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x40 ; @
		DCB 0x56 ; V
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x44 ; D
		DCB 0x56 ; V
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xA0 ;  
		DCB 0x56 ; V
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xA4 ; ¤
		DCB 0x56 ; V
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xA8 ; ¨
		DCB 0x56 ; V
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xAC ; ¬
		DCB 0x56 ; V
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xB0 ; °
		DCB 0x56 ; V
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xB4 ; ´
		DCB 0x56 ; V
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xB8 ; ¸
		DCB 0x56 ; V
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xBC ; ¼
		DCB 0x56 ; V
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x14
		DCB 0x57 ; W
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x18
		DCB 0x57 ; W
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x1C
		DCB 0x57 ; W
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x20
		DCB 0x57 ; W
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x24 ; $
		DCB 0x57 ; W
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x28 ; (
		DCB 0x57 ; W
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x2C ; ,
		DCB 0x57 ; W
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x30 ; 0
		DCB 0x57 ; W
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x34 ; 4
		DCB 0x57 ; W
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x38 ; 8
		DCB 0x57 ; W
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x74 ; t
		DCB 0x57 ; W
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xC4 ; Ä
		DCB 0x57 ; W
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB 0x58 ; X
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x64 ; d
		DCB 0x58 ; X
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x68 ; h
		DCB 0x58 ; X
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x78 ; x
		DCB 0x58 ; X
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xE8 ; è
		DCB 0x58 ; X
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x48 ; H
		DCB 0x59 ; Y
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xB0 ; °
		DCB 0x59 ; Y
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x18
		DCB 0x5A ; Z
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x18
		DCB 0x5B ; [
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xE8 ; è
		DCB 0x5B ; [
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xB8 ; ¸
		DCB 0x5C ; \
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xE0 ; à
		DCB 0x5D ; ]
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x28 ; (
		DCB 0x5F ; _
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x38 ; 8
		DCB 0x60 ; `
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x50 ; P
		DCB 0x61 ; a
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x9C ; œ
		DCB 0x62 ; b
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x2C ; ,
		DCB 0x63 ; c
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xF0 ; ð
		DCB 0x63 ; c
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x54 ; T
		DCB 0x64 ; d
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x94 ; ”
		DCB 0x64 ; d
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x80 ; €
		DCB 0x65 ; e
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x70 ; p
		DCB 0x66 ; f
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xA0 ;  
		DCB 0x66 ; f
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xDC ; Ü
		DCB 0x66 ; f
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x10
		DCB 0x67 ; g
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x14
		DCB 0x67 ; g
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x9C ; œ
		DCB 0x67 ; g
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xF4 ; ô
		DCB 0x6B ; k
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB    8
		DCB 0x6C ; l
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x60 ; `
		DCB 0x6C ; l
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x50 ; P
		DCB 0x6D ; m
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x54 ; T
		DCB 0x6D ; m
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x58 ; X
		DCB 0x6D ; m
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x84 ; „
		DCB 0x6D ; m
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x88 ; ˆ
		DCB 0x6D ; m
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xA8 ; ¨
		DCB 0x6D ; m
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xAC ; ¬
		DCB 0x6D ; m
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xD4 ; Ô
		DCB 0x6D ; m
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xD8 ; Ø
		DCB 0x6D ; m
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB    4
		DCB 0x6E ; n
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB    8
		DCB 0x6E ; n
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x28 ; (
		DCB 0x6E ; n
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x2C ; ,
		DCB 0x6E ; n
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x48 ; H
		DCB 0x6E ; n
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x4C ; L
		DCB 0x6E ; n
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xB8 ; ¸
		DCB 0x6E ; n
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x54 ; T
		DCB 0x6F ; o
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x58 ; X
		DCB 0x6F ; o
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x84 ; „
		DCB 0x6F ; o
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x4C ; L
		DCB 0x70 ; p
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x50 ; P
		DCB 0x70 ; p
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x54 ; T
		DCB 0x70 ; p
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x58 ; X
		DCB 0x70 ; p
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x5C ; \
		DCB 0x70 ; p
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xC8 ; È
		DCB 0x70 ; p
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xCC ; Ì
		DCB 0x70 ; p
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xD0 ; Ð
		DCB 0x70 ; p
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x34 ; 4
		DCB 0x71 ; q
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x54 ; T
		DCB 0x71 ; q
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xD0 ; Ð
		DCB 0x72 ; r
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xD4 ; Ô
		DCB 0x72 ; r
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xD8 ; Ø
		DCB 0x72 ; r
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x8C ; Œ
		DCB 0x73 ; s
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x94 ; ”
		DCB 0x73 ; s
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x98 ; ˜
		DCB 0x73 ; s
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x40 ; @
		DCB 0x74 ; t
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x74 ; t
		DCB 0x75 ; u
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x78 ; x
		DCB 0x75 ; u
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x7C ; |
		DCB 0x75 ; u
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xB4 ; ´
		DCB 0x75 ; u
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xB8 ; ¸
		DCB 0x75 ; u
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x10
		DCB 0x76 ; v
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x38 ; 8
		DCB 0x79 ; y
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x74 ; t
		DCB 0x79 ; y
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x34 ; 4
		DCB 0x7A ; z
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x38 ; 8
		DCB 0x7A ; z
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x3C ; <
		DCB 0x7A ; z
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x40 ; @
		DCB 0x7A ; z
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xF4 ; ô
		DCB 0x7A ; z
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x1C
		DCB 0x7B ; {
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x70 ; p
		DCB 0x83 ; ƒ
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0x84 ; „
		DCB 0x83 ; ƒ
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xE8 ; è
		DCB 0x9A ; š
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
		DCB 0xEC ; ì
		DCB 0x9A ; š
		DCB 0x10
		DCB    0
		DCB 0x17
		DCB    0
		DCB    0
		DCB    0
offsets_end	DCB "/usr/lib/ld.so.1",0 ; DATA XREF: ntr_base+40o
					; ntr_base+78o	...
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCD 0x100100, 0
		DCD 0x10003, 0
		DCD 0x10833C, 0
		DCD 0x20003, 1,	0x100100, 0
		DCD 0x10010, 0xE, 0x1091F8, 0
		DCD 0x50010, 0x19, 0x10B18C, 0
		DCB 0x10
		DCB    0
		DCB  0xD
		DCB    0
		DCB    0
a__text_start	DCB "__text_start",0
a__code_end	DCB "__code_end",0
a__end__	DCB "__end__",0
		DCB    0
		DCB    0
		DCB    0
		DCB    3
		DCB    0
		DCB    0
		DCB    0
		DCB    6
		DCB    0
		DCB    0
		DCB    0
		DCB    3
		DCB    0
		DCB    0
		DCB    0
		DCB    4
		DCB    0
		DCB    0
		DCB    0
		DCB    5
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
unk_1092BC	DCB    0		; DATA XREF: sub_1002DC+2Co
					; ROM:off_100374o
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCD 0x18181818,	0x180018, 0x6C6C6C, 0
		DCD 0x6CFE6C6C,	0x6C6CFE, 0x7CC07E18, 0x18FC06,	0x18CCC600
		DCD 0xC66630, 0x76386C38, 0x76CCDC, 0x603030, 0
		DCD 0x3030180C,	0xC1830, 0xC0C1830, 0x30180C, 0xFF3C6600
		DCD 0x663C, 0x7E181800,	0x1818,	0
		DCD 0x30181800,	0x7E000000, 0, 0
		DCD 0x181800, 0x30180C06, 0x80C060, 0xF6DECE7C,	0x7CC6E6
		DCD 0x18183818,	0x7E1818, 0x7C06C67C, 0xFEC0C0,	0x3C0606FC
		DCD 0xFC0606, 0xCCCCCC0C, 0xC0CFE, 0x6FCC0FE, 0x7CC606
		DCD 0xFCC0C07C,	0x7CC6C6, 0xC0606FE, 0x303018, 0x7CC6C67C
		DCD 0x7CC6C6, 0x7EC6C67C, 0x7C0606, 0x181800, 0x181800
		DCD 0x181800, 0x30181800, 0x6030180C, 0xC1830, 0x7E0000
		DCD 0x7E, 0x60C1830, 0x30180C, 0x180C663C, 0x180018, 0xDEDEC67C
		DCD 0x7EC0DE, 0xC6C66C38, 0xC6C6FE, 0xFCC6C6FC,	0xFCC6C6
		DCD 0xC0C0C67C,	0x7CC6C0, 0xC6C6CCF8, 0xF8CCC6,	0xF8C0C0FE
		DCD 0xFEC0C0, 0xF8C0C0FE, 0xC0C0C0, 0xC0C0C67C,	0x7CC6CE
		DCD 0xFEC6C6C6,	0xC6C6C6, 0x1818187E, 0x7E1818,	0x6060606
		DCD 0x7CC606, 0xF0D8CCC6, 0xC6CCD8, 0xC0C0C0C0,	0xFEC0C0
		DCD 0xFEFEEEC6,	0xC6C6D6, 0xDEF6E6C6, 0xC6C6CE,	0xC6C6C67C
		DCD 0x7CC6C6, 0xFCC6C6FC, 0xC0C0C0, 0xC6C6C67C,	0x67CDED6
		DCD 0xFCC6C6FC,	0xC6CCD8, 0x7CC0C67C, 0x7CC606,	0x181818FF
		DCD 0x181818, 0xC6C6C6C6, 0xFEC6C6, 0xC6C6C6C6,	0x387CC6
		DCD 0xC6C6C6C6,	0x6CFED6, 0x386CC6C6, 0xC6C66C,	0x7CC6C6C6
		DCD 0xE03018, 0x180C06FE, 0xFE6030, 0x3030303C,	0x3C3030
		DCD 0x183060C0,	0x2060C, 0xC0C0C3C, 0x3C0C0C, 0xC66C3810
		DCD 0, 0
		DCD 0xFF000000,	0xC1818, 0
		DCD 0x67C0000, 0x7EC67E, 0xFCC0C0C0, 0xFCC6C6, 0xC67C0000
		DCD 0x7CC6C0, 0x7E060606, 0x7EC6C6, 0xC67C0000,	0x7CC0FE
		DCD 0x7830361C,	0x783030, 0xC67E0000, 0xFC067EC6, 0xC6FCC0C0
		DCD 0xC6C6C6, 0x18380018, 0x3C1818, 0x6060006, 0x7CC60606
		DCD 0xD8CCC0C0,	0xC6CCF8, 0x18181838, 0x3C1818,	0xFECC0000
		DCD 0xD6D6FE, 0xC6FC0000, 0xC6C6C6, 0xC67C0000,	0x7CC6C6
		DCD 0xC6FC0000,	0xC0C0FCC6, 0xC67E0000,	0x6067EC6, 0xC6FC0000
		DCD 0xC0C0C0, 0xC07E0000, 0xFC067C, 0x187E1818,	0xE1818
		DCD 0xC6C60000,	0x7EC6C6, 0xC6C60000, 0x387CC6,	0xC6C60000
		DCD 0x6CFED6, 0x6CC60000, 0xC66C38, 0xC6C60000,	0xFC067EC6
		DCD 0xCFE0000, 0xFE6038, 0x7018180E, 0xE1818, 0x181818
		DCD 0x181818, 0xE181870, 0x701818, 0xDC76, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		DCD 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0

; =============== S U B	R O U T	I N E =======================================


dump_cmd				; DATA XREF: init_breakpoint_+74o
					; ROM:off_101EB4o
		STMFD		SP!, {R0-R12,LR}
		MRS		R0, CPSR
		STMFD		SP!, {R0}
		MOV		R0, SP
		LDR		R1, =aDump ; "dump"
		LDR		R2, =aInfo ; "info"
		BLX		R2 ; aInfo ; "info"

		LDMFD		SP!, {R0}
		MSR		CPSR_cf, R0
		LDMFD		SP!, {R0-R12,LR}
		LDR		PC, unk_109AF0

; End of function dump_cmd

; ---------------------------------------------------------------------------
off_109AE8	DCD aDump		; DATA XREF: ntr_cmd_process:loc_104A04o
					; ntr_cmd_process+C0o ...
					; "dump"
off_109AEC	DCD aInfo		; DATA XREF: dump_cmd+14r
					; "info"
; _BYTE	unk_109AF0[20]
unk_109AF0	DCB    0		; DATA XREF: SOC_GetErrno+10o
					; ROM:off_105774o ...
		DCB    7
		DCB  0xD
		DCB 0x70 ; p
		DCB 0x7D ; }
		DCB 0x6A ; j
		DCB  0xB
		DCB 0x78 ; x
		DCB    9
		DCB 0x4D ; M
		DCB 0x10
		DCB 0x8C ; Œ
		DCB  0xA
		DCB 0x71 ; q
		DCB 0x6F ; o
		DCB 0x68 ; h
		DCB 0x2D ; -
		DCB 0x79 ; y
		DCB 0x21 ; !
		DCB 0x84 ; „
		DCD 0x761B0E11
		DCD 0x4778A24
		DCD 0x157F0516
		DCD 0x7A1F185C
		DCD 0x7E735B4A
		DCD 0x3D691772
		DCD 0x2E080213
		DCD 0x6D230C43
		DCB 0x1C
		DCB 0x3F, 0x3C,	0x58
		DCB 0x80 ; €
		DCB 0x14, 0x5A,	0x6C
		DCB 0x86 ; †
		DCB 0x19, 6, 0x5F
		DCB 0x8B ; ‹
		DCB 1, 0x20, 0x47
		DCB 0x7B ; {
		DCB 0x6B, 0x22,	0x1E
		DCB 0x1D
		DCB    3
		DCB 0x85 ; …
		DCB 0x3E ; >
		DCB 0x74 ; t
aAcU		DCB "ac:u",0            ; DATA XREF: get_wifi_status+Co
					; ROM:off_100658o
aPatchingSmdh	DCB "patching smdh",0xA,0 ; DATA XREF: callback_patch_smdh+34o
					; ROM:off_100C10o
aFatal_Lr08x	DCB "fatal. LR: %08x",0 ; DATA XREF: fatal_LR+10o
					; ROM:off_100F44o
aFsuser_opendir	DCB "FSUSER_OpenDirectory failed, ret=%08x",0 ; DATA XREF: sub_100F48+98o
					; ROM:off_1010F4o ...
aNoFileFound_	DCB "no file found.",0  ; DATA XREF: sub_100F48+12Co
					; ROM:off_1010F8o
aSS		DCB "%s%s",0            ; DATA XREF: sub_100F48+160o
					; ROM:off_1010FCo
aOpenarchiveFai	DCB "openArchive failed, ret=%08x",0 ; DATA XREF: ROM:00101154o
					; ROM:off_1011A4o
asc_109BB8	DCB "/",0               ; DATA XREF: ROM:loc_101168o
					; ROM:off_1011A8o
aOpenFailed08x	DCB "open failed: %08x",0 ; DATA XREF: set_KProcess_refcount_to_1+18o
					; ROM:off_101240o
aInitCfgMemoryF	DCB "init cfg memory failed",0 ; DATA XREF: prepare_config_mem+50o
					; ROM:off_101404o
aFirmVersionNot	DCB "firm version not supported",0 ; DATA XREF: install_ntr+70o
					; ROM:off_101790o
aHomemenuVersio	DCB "homemenu version not supported",0 ; DATA XREF: install_ntr+84o
					; ROM:off_101794o
aFirmwareVersio	DCB "firmware version not supported",0 ; DATA XREF: install_ntr:loc_1015ACo
					; ROM:off_101798o
aPid0_dmp	DCB "/pid0.dmp",0       ; DATA XREF: install_ntr+B4o
					; ROM:filenameo
aPid2_dmp	DCB "/pid2.dmp",0       ; DATA XREF: install_ntr+C0o
					; ROM:off_1017A0o
aPid3_dmp	DCB "/pid3.dmp",0       ; DATA XREF: install_ntr+CCo
					; ROM:off_1017A4o
aPidf_dmp	DCB "/pidf.dmp",0       ; DATA XREF: install_ntr+D8o
					; ROM:off_1017A8o
aAxiwram_dmp	DCB "/axiwram.dmp",0    ; DATA XREF: install_ntr+E8o
					; ROM:off_1017B0o
aCurrentFirmwar	DCB "current firmware not supported. ",0xA ; DATA XREF: install_ntr+F0o
					; ROM:off_1017B4o
		DCB "please send feedback to",0xA
		DCB " cell9@yandex.com.",0
aKernelhaxDone	DCB "kernelhax done",0  ; DATA XREF: install_ntr+10Co
					; ROM:off_1017BCo ...
aHomemenuVerD	DCB "homemenu ver: %d",0 ; DATA XREF: install_ntr+120o
					; ROM:off_1017C0o
aSendRemainSize	DCB "send remain < size: %08x, %08x",0 ; DATA XREF: sub_1019AC:loc_1019E8o
					; ROM:off_1019FCo
aRecvRemainSize	DCB "recv remain < size: %08x, %08x",0 ; DATA XREF: recv_wrapper:loc_101A3Co
					; ROM:off_101A50o
aOpenfileFailed	DCB "openFile failed: %08x",0 ; DATA XREF: handle_savefile_packet+A4o
					; ROM:off_101B8Co ...
aSavedToSSucces	DCB "saved to %s successfully",0xA,0
					; DATA XREF: handle_savefile_packet+114o
					; ROM:off_101B90o
aBpDAlreadyEnab	DCB "bp %d already enabled",0xA,0
					; DATA XREF: debugcmd_enable_breakpoint+2Co
					; ROM:off_101C4Co
aBpDEnabled	DCB "bp %d enabled",0xA,0
					; DATA XREF: debugcmd_enable_breakpoint:loc_101C38o
					; ROM:off_101C50o
aBpDAlreadyDisa	DCB "bp %d already disabled",0xA,0
					; DATA XREF: debugcmd_disable_breakpoint+2Co
					; ROM:off_101CCCo
aBpDDisabled	DCB "bp %d disabled",0xA,0
					; DATA XREF: debugcmd_disable_breakpoint:loc_101CB8o
					; ROM:off_101CD0o
aRtcheckremotem	DCB "rtCheckRemoteMemoryRegionSafeForWrite failed :%08x",0xA,0
					; DATA XREF: init_breakpoint_+3Co
					; ROM:off_101EB0o
aCodeBreakpoint	DCB "code breakpoint, id: %d, addr: %08x",0xA,0
					; DATA XREF: debugcmd_init_breakpoint+50o
					; ROM:off_101F54o
aInitBreakpoint	DCB "init breakpoint failed.",0xA,0
					; DATA XREF: debugcmd_init_breakpoint+70o
					; ROM:off_101F58o
aOpenprocessFai	DCB "openprocess failed.",0xA,0 ; DATA XREF: handle_queryhandle_packet+38o
					; ROM:off_102024o
aH08xP08x	DCB "h: %08x, p: %08x",0xA,0 ; DATA XREF: handle_queryhandle_packet+90o
					; ROM:off_10202Co
aFreeidD	DCB "freeid: %d",0xA,0  ; DATA XREF: handle_debugcmd_packet+30o
					; ROM:off_102100o
aSetResumeFlag	DCB "set resume flag",0 ; DATA XREF: handle_debugcmd_packet+5Co
					; ROM:off_102104o
aInvalidBpid	DCB "invalid bpid",0xA,0 ; DATA XREF: handle_debugcmd_packet:loc_1020BCo
					; ROM:off_102108o
aArm11_bin	DCB "/arm11.bin",0      ; DATA XREF: handle_reload_packet+48o
					; ROM:off_102274o
aFsfile_getsi_0	DCB "FSFILE_GetSize failed: %08x",0 ; DATA XREF: handle_reload_packet+B0o
					; ROM:off_102284o
aSvc_controlmem	DCB "svc_controlMemory failed: %08x",0 ; DATA XREF: handle_reload_packet+F0o
					; ROM:off_10228Co ...
aFsfile_readFai	DCB "FSFILE_Read failed: %08x",0 ; DATA XREF: handle_reload_packet+118o
					; ROM:off_102290o
aProtectmemoryF	DCB "protectMemory failed: %08x",0 ; DATA XREF: handle_reload_packet+13Co
					; ROM:off_102294o
aGetprocesslist	DCB "getProcessList failed: %08x",0xA,0
					; DATA XREF: handle_listprocess_packet+28o
					; ROM:off_102334o
aGetprocessinfo	DCB "getProcessInfo failed: %08x",0xA,0
					; DATA XREF: handle_listprocess_packet+50o
					; ROM:off_102338o
aPid0x08xPname8	DCB "pid: 0x%08x, pname: %8s, tid: %08x%08x, kpobj: %08x",0xA,0
					; DATA XREF: handle_listprocess_packet+5Co
					; ROM:off_10233Co
aEndOfProcessLi	DCB "end of process list.",0xA,0 ; DATA XREF: handle_listprocess_packet+8Co
					; ROM:off_102340o
aOpenprocessF_0	DCB "openProcess failed: %08x",0xA,0
					; DATA XREF: handle_memlayout_packet+24o
					; ROM:off_10240Co ...
aValidMemregion	DCB "valid memregions:",0xA,0
					; DATA XREF: handle_memlayout_packet:loc_102384o
					; ROM:off_102410o
a08x08xSize08x	DCB "%08x - %08x , size: %08x",0xA,0
					; DATA XREF: handle_memlayout_packet+7Co
					; ROM:off_102418o
aEndOfMemlayout	DCB "end of memlayout.",0xA,0 ; DATA XREF: handle_memlayout_packet+A4o
					; ROM:off_10241Co
aOpenprocessF_1	DCB "openProcess failed: %08x, pid: %08x",0xA,0
					; DATA XREF: handle_writemem_packet+44o
					; ROM:off_10257Co ...
aRtcheckremot_0	DCB "rtCheckRemoteMemoryRegionSafeForWrite failed: %08x",0xA,0
					; DATA XREF: handle_writemem_packet+88o
					; ROM:off_102584o ...
aCopyremotememo	DCB "copyRemoteMemory failed: %08x, addr: %08x",0xA,0
					; DATA XREF: handle_writemem_packet+124o
					; ROM:off_10258Co ...
aFinished	DCB "finished",0        ; DATA XREF: handle_writemem_packet:loc_102554o
					; ROM:off_102590o ...
aGetthreadlistF	DCB "getThreadList failed: %08x",0xA,0 ; DATA XREF: get_remote_PC+34o
					; ROM:off_102894o ...
aRecommendPc	DCB "recommend pc:",0xA,0 ; DATA XREF: get_remote_PC:loc_1027A8o
					; ROM:off_102898o
aRecommendLr	DCB "recommend lr:",0xA,0 ; DATA XREF: get_remote_PC:loc_102818o
					; ROM:off_1028A0o
aTid0x08x	DCB "tid: 0x%08x",0xA,0 ; DATA XREF: handle_listthread_packet+B4o
					; ROM:off_1029D4o
aPc08xLr08x	DCB "pc: %08x, lr: %08x",0xA,0 ; DATA XREF: handle_listthread_packet+E0o
					; ROM:off_1029D8o
aBuf08xSize08x	DCB "buf: %08x, size: %08x",0xA,0
					; DATA XREF: inject_ntr_into_remote_process+24o
					; ROM:off_102B88o
aArm11NotLoaded	DCB "arm11 not loaded",0xA,0 ; DATA XREF: inject_ntr_into_remote_process+3Co
					; ROM:off_102B8Co
aMapremotememor	DCB "mapRemoteMemory failed: %08x",0xA,0
					; DATA XREF: inject_ntr_into_remote_process+64o
					; ROM:off_102B90o
aProtectremotem	DCB "protectRemoteMemory failed: %08x",0xA,0
					; DATA XREF: inject_ntr_into_remote_process+84o
					; ROM:off_102B94o
aCopyremoteme_0	DCB "copyRemoteMemory(1) failed: %08x",0xA,0
					; DATA XREF: inject_ntr_into_remote_process+ACo
					; ROM:off_102BA0o
aRemotepc08x	DCB "remotePC: %08x",0xA,0
					; DATA XREF: inject_ntr_into_remote_process:loc_102AA4o
					; ROM:off_102BA4o
aCopyremoteme_1	DCB "copyRemoteMemory(3) failed: %08x",0xA,0
					; DATA XREF: inject_ntr_into_remote_process+124o
					; ROM:off_102BB0o
aCopyremoteme_2	DCB "copyRemoteMemory(2) failed: %08x",0xA,0
					; DATA XREF: inject_ntr_into_remote_process+150o
					; ROM:off_102BB4o
aCopyremoteme_3	DCB "copyRemoteMemory(4) failed: %08x",0xA,0
					; DATA XREF: inject_ntr_into_remote_process+188o
					; ROM:off_102BBCo
aWillListenAtPortD DCB "will listen at port %d ",0xA,0
					; DATA XREF: handle_attachprocess_packet+7Co
					; ROM:off_102C6Co
aCpsr08x	DCB "cpsr:%08x ",0      ; DATA XREF: send_proc_context_to_client+Co
					; ROM:off_102CC4o
aLr08xSp08x	DCB "lr:%08x sp:%08x",0xA,0 ; DATA XREF: send_proc_context_to_client+1Co
					; ROM:off_102CC8o
aRD08x		DCB "r%d:%08x ",0       ; DATA XREF: send_proc_context_to_client+30o
					; ROM:off_102CCCo ...
aBreakpointDHit	DCB "breakpoint %d hit",0xA,0 ; DATA XREF: check_for_bp_hit+74o
					; ROM:off_102D78o
aHello		DCB "hello",0           ; DATA XREF: dispatch_client_cmd+24o
					; ROM:off_102EA8o
aBindFailed08x	DCB "bind failed: %08x",0 ; DATA XREF: handle_network_client+6Co
					; ROM:off_102FF4o
aListenFailed08	DCB "listen failed: %08x",0 ; DATA XREF: handle_network_client+90o
					; ROM:off_102FFCo
aRtrecvsocketFa	DCB "rtRecvSocket failed: %08x",0 ; DATA XREF: handle_network_client+D0o
					; ROM:off_103000o
aBrokenProtocol	DCB "broken protocol: %08x, %08x",0 ; DATA XREF: handle_network_client+130o
					; ROM:off_103004o
aRtcheckremot_1	DCB "rtCheckRemoteMemoryRegionSafeForWrite failed: %08x",0
					; DATA XREF: setup_ntr_network_server+70o
					; ROM:off_103268o
aSoc_initialize	DCB "SOC_Initialize failed: %08x",0
					; DATA XREF: setup_ntr_network_server+BCo
					; ROM:off_103274o
aSvc_createthre	DCB "svc_createThread failed: %08x",0
					; DATA XREF: setup_ntr_network_server+1D4o
					; ROM:off_103280o
aFsUser		DCB "fs:USER",0         ; DATA XREF: plgGetSharedServiceHandle+8o
					; ROM:off_103398o ...
aProcessManager	DCB "Process Manager",0 ; DATA XREF: display_OSD_menu+Co
					; ROM:off_1034C8o
aPlugins	DCB "Plugins",0         ; DATA XREF: display_OSD_menu+18o
					; ROM:off_1034D0o
aNtrCfw2_0	DCB "NTR CFW 2.0",0     ; DATA XREF: display_OSD_menu:loc_103460o
					; ROM:off_1034D8o
aExpandPoolAddr	DCB "expand pool addr: %08x, size: %08x",0xA,0
					; DATA XREF: alloc_plugin_memory+38o
					; ROM:off_1035D0o
aAllocPlgMemory	DCB "alloc plg memory failed: %08x",0xA,0
					; DATA XREF: alloc_plugin_memory+80o
					; ROM:off_1035DCo
aFsReg		DCB "fs:REG",0          ; DATA XREF: get_fs_user_handle_0+2Co
					; ROM:off_103648o
aFsuser_initial	DCB "FSUSER_Initialize failed: %08x",0xA,0
					; DATA XREF: get_fs_user_handle_0+48o
					; ROM:off_10364Co
aFsuserhandle08	DCB "fsUserHandle: %08x",0xA,0 ; DATA XREF: get_fs_user_handle_0+54o
					; ROM:off_103650o ...
aOpenMenuProces	DCB "open menu process failed: %08x",0xA,0
					; DATA XREF: inject_into_nintendo_home+38o
					; ROM:off_1038B4o
aHmenuprocess08	DCB "hMenuProcess:%08x",0xA,0
					; DATA XREF: inject_into_nintendo_home:loc_103694o
					; ROM:off_1038B8o
aLoadPlginfoFai	DCB "load plginfo failed:%08x",0xA,0
					; DATA XREF: inject_into_nintendo_home+84o
					; ROM:off_1038C4o
aProctid08x08x	DCB "procTid: %08x%08x",0xA,0 ; DATA XREF: inject_into_nintendo_home+9Co
					; ROM:off_1038C8o
aTidMismatch	DCB "tid mismatch",0xA,0 ; DATA XREF: inject_into_nintendo_home:loc_10371Co
					; ROM:off_1038CCo
aAllocPluginMem	DCB "alloc plugin memory failed: %08x",0xA,0
					; DATA XREF: inject_into_nintendo_home+188o
					; ROM:off_1038D4o
aRwxFailed08x	DCB "rwx failed: %08x",0xA,0 ; DATA XREF: inject_into_nintendo_home+1A4o
					; ROM:off_1038D8o ...
aCopyPlginfoFai	DCB "copy plginfo failed: %08x",0xA,0
					; DATA XREF: inject_into_nintendo_home+1CCo
					; ROM:off_1038DCo
aLoadPlgFailed0	DCB "load plg failed: %08x",0xA,0
					; DATA XREF: inject_into_nintendo_home+214o
					; ROM:off_1038E0o
aAttachProcessF	DCB "attach process failed: %08x",0xA,0
					; DATA XREF: inject_into_nintendo_home+234o
					; ROM:off_1038E4o
aRunappletTid00	DCB "runApplet tid0: %08x, tid1: %08x",0xA,0 ; DATA XREF: ROM:0010393Co
					; ROM:off_10396Co
aPluginS	DCB "/plugin/%s",0      ; DATA XREF: load_ntr_plugins+10o
					; ROM:off_103BF8o
aSS_0		DCB "%s/%s",0           ; DATA XREF: load_ntr_plugins+40o
					; ROM:off_103C00o
aLoadingPluginS	DCB "loading plugin: %s, size: %08x, addr: %08x",0xA,0
					; DATA XREF: load_ntr_plugins+70o
					; ROM:off_103C04o
aAllocPluginM_0	DCB "alloc plugin memory failed",0xA,0 ; DATA XREF: load_ntr_plugins+88o
					; ROM:off_103C08o
aRtloadfiletobu	DCB "rtLoadFileToBuffer failed",0xA,0 ; DATA XREF: load_ntr_plugins+A8o
					; ROM:off_103C0Co
aStartingApplet	DCB "starting applet: %08x%08x",0xA,0 ; DATA XREF: callback_applet_start+1Co
					; ROM:off_103C94o
aGame		DCB "game",0            ; DATA XREF: callback_applet_start+28o
					; ROM:off_103C98o
a08x08x		DCB "%08x%08x",0        ; DATA XREF: callback_applet_start+3Co
					; ROM:off_103C9Co
aPlg08x		DCB "plg: %08x",0xA,0   ; DATA XREF: init_all_plugins_0+5Co
					; ROM:off_103DC0o ...
aFsuser_openarc	DCB "FSUSER_OpenArchive failed: %08x",0xA,0
					; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+58o
					; ROM:off_103F24o
aNtr_bin	DCB "/ntr.bin",0        ; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+7Co
					; load_all_plugins_and_inject_ntr_into_pm:loc_103E78o ...
aArm11BinSize08	DCB "arm11 bin size: %08x",0xA,0
					; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+90o
					; ROM:off_103F34o
aAllocMemoryFor	DCB "alloc memory for arm11bin failed",0xA,0
					; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+ACo
					; ROM:off_103F38o
aLoadArm11binFa	DCB "load arm11bin failed",0xA,0
					; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+D0o
					; ROM:off_103F3Co
aHome		DCB "home",0            ; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+110o
					; ROM:off_103F44o
aOpenprocessF_2	DCB "openProcess failed, ret: %08x",0
					; DATA XREF: get_current_process_handle+44o
					; ROM:off_104050o
aOutaddr08xAddr	DCB "outAddr: %08x, addr: %08x",0 ; DATA XREF: map_remote_memory+80o
					; ROM:off_1040F8o ...
aSvc_flushproce	DCB "svc_flushProcessDataCache(hSrc) failed.",0xA,0
					; DATA XREF: inter_process_dma_copy+4Co
					; ROM:off_104284o
aSvc_flushpro_0	DCB "svc_flushProcessDataCache(hDst) failed.",0xA,0
					; DATA XREF: inter_process_dma_copy+6Co
					; ROM:off_104288o
aReadremotememo	DCB "readRemoteMemory time out %08x",0
					; DATA XREF: inter_process_dma_copy+10Co
					; ROM:off_1042A0o
aOpenprocessF_3	DCB "openProcess failed: %08x",0 ; DATA XREF: dump_process_to_file+9Co
					; ROM:off_104558o
aDumpFinishedAt	DCB "dump finished at addr: %08x",0 ; DATA XREF: dump_process_to_file+F8o
					; ROM:off_104564o
aReadremoteme_0	DCB "readRemoteMemory failed: %08x",0 ; DATA XREF: dump_process_to_file+140o
					; ROM:off_10456Co
aHfile08x	DCB "hfile: %08x",0     ; DATA XREF: ROM:00104600o
					; ROM:off_104714o
aDebugactivepro	DCB "debugActiveProcess failed: %08x",0 ; DATA XREF: ROM:00104620o
					; ROM:off_104718o
aHdebug08x	DCB "hdebug: %08x",0    ; DATA XREF: ROM:00104630o
					; ROM:off_10471Co
aReadmemoryAddr	DCB "readmemory addr = %08x, ret = %08x",0 ; DATA XREF: ROM:001046A0o
					; ROM:off_104724o
aDumpcode	DCB "dumpcode",0        ; DATA XREF: dump_memory_to_file+1Co
					; ROM:off_10486Co
aTestpath	DCB "testpath",0        ; DATA XREF: dump_memory_to_file+4Co
					; ROM:off_104870o
aOpenfile	DCB "openfile",0        ; DATA XREF: dump_memory_to_file+94o
					; ROM:off_10487Co
aOpenFileFailed	DCB "open file failed",0 ; DATA XREF: dump_memory_to_file+B0o
					; ROM:off_104884o
aPatchSmFailed0	DCB "patch sm failed: %08x",0 ; DATA XREF: patch_sm+30o
					; ROM:off_104964o
aGetprocessli_0	DCB "getProcessList failed: %08x",0 ; DATA XREF: ntr_cmd_process+40o
					; ROM:off_104AB4o
aProcesslist	DCB "processList",0     ; DATA XREF: ntr_cmd_process:loc_104A08o
					; ROM:off_104AC0o
aDump_pid08x	DCB "/dump_pid%08x",0   ; DATA XREF: ntr_cmd_process+ECo
					; ROM:off_104AC4o
aPnameS		DCB "pname: %s",0       ; DATA XREF: ntr_cmd_process+12Co
					; ROM:off_104AC8o
aDump		DCB "dump",0            ; DATA XREF: dump_cmd+10o
					; ROM:off_109AE8o
aInfo		DCB "info",0            ; CODE XREF: dump_cmd+18p
					; DATA XREF: dump_cmd+14o ...
aOpenfileFail_0	DCB "openFile failed: %08x",0xA,0 ; DATA XREF: get_file_size+74o
					; ROM:off_104D98o ...
aFsfile_getsize	DCB "FSFILE_GetSize failed: %08x",0xA,0 ; DATA XREF: get_file_size+A8o
					; ROM:off_104D9Co ...
aRtloadfileto_0	DCB "rtLoadFileToBuffer: buffer too small",0xA,0
					; DATA XREF: rtLoadFileToBuffer+C8o
					; ROM:off_104EE0o
aFsfile_readF_0	DCB "FSFILE_Read failed: %08x",0xA,0 ; DATA XREF: rtLoadFileToBuffer+FCo
					; ROM:off_104EE4o
aOpenthreadFail	DCB "openThread failed: %08x",0xA,0 ; DATA XREF: get_thread_context+28o
					; ROM:off_104F64o
aTop_04d_bmp	DCB "/top_%04d.bmp",0   ; DATA XREF: get_screenshot_index+10o
					; ROM:off_10543Co ...
aBot_04d_bmp	DCB "/bot_%04d.bmp",0   ; DATA XREF: create_screenshot+114o
					; ROM:off_1055A8o
aOut_addr08x	DCB "    out_addr: %08x",0 ; DATA XREF: create_screenshot_callback+24o
					; ROM:off_105644o
aInitializingSc	DCB "initializing screenshot plugin",0xA,0
					; DATA XREF: init_builtin_screenshot_plugin+4o
					; ROM:off_1056A0o
aTakeScreenshot	DCB "Take Screenshot",0 ; DATA XREF: init_builtin_screenshot_plugin+14o
					; ROM:titleo
aBmpIndexIsD	DCB "bmp index is: %d",0 ; DATA XREF: init_builtin_screenshot_plugin+48o
					; ROM:off_1056BCo
aSocU		DCB "soc:U",0           ; DATA XREF: SOC_Initialize+3Co
					; ROM:off_105868o
aSrv		DCB "srv:",0            ; DATA XREF: get_srv_handle+8o
					; ROM:off_106714o
asc_10A88D	DCB " * ",0             ; DATA XREF: get_process_list_action+8o
					; ROM:off_1072D0o
asc_10A891	DCB "   ",0             ; DATA XREF: get_process_list_action+Co
					; ROM:off_1072D4o
aHttp44670_orgN	DCB "http://44670.org/ntr",0 ; DATA XREF: get_process_list_action+6Co
					; ROM:off_1072D8o
aPressBToClose_	DCB "Press [B] to close.",0 ; DATA XREF: invoke_osd_wait_for_input+88o
					; ROM:off_107398o
aDbg		DCB "/dbg",0            ; DATA XREF: ROM:001074D0o
					; ROM:off_107574o
a08lx		DCB "%08lX ",0          ; DATA XREF: printf_hexnum+Co
					; ROM:off_107A34o
a02x		DCB " %02X",0           ; DATA XREF: printf_hexnum+40o
					; ROM:off_107A38o
a04x		DCB " %04X",0           ; DATA XREF: printf_hexnum:loc_1079FCo
					; ROM:off_107A3Co
a08lx_0		DCB " %08LX",0          ; DATA XREF: printf_hexnum:loc_107A14o
					; ROM:off_107A40o
		DCB 0, 0, 0
		DCD 0x10, 0
		DCB    1
		DCB 0x7A ; z
		DCB 0x52 ; R
		DCB    0
		DCB    2
		DCB 0x7C ; |
		DCB  0xE
		DCB    1
		DCB 0x1B
		DCB  0xC
		DCB  0xD
		DCB    0
		DCB 0x2C ; ,
		DCB    0
		DCB    0
		DCB    0
		DCB 0x18
		DCB    0
		DCB    0
		DCB    0
		DCB 0xB4 ; ´
		DCB 0xD5 ; Õ
		DCB 0xFF
		DCB 0xFF
		DCB 0x24 ; $
		DCB    2
		DCB    0
		DCB    0
		DCB    0
		DCB 0x62 ; b
		DCB  0xE
		DCB    4
		DCB 0x84 ; „
		DCB    1
		DCB 0x66 ; f
		DCB 0xC4 ; Ä
		DCB  0xE
		DCB    0
		DCB 0x56 ; V
		DCB  0xE
		DCB    8
		DCB 0x84 ; „
		DCB    2
		DCB 0x85 ; …
		DCB    1
		DCB    2
		DCB 0x9C ; œ
		DCB  0xA
		DCB 0x42 ; B
		DCB 0xC4 ; Ä
		DCB 0xC5 ; Å
		DCB  0xE
		DCB    0
		DCB 0x42 ; B
		DCB  0xB
		DCB 0x52 ; R
		DCB 0xC4 ; Ä
		DCB 0xC5 ; Å
		DCB  0xE
		DCB    0
firmware_version_internal DCD 0		; DATA XREF: maino main+Cr ...
nintendo_home_version DCD 0		; DATA XREF: get_nintendo_home_version_info+14w
					; get_nintendo_home_version_info+54w ...
hFSUser		DCD 0			; DATA XREF: sub_100F48+80r
					; ROM:00101138r ...
install_state	DCD 0			; DATA XREF: install_ntr+18w
some_callback	DCD 0			; DATA XREF: install_ntr+2Cw
					; sub_106F68+4o ...
config_mem_offs_1000 DCD 0		; DATA XREF: install_ntr+1B8w
					; install_ntr:inject_code_into_nintendo_homew
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
process_manager_patch_addr DCD 0	; DATA XREF: get_kernel_version_info+28o
					; get_kernel_version_info+38w ...
rthook_return_C821180B RT_HOOK <0>	; DATA XREF: thread_NTR_home_injectee+28o
					; thread_NTR_home_injectee+34o	...
nintendo_home_ptr_fsuser_handle	DCD 0	; DATA XREF: get_nintendo_home_version_info:loc_100D68o
					; get_nintendo_home_version_info+C4w ...
rthook_patch_smdh RT_HOOK <0>		; DATA XREF: thread_NTR_home_injectee+10o
					; thread_NTR_home_injectee+18o	...
nintendo_home_nss_CardUpdateInitialize_addr DCD	0
					; DATA XREF: get_nintendo_home_version_info+70o
					; get_nintendo_home_version_info+78w ...
					; nss:CardUpdateInitialize
nintendo_home_applet_start_hook_addr DCD 0
					; DATA XREF: get_nintendo_home_version_info:loc_100E0Co
					; get_nintendo_home_version_info+168w ...
					; called by nn::applet::CTR::detail::PrepareToStartApplication(nn::fs::TitleDataSpecifier const*, bool)
nintendo_home_FSFile_Read_addr DCD 0	; DATA XREF: get_nintendo_home_version_info+64o
					; get_nintendo_home_version_info+6Cw ...
					; called by nn::fs::CTR::MPCore::detail::FileServerArchive::File::TryRead
nintendo_home_FlushDataCache_addr DCD 0	; DATA XREF: get_nintendo_home_version_info+58o
					; get_nintendo_home_version_info+60w ...
dword_10AAF4	DCD 0			; DATA XREF: sub_101984o sub_101984+4r ...
		DCD 0
		DCD 0
; struct NS_CONFIG *p_config_memory
p_config_memory	DCD 0			; DATA XREF: check_plugin_exit_flago
					; check_plugin_exit_flag+4r ...
dword_10AB04	DCD 0			; DATA XREF: plgRequestMemory:loc_1032FCo
					; plgRequestMemory+20r	...
num_total_plugins DCD 0			; DATA XREF: display_OSD_menu+2Cr
					; plgRegisterMenuEntry+8r ...
plgBufferPtr	DCD 0			; DATA XREF: alloc_plugin_memory+8r
					; alloc_plugin_memory+18w ...
plgSize		DCD 0			; DATA XREF: inject_into_nintendo_home+14r
					; inject_into_nintendo_home+34w
arm11BinStart	DCD 0			; DATA XREF: inject_ntr_into_home_menu+1Co
					; inject_ntr_into_home_menu+28w ...
arm11BinSize	DCD 0			; DATA XREF: inject_ntr_into_home_menu+30o
					; inject_ntr_into_home_menu+34w ...
dword_10AB1C	DCD 0			; DATA XREF: ROM:0010392Cw
dword_10AB20	DCD 0			; DATA XREF: ROM:00103938w
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
; ---------------------------------------------------------------------------

loc_10ABB0				; CODE XREF: ROM:00103964j
					; DATA XREF: ROM:0010395Co ...
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0

; ---------------------------------------------------------------------------
g_plugin_func_ptrs_ DCB	   0		; DATA XREF: display_OSD_menu+10o
					; display_OSD_menu+BCo	...
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
arm11BinEnd	DCD 0			; DATA XREF: update_plginfo_with_arm11_addresses+10o
					; update_plginfo_with_arm11_addresses+14r ...
rthook_home_injection DCB    0		; DATA XREF: install_home_injection_hook+8o
					; ROM:off_1039A0o
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR callback_inject_into_nintendo_home

loc_10AF80				; CODE XREF: callback_inject_into_nintendo_home+20j
					; DATA XREF: callback_inject_into_nintendo_home+18o ...
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0
		ANDEQ		R0, R0,	R0

; END OF FUNCTION CHUNK	FOR callback_inject_into_nintendo_home
; ---------------------------------------------------------------------------
some_filename_	DCD 0			; DATA XREF: find_files_+30o
					; find_files_+58o ...
byte_10AFC4	DCB 0			; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+30w
		DCB    0
		DCB    0
		DCB    0
dword_10AFC8	DCD 0			; DATA XREF: find_files_+4Co
					; load_all_plugins_and_inject_ntr_into_pm+34w
dword_10AFCC	DCD 0			; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+40w
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
p_plgloader_info DCD 0			; DATA XREF: update_plginfo_with_arm11_addresseso
					; update_plginfo_with_arm11_addresses+8r ...
arm11BinEnd2	DCD 0			; DATA XREF: update_plginfo_with_arm11_addresses+18o
					; update_plginfo_with_arm11_addresses+1Cw ...
; struct RT_HOOK rthook_applet_start
rthook_applet_start RT_HOOK <0>		; DATA XREF: load_all_plugins_and_inject_ntr_into_pm+130o
					; load_all_plugins_and_inject_ntr_into_pm+140o	...
cur_pid		DCD 0			; DATA XREF: get_current_process_id+4o
					; get_current_process_id+14r ...
hProcess	DCD 0			; DATA XREF: get_current_process_handle+10r
					; get_current_process_handle+3Cw
p_screenshot_buf DCD 0			; DATA XREF: create_screenshot+8o
					; create_screenshot+Cr	...
bmp_idx		DCD 0			; DATA XREF: create_screenshot+88o
					; create_screenshot+ACr ...
hSession	DCD 0			; DATA XREF: setup_ntr_network_server+9Co
					; setup_ntr_network_server+A0w	...
dword_10B0C0	DCD 0			; DATA XREF: sub_10586C+4r bind_+50w ...
h_srv		DCD 0			; DATA XREF: setup_ntr_network_server:loc_1030ECo
					; setup_ntr_network_server+80r	...
g_arm11_cmd	DCD 0			; DATA XREF: dispatch_arm11_kernel_cmd+4o
					; dispatch_arm11_kernel_cmd+8r	...
g_arm11_param1	DCD 0			; DATA XREF: dispatch_arm11_kernel_cmd+18r
					; dispatch_arm11_kernel_cmd+48r ...
g_arm11_param2	DCD 0			; DATA XREF: dispatch_arm11_kernel_cmd+1Cr
					; arm11k_unknown_cmd5+20r
g_arm11_param3	DCD 0			; DATA XREF: dispatch_arm11_kernel_cmd+14r
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
is_NTR_OSD_requested DCD 0		; DATA XREF: thread_NTR_home_injectee+A0o
					; thread_NTR_home_injectee+E4r	...
dword_10B14C	DCD 0			; DATA XREF: acquire_video+8r
					; release_video+4r ...
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
dword_10B158	DCD 0			; DATA XREF: acquire_video+34o
					; acquire_video+40w ...
dword_10B15C	DCD 0			; DATA XREF: acquire_video+48w
					; release_video+30r
dword_10B160	DCD 0			; DATA XREF: acquire_video+50w
					; release_video+3Cr
dword_10B164	DCD 0			; DATA XREF: acquire_video+58w
					; release_video+48r
dword_10B168	DCD 0			; DATA XREF: acquire_video+60w
					; release_video+54r
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
		DCB    0
dword_10B180	DCD 0			; DATA XREF: call_plugin_callbacko
					; call_plugin_callback+8r ...
off_10B184	DCD 0			; DATA XREF: sub_107A44o sub_107A44+4r ...
cb_plugin_info	DCD 0			; DATA XREF: init_config_mem+8o
					; init_config_mem+14w ...
; ROM		ends			; will point to	update_plugin_info

		END
