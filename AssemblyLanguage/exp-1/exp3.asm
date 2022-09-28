;created by ray
;2021.4.23

.386     
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf          PROTO C :VARARG
 scanf			 proto C :vararg
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 include struct.inc
 timeGetTime proto stdcall
 includelib  Winmm.lib
 winTimer  proto stdcall :DWORD
 exchange proto stdcall :dword
 sort proto stdcall :dword
 showFull proto C :dword
 mapFunc proto stdcall :dword
 sort_opta proto stdcall :dword
 ;exchange_opta proto stdcall :dword
 showFull_opta proto stdcall :dword
 findItem proto stdcall
 accInput proto stdcall
 pwInput proto stdcall
 profitCal proto C
 login proto C
 showMenu proto C
 addNewItem proto C



.DATA
 ;public 
public lpfmt,scfmt,bname,bpass,flag,itemMem,itemNum,inpstr,N,GA1,itemMem

BNAME  DB  'ZHANGRUI',0  ;老板姓名（要求必须是自己名字的拼音）
BPASS  DB  'U201912633',0;密码（必须是自己的学号）
N    EQU   30
GA1   item <'PEN', 15, 20, 70, 25,?> ;进货价、销售价、进货数量、已售数量，利润率（尚未计算）
GA2   item <'PENCIL',2,3,100,50,?>
GA3   item <'BOOK',30,40,25,5,?>
GA4   item <'RULER',3,4,200,150,?>
GAN   item  N-4 DUP(<'TempValue',0,0,0,0,0>) ;除了4个已经具体定义了的商品信息以外，其他商品信息暂时假定为一样的。
itemMem equ 20
itemNum DD 4
itemName db 20 dup(0)
flag sdword	 0 ;mark if the account and the password is correct
inpstr db 20 dup(0);record the input
inpint db 4 dup(0); record the choice

;I/O info
lpFmt	db	"%s",0ah,0dh,0
scFmt db "%s",0
scFmtInt db "%d",0
menuMes db "--------------menu-------------",0dh,0ah
		db "1.show the item message",0dh,0ah
		db "2.ship the item",0dh,0ah
		db "3.purchase the item",0dh,0ah
		db "4.calculate the profit",0dh,0ah
		DB "5.sort by the profit",0dh,0ah
		db "9.exit the program",0dh,0ah
		db "please enter your choice:",0
WrongInfo db "wrong!",0

;extern
extern itemInfo:sbyte 
extern shipMes:sbyte 
extern purchaseMes:sbyte 
extern mapArr:sort_opt_struct


.STACK 200
.CODE

main proc c
	invoke login
	cmp flag, 0
	jz logExit
lp:
	invoke showMenu
	invoke scanf,offset scFmtInt, offset inpint
	mov ecx,dword ptr[inpint]
	cmp ecx,0
	jle wrong
	mov eax,ptable[ecx*4-4]
	jmp eax

showItem:
	CALL findItem
	cmp flag,0
	jz wrong
	invoke printf,offset itemInfo, edi, (item ptr[edi]).buyPrice, (item ptr [edi]).sellPrice,(item ptr[edi]).buyNum, (item ptr[edi]).sellNum, (item ptr [edi]).profit
	jmp lp
shipItem:
	CALL findItem
	cmp flag,0
	jz wrong
	invoke printf,offset itemInfo, edi,(item ptr[edi]).buyPrice,(item ptr [edi]).sellPrice,(item ptr[edi]).buyNum,(item ptr[edi]).sellNum,(item ptr [edi]).profit
	invoke printf, offset lpfmt, offset shipMes
	invoke scanf, offset scfmtint, offset inpint
	mov ax,word ptr[edi]+14
	sub ax,word ptr[edi]+16
	cmp ax,word ptr[inpint]
	jb wrong
	mov ax,word ptr[inpint]
	add word ptr[edi]+16,ax
	call profitCal
	invoke printf,offset itemInfo, edi,(item ptr[edi]).buyPrice,(item ptr [edi]).sellPrice,(item ptr[edi]).buyNum,(item ptr[edi]).sellNum,(item ptr [edi]).profit
	jmp lp
purchaseItem:
	call findItem
	cmp flag,0
	jz wrong
	invoke printf,offset itemInfo,edi,(item ptr[edi]).buyPrice,(item ptr [edi]).sellPrice,(item ptr[edi]).buyNum,(item ptr[edi]).sellNum,(item ptr [edi]).profit
	invoke printf,offset lpfmt, offset purchaseMes
	invoke scanf, offset scfmtint, offset inpint
	mov ax,word ptr [inpint]
	add word ptr[edi]+14, ax
	call profitCal
	invoke printf,offset itemInfo,edi,(item ptr[edi]).buyPrice,(item ptr [edi]).sellPrice,(item ptr[edi]).buyNum,(item ptr[edi]).sellNum,(item ptr [edi]).profit
	jmp lp
calProfit:
	;invoke winTimer, 0
	call profitCal
	;invoke mapFunc , offset GA1
	;mov ecx,10000	
	;opt_lop:
	;call profitCal
	jmp lp
sortItem:
	;invoke showFull, offset GA1
	;invoke sort,offset GA1
	invoke mapFunc , offset GA1
	INVOKE sort_opta, offset mapArr
	;invoke showFull,offset GA1
	;dec ecx
	;cmp ecx,0
	;jg opt_lop
	;invoke winTimer, 1
	;invoke showFull,offset GA1
	invoke showFull_opta, offset mapArr
	jmp lp
mod6:
	invoke addNewItem
	jmp lp
mod7:
	jmp lp
mod8:
	jmp lp
mod9:
   invoke ExitProcess, 0

logExit:
	invoke printf, offset lpFmt, offset wrongInfo
	invoke ExitProcess, 0
wrong:
	invoke printf, offset lpFmt, offset wrongInfo
	jmp lp

ptable dd showItem,shipItem,purchaseItem,calProfit,sortItem,mod6,mod7,mod8,mod9
main endp


END
