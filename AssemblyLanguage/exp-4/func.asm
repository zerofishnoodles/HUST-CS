;created by ray
;2021.4.23

.386     
.model flat,stdcall
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
 VirtualProtect proto:dword, :dword, :dword, :dword

 
 .stack 1024

 .data 
 ;public 
 public itemInfo,shipMes,purchaseMes,mapArr

 ;login
lginInfoAcc db "please enter your account:",0
lginInfoPW db "please enter your password:",0
;finditem
findMes db "please enter the item name",0
itemInfo db "itemName:%s cost:%hd price:%hd purchaseNum:%hd sellNum:%hd profit:%hd",0ah,0dh,0
;shipitem
shipMes db "please enter the shipping number:",0
;purchaseItem
purchaseMes db "please enter the purchasing number:",0
;sort_opt
mapArr	sort_opt_struct 4 dup (< , >)
mapMem equ 6
;winTimer
__t1		dd	?
__t2		dd	?
__fmtTime	db	0ah,0dh,"Time elapsed is %ld ms",2 dup(0ah,0dh),0

;extern
extern mapMem:ABS
extern lpfmt:sbyte 
extern scfmt:sbyte 
extern bname:sbyte 
extern bpass:sbyte 
extern flag:sdword 
extern itemMem:ABS
extern itemNum:dword 
extern inpstr:sbyte 
extern N:ABS
EXTERN GA1:item 

;machine_code
machine_code db 04h,5Ah,43h
len = $ - machine_code
oldprotect dd ?
machine_code_price db 66h,8Bh,57h,0Ch
				   db 66h,33h,0C2h
len_price = $ - machine_code_price


.code
exchange_opta macro base
	push edi
	mov edi,base
	xchg ax,(sort_opt_struct ptr[edi]).profit
	xchg ax,(sort_opt_struct ptr[edi]+mapMem).profit
	xchg ax,(sort_opt_struct ptr[edi]).profit
	xchg eax,(sort_opt_struct ptr[edi]).address
	xchg eax,(sort_opt_struct ptr[edi]+mapMem).address
	xchg eax,(sort_opt_struct ptr[edi]).address
	pop edi
endm 
accInput proc
	push ebp
	mov ebp, esp
	invoke printf, offset lpfmt, offset lginInfoAcc
	invoke scanf, offset scfmt,offset inpstr
	mov ecx, 0
lp_acc:
	inc ecx
	cmp bname[ecx-1],0
	jz exit
	mov dl,inpstr[ecx-1]
	cmp dl,bname[ecx-1]
	jz lp_acc
	mov edx,1h
	mov flag,edx
	jmp exit
exit:
	mov esp,ebp
	pop ebp
	ret
accInput endp

pwInput proc
	push ebp
	mov ebp,esp
	invoke printf, offset lpFmt, offset lginInfoPW
	invoke scanf, offset scfmt,offset inpstr
	mov ecx,0
lp_pw:
	inc ecx
	cmp bpass[ecx-1],0
	jz exit
	mov dl,inpstr[ecx-1]
	cmp dl,bpass[ecx-1]
	jz lp_pw
	mov edx,1h
	mov flag,edx
	jmp exit
exit:
	mov esp,ebp
	pop ebp
	ret
pwInput endp

findItem  proc 
	push ebp
	mov ebp,esp
	call clearInput
	invoke printf, offset lpFmt, offset findMes
	invoke scanf,offset scFmt, offset inpstr
	mov ecx,0
	lea edi,offset GA1
	sub edi,14h
lp1:
	cmp ecx,N
	jz exitFail
	inc ecx
	mov eax, 0
	add edi,14h
	lp2:
		inc eax
		cmp eax,10
		jz exitSuc
		mov dl,[edi+eax-1]
		cmp inpstr[eax-1],dl
		jz lp2
		jmp lp1
exitSuc:
	mov edx,1
	mov flag,edx
	mov esp,ebp
	pop ebp
	ret
exitFail:
	mov edx,0
	mov flag,edx
	mov esp,ebp
	pop ebp
	ret
findItem endp

clearInput proc
	push ebp
	mov ebp,esp
	mov al,0
	mov ecx,0
lp:
	mov inpstr[ecx],al
	inc ecx
	cmp ecx,10
	jnz lp

	mov esp,ebp
	pop ebp
	ret
clearInput endp

profitCal proc C uses eax ebx ecx esi edi
	push edi
	push ebp
	mov ebp,esp
	mov ecx,0
	mov esi,offset GA1
lp:
	cmp ecx,itemNum
	jz exit
	;(sell * price-cost*purchase)*100
	movzx eax,word ptr[[esi]]+12
	movzx ebx,word ptr[[esi]]+16
	imul eax,ebx
	movzx ebx,word ptr[[esi]]+10
	movzx edi,word ptr[[esi]]+14
	imul ebx,edi
	sub eax,ebx
	imul eax,100
	;/cost*purchase
	cdq
	idiv ebx
	mov word ptr[[esi]]+18,ax
	add esi,itemMem
	inc ecx
	jmp lp
exit:
	mov esp,ebp
	pop ebp
	pop edi
	ret
profitCal endp

winTimer	proc stdcall, time_flag:DWORD
		jmp	__L1
__L1:		call	timeGetTime
		cmp	time_flag, 0
		jnz	__L2
		mov	__t1, eax
		ret	4
__L2:		mov	__t2, eax
		sub	eax, __t1
		invoke	printf,offset __fmtTime,eax
		ret	4
winTimer	endp

exchange proc uses eax ecx edi,base:dword
	mov edi, base
	xchg ax,(item ptr[edi]).buyPrice
	xchg ax,(item ptr[edi+itemMem]).buyPrice
	xchg ax,(item ptr[edi]).buyPrice
	xchg ax,(item ptr[edi]).sellPrice
	xchg ax,(item ptr[edi+itemMem]).sellPrice
	xchg ax,(item ptr[edi]).sellPrice
	xchg ax,(item ptr[edi]).buyNum
	xchg ax,(item ptr[edi+itemMem]).buyNum
	xchg ax,(item ptr[edi]).buyNum
	xchg ax,(item ptr[edi]).sellNum
	xchg ax,(item ptr[edi+itemMem]).sellNum
	xchg ax,(item ptr[edi]).sellNum
	xchg ax,(item ptr[edi]).profit
	xchg ax,(item ptr[edi+itemMem]).profit
	xchg ax,(item ptr[edi]).profit
	mov ecx,10
lopa:
	xchg al,byte ptr[edi+[ecx]]
	xchg al,byte ptr[edi+[ecx]+itemMem]
	xchg al,byte ptr[edi+[ecx]]
	DEC ecx
	cmp ecx,0
	jge lopa
ret
exchange endp 

sort proc uses eax ebx ecx edx edi, startAddress:dword
	mov edi, startAddress
	mov ecx,0
	cmp ecx,[itemNum]-1
	jb out_loop
out_loop:
	mov ebx,0
	mov esi,itemNum
	dec esi
	sub esi,ecx
	cmp ebx,esi
	jb in_loop
	ret
	in_loop:
		mov eax,itemMem
		imul eax,ebx
		lea eax, [edi+eax]
		mov ax,(item ptr[eax]).profit
		mov edx,itemMem
		imul edx,ebx
		add edx,itemMem
		cmp ax,(item ptr[edi+edx]).profit
		jg	next
		mov edx,itemMem
		imul edx,ebx
		lea edx,[edi+edx]
		invoke exchange,edx
		next:
			inc ebx
			cmp ebx,esi
			jb in_loop
	inc ecx
	cmp ecx,[itemNum]-1
	jb out_loop
ret
sort endp

showFull proc C uses ecx eax ebx, base:dword
	local temp:dword
	mov ecx,0
lopa:
	mov temp,ecx
	MOV EDX,base
	lea ebx,[edx+ecx]
	invoke printf,offset itemInfo,ebx,(item ptr[ebx]).buyPrice,(item ptr [ebx]).sellPrice,(item ptr[ebx]).buyNum,(item ptr[ebx]).sellNum,(item ptr [ebx]).profit
	mov ECX,temp
	ADD ecx,itemMem
	mov eax,itemMem
	imul eax,itemNum
	cmp ecx,eax
	jl lopa
ret
showFull endp	

sort_opta proc stdcall uses eax ebx ecx edx edi, base:dword
	mov edi, [base] 
	mov ecx,0
	cmp ecx,[itemNum]-1
	jb out_loop
out_loop:
	mov ebx,0
	mov esi,itemNum
	dec esi
	sub esi,ecx
	cmp ebx,esi
	jb in_loop
	ret
	in_loop:
		mov eax,mapMem
		imul eax,ebx
		lea eax, [edi+eax]
		mov ax,(sort_opt_struct ptr[eax]).profit
		mov edx,mapMem
		imul edx,ebx
		add edx,mapMem
		cmp ax,(sort_opt_struct ptr[edi+edx]).profit
		jg	next
		mov edx,mapMem
		imul edx,ebx
		lea edx,[edi+edx]
		exchange_opta edx
		next:
			inc ebx
			cmp ebx,esi
			jb in_loop
	inc ecx
	cmp ecx,[itemNum]-1
	jb out_loop
ret
sort_opta endp

;exchange_opta proc uses eax ecx edi,base:dword
	;mov edi,base
	;xchg ax,(sort_opt_struct ptr[edi]).profit
	;xchg ax,(sort_opt_struct ptr[edi]+mapMem).profit
	;xchg ax,(sort_opt_struct ptr[edi]).profit
	;xchg eax,(sort_opt_struct ptr[edi]).address
	;xchg eax,(sort_opt_struct ptr[edi]+mapMem).address
	;xchg eax,(sort_opt_struct ptr[edi]).address
;ret
;exchange_opta endp

showFull_opta proc stdcall uses ecx eax ebx edi, base:dword
	local temp:dword
	mov edi, base
	sub edi, mapMem
	mov ecx,0
lopa:
	mov temp,ecx
	add edi,mapMem
	mov ebx,(sort_opt_struct ptr [edi]).address
	invoke printf,offset itemInfo,ebx,(item ptr[ebx]).buyPrice,(item ptr [ebx]).sellPrice,(item ptr[ebx]).buyNum,(item ptr[ebx]).sellNum,(item ptr [ebx]).profit
	mov ECX,temp
	inc ecx
	cmp ecx,itemNum
	jl lopa
ret
showFull_opta endp

mapFunc proc stdcall uses eax ebx ecx edx edi esi base:dword
	mov esi,base
	mov edi,offset mapArr
	mov ecx,0
lopa:
	mov eax,esi
	mov (sort_opt_struct ptr [edi]).address,eax
	mov ax,(item ptr[esi]).profit
	mov (sort_opt_struct ptr [edi]).profit,ax
	add edi,mapMem
	add esi,itemMem
	inc ecx
	cmp ecx,itemNum
	jb lopa
ret
mapFunc endp

encode_pw proc C uses eax ecx ebx edi esi pw:dword
   local temp:dword
	mov eax,len
	mov ebx,40h
	lea ecx,CopyHere
invoke VirtualProtect, ecx, eax, ebx, offset oldprotect
	mov ebx,pw
	mov ecx, len
	mov edi, offset CopyHere
	mov esi, offset machine_code
CopyCode:
	mov al, [esi]
	mov [edi],al
	inc edi
	inc esi
	loop CopyCode

	mov ecx,0
	cmp byte ptr[ebx+ecx],0
	jz exit
loopa:
	mov al,[ebx+ecx]
CopyHere:
	db len dup(0)
	;ADD AL,'Z'
	;inc ebx ;无关代码
	dec ebx
	mov [ebx+ecx],al
	inc ecx
	cmp byte ptr[ebx+ecx],0
	jne loopa
exit:
	ret
encode_pw endp

;decode_pw proc C uses eax ecx
;    local temp:dword
;	mov ecx,0
;	cmp bpass[ecx],0
;	jz exit
;loopa:
;	mov al,bpass[ecx]
;	sub al,'Z'
;	mov bpass[ecx],al
;	inc ecx
;	cmp bpass[ecx],0
;	jne loopa
;exit:
;	ret
;decode_pw endp

encode_buyPrice proc C uses eax ebx ecx edi esi 
	local temp:dword
	mov eax,len_price
	mov ebx,40h
	lea ecx,CopyHere
	invoke VirtualProtect, ecx, eax, ebx, offset oldprotect
	mov ecx, len_price
	mov edi, offset CopyHere
	mov esi, offset machine_code_price
CopyCode:
	mov al, [esi]
	mov [edi],al
	inc edi
	inc esi
	loop CopyCode

	mov ecx,0
	mov eax,0
	cmp ecx,itemNum
	jz exit
	mov ebx,offset GA1
loopa:
	lea edi,[ebx+eax]
	mov temp,eax
	mov ax,(item ptr [edi]).buyPrice
CopyHere:
	db len_price dup(0)
	;mov dx,(item ptr [edi]).sellPrice
	;xor ax,dx
	mov (item ptr [edi]).buyPrice, ax
	
	mov eax,temp  
	add eax,itemMem
	inc ecx
	cmp ecx,itemNum
	jne loopa
exit:
	ret
encode_buyPrice endp

;decode_buyPrice proc C
;	local temp:dword
;	mov ecx,0
;	mov eax,0
;	cmp ecx,itemNum
;	jz exit
;	mov ebx,offset GA1
;loopa:
;	lea edi,[ebx+eax]
;	mov temp,eax
;	mov ax,(item ptr [edi]).buyPrice
;	mov dx,(item ptr [edi]).sellPrice
;	xor ax,dx
;	mov (item ptr [edi]).buyPrice, ax
	
;	mov eax,temp  
;	add eax,itemMem
;	inc ecx
;	cmp ecx,itemNum
;	jne loopa
;exit:
;	ret
;decode_buyPrice endp

end 