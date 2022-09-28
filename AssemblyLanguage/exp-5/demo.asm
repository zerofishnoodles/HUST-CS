.386
.model   flat,stdcall
option   casemap:none

WinMain  proto :DWORD,:DWORD,:DWORD,:DWORD
WndProc  proto :DWORD,:DWORD,:DWORD,:DWORD
Display  proto :DWORD
profitCal proto C
sort proto :dword
exchange proto :dword
cal_len proto :dword
itoa proto :word

include      menuID.INC

include      windows.inc
include      user32.inc
include      kernel32.inc
include      gdi32.inc
include      shell32.inc

includelib   user32.lib
includelib   kernel32.lib
includelib   gdi32.lib
includelib   shell32.lib

item struct	
	itemName  db 10 dup(0)
	buyPrice dw 0
	sellPrice dw 0
	buyNum dw 0
	sellNum dw 0
	profit dw 0
item ends

.data
ClassName    db       'TryWinClass',0
AppName      db       'Our First Window',0
MenuName     db       'MyMenu',0
DlgName	     db       'MyDialog',0
AboutMsg     db       'Welcome to the Store Manage System!',0Ah,0Dh,'The Owner: ZhangRui',0
hInstance    dd       0
CommandLine  dd       0
buf	    item <'PEN', 15, 20, 70, 25,?> ;进货价、销售价、进货数量、已售数量，利润率（尚未计算）
		item <'PENCIL',2,3,100,50,?>
		item <'BOOK',30,40,25,5,?>
		item <'RULER',3,4,200,150,?>
msg_itemName     db       'itemName',0
msg_buyPrice  db       'buyPrice',0
msg_sellPrice     db       'sellPrice',0
msg_buyNum  db       'buyNum',0
msg_sellNum  db       'sellNum',0
msg_profit    db       'profit',0
menuItem     db       0  ;当前菜单状态, 1=处于list, 0=Clear, 2=Compute Rate, 3=Sort
itemMem equ 20
itemNum dword 4
temp_str db 10 dup(0)
temp_len dword 0

.code
Start:	     invoke GetModuleHandle,NULL
	     mov    hInstance,eax
	     invoke GetCommandLine
	     mov    CommandLine,eax
	     invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	     invoke ExitProcess,eax
	     ;;
WinMain  proc   hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
	     LOCAL  wc:WNDCLASSEX
	     LOCAL  msg:MSG
	     LOCAL  hWnd:HWND
         invoke RtlZeroMemory,addr wc,sizeof wc
	     mov    wc.cbSize,SIZEOF WNDCLASSEX
	     mov    wc.style, CS_HREDRAW or CS_VREDRAW
	     mov    wc.lpfnWndProc, offset WndProc
	     mov    wc.cbClsExtra,NULL
	     mov    wc.cbWndExtra,NULL
	     push   hInst
	     pop    wc.hInstance
	     mov    wc.hbrBackground,COLOR_WINDOW+1
	     mov    wc.lpszMenuName, offset MenuName
	     mov    wc.lpszClassName,offset ClassName
	     invoke LoadIcon,NULL,IDI_APPLICATION
	     mov    wc.hIcon,eax
	     mov    wc.hIconSm,0
	     invoke LoadCursor,NULL,IDC_ARROW
	     mov    wc.hCursor,eax
	     invoke RegisterClassEx, addr wc
	     INVOKE CreateWindowEx,NULL,addr ClassName,addr AppName,\
                    WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
                    CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,\
                    hInst,NULL
	     mov    hWnd,eax
	     INVOKE ShowWindow,hWnd,SW_SHOWNORMAL
	     INVOKE UpdateWindow,hWnd
	     ;;
MsgLoop:     INVOKE GetMessage,addr msg,NULL,0,0
             cmp    EAX,0
             je     ExitLoop
             INVOKE TranslateMessage,addr msg
             INVOKE DispatchMessage,addr msg
	     jmp    MsgLoop 
ExitLoop:    mov    eax,msg.wParam
	     ret
WinMain      endp

WndProc      proc   hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	     LOCAL  hdc:HDC
	     LOCAL  ps:PAINTSTRUCT
     .IF     uMsg == WM_DESTROY
	     invoke PostQuitMessage,NULL
     .ELSEIF uMsg == WM_KEYDOWN
	    .IF     wParam == VK_F1
             ;;your code
	    .ENDIF
     .ELSEIF uMsg == WM_COMMAND
	    .IF     wParam == IDM_FILE_EXIT
		    invoke SendMessage,hWnd,WM_CLOSE,0,0
	    .ELSEIF wParam == IDM_FILE_LIST
		    mov menuItem, 1
		    invoke InvalidateRect,hWnd,0,1  ;擦除整个客户区
		    invoke UpdateWindow, hWnd
	    .ELSEIF wParam == IDM_FILE_CLEAR
		    mov menuItem, 0
		    invoke InvalidateRect,hWnd,0,1  ;擦除整个客户区
		    invoke UpdateWindow, hWnd
	    .ELSEIF wParam == IDM_HELP_ABOUT
		    invoke MessageBox,hWnd,addr AboutMsg,addr AppName,0
		.ELSEIF wParam == IDM_ACTION_CompRate
			mov menuItem, 2
			invoke InvalidateRect,hWnd,0,1  ;擦除整个客户区
		    invoke UpdateWindow, hWnd
		.ELSEIF wParam == IDM_ACTION_Sort
			mov menuItem, 3
			invoke InvalidateRect,hWnd,0,1  ;擦除整个客户区
		    invoke UpdateWindow, hWnd
	    .ENDIF
     .ELSEIF uMsg == WM_PAINT
             invoke BeginPaint,hWnd, addr ps
             mov hdc,eax
	     .IF menuItem == 1
		 invoke Display,hdc
		 .ELSEIF menuItem == 2
		 invoke profitCal	
		 .ELSEIF menuItem == 3
		 invoke sort, offset buf
		 invoke Display,hdc
	     .ENDIF
	     invoke EndPaint,hWnd,addr ps
     .ELSE
             invoke DefWindowProc,hWnd,uMsg,wParam,lParam
             ret
     .ENDIF
  	     xor    eax,eax
	     ret
WndProc      endp

Display      proc uses eax ebx ecx esi ,  hdc:HDC
		local temp:word, temp_count:dword, var_Y:dword
             XX     equ  10
             YY     equ  10
	     XX_GAP equ  100
	     YY_GAP equ  30
             invoke TextOut,hdc,XX+0*XX_GAP,YY+0*YY_GAP,offset msg_itemName,8
             invoke TextOut,hdc,XX+1*XX_GAP,YY+0*YY_GAP,offset msg_buyPrice,8
             invoke TextOut,hdc,XX+2*XX_GAP,YY+0*YY_GAP,offset msg_sellPrice,9
             invoke TextOut,hdc,XX+3*XX_GAP,YY+0*YY_GAP,offset msg_buyNum,6
             invoke TextOut,hdc,XX+4*XX_GAP,YY+0*YY_GAP,offset msg_sellNum,7
             invoke TextOut,hdc,XX+5*XX_GAP,YY+0*YY_GAP,offset msg_profit,6
             ;;
		mov ecx,0
		mov ebx,offset buf
		cmp ecx,itemNum
		je exit
		lopa:
			 mov temp_count,ecx
			 mov eax,itemMem
			 imul eax,ecx
			 lea esi,[ebx+eax]
			 invoke cal_len,esi
			 mov eax,ecx
			 add eax,1
			 imul eax,YY_GAP
			 add eax,YY
			 mov var_Y,eax
             invoke TextOut,hdc,XX+0*XX_GAP,var_Y,esi,temp_len

			 mov ax,(item ptr [esi]).buyPrice
			 mov temp,ax
			 invoke itoa, temp
             invoke TextOut,hdc,XX+1*XX_GAP,var_Y,offset temp_str,temp_len

			 mov ax,(item ptr [esi]).sellPrice
			 mov temp,ax
			 invoke itoa, temp
             invoke TextOut,hdc,XX+2*XX_GAP,var_Y,offset temp_str,temp_len

			 mov ax,(item ptr [esi]).buyNum
			 mov temp,ax
			 invoke itoa, temp
             invoke TextOut,hdc,XX+3*XX_GAP,var_Y,offset temp_str,temp_len

			 mov ax,(item ptr [esi]).sellNum
			 mov temp,ax
			 invoke itoa, temp
             invoke TextOut,hdc,XX+4*XX_GAP,var_Y,offset temp_str,temp_len

			 mov ax,(item ptr [esi]).profit
			 mov temp,ax
			 invoke itoa, temp
             invoke TextOut,hdc,XX+5*XX_GAP,var_Y,offset temp_str,temp_len
			 mov ecx,temp_count
			 inc ecx
			 cmp ecx,itemNum
			 jne lopa
		exit:
             ret
Display      endp

profitCal proc C uses eax ebx ecx esi edi
	push edi
	push ebp
	mov ebp,esp
	mov ecx,0
	mov esi,offset buf
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
	mov ecx,9
lopa:
	xchg al,byte ptr[edi+[ecx]]
	xchg al,byte ptr[edi+[ecx]+itemMem]
	xchg al,byte ptr[edi+[ecx]]
	DEC ecx
	cmp ecx,0
	jge lopa
ret
exchange endp 

itoa proc uses eax ebx ecx edx esi, integ:word
	movsx eax,integ
	mov esi,offset temp_str
	mov ebx,10
	mov ecx,0
	cmp eax,0
	jge itoa_unsigned
	neg eax
	mov byte ptr [esi],'-'
	inc esi
itoa_unsigned:
	mov edx,0
	div ebx
	push edx
	inc ecx
	cmp eax,0
	jne itoa_unsigned
itoa_save:
	mov temp_len,ecx
	cmp integ,0
	jge itoa_convert
	inc ecx
	mov temp_len,ecx
	dec ecx
itoa_convert:
	pop edx
	add dl,30h
	mov [esi],dl
	inc esi
	dec ecx
	jnz itoa_convert
ret
itoa endp

cal_len proc uses eax ebx ecx ,address:dword
	mov ebx,address
	mov ecx,0
	mov al,byte ptr [ebx+ecx]
	cmp al,0
	jz exit
lopa:
	inc ecx
	mov al,[ebx+ecx]
	cmp al,0
	jnz lopa
exit:
	mov temp_len, ecx
	ret
cal_len endp

     end  Start
