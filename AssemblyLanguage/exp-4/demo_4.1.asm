.386
stack segment use16 stack
	  db 200 dup(0)
stack ends

code segment use16
	 assume cs:code, ds:code, ss:stack
	 count db 18
	 hour db ?,?,':'
	 min db ?,?,':'
	 sec db ?,?
	 buf_len = $ - hour
	 cursor dw ?
	 old_int dw ?,?
;新int 08h 的代码
new08h proc far
	   pushf
	   call dword ptr cs:old_int
	   dec cs: count
	   jz disp
	   iret	
disp:
	   mov cs:count, 18
	   sti
	   pusha
	   push ds
	   push es
	   mov ax, cs
	   mov ds, ax
	   mov es, ax
	   call get_time
	   mov bh,0
	   mov ah,3
	   int 10h
	   mov cursor, dx
	   mov bp, offset hour
	   mov bh,0
	   mov dh,0
	   mov dl,80-buf_len
	   mov bl,07h
	   mov cx,buf_len
	   mov al,0
	   mov ah,13h
	   int 10h
	   mov bh,0
	   mov dx,cursor
	   mov ah,2
	   int 10h

	   pop es
	   pop ds
	   popa
	   iret	
new08h endp

get_time proc
		 mov al,4
		 out 70h,al
		 jmp $+2
		 in al,71h
		 mov ah,al
		 and al,0fh
		 shr ah,4
		 add ax,3030h
		 xchg ah,al
		 mov word ptr hour, ax

		 mov al,2
		 out 70h, al
		 jmp $+2
		 in al,71h
		 mov ah,al
		 and al,0fh
		 shr ah,4
		 add ax,3030h
		 xchg ah,al
		 mov word ptr min,ax


		 mov al,0
		 out 70h, al
		 jmp $+2
		 in al,71h
		 mov ah,al
		 and al,0fh
		 shr ah,4
		 add ax,3030h
		 xchg ah,al
		 mov word ptr sec,ax
		 ret
get_time endp

begin: 
	push cs
	pop ds
	mov ax,3508h
	int 21h
	mov old_int, bx
	mov old_int+2, es
	mov dx, offset new08h

	;查看是否重复安装
	cmp old_int, dx ;注意前两个字节为偏移地址
	jz exit
	mov ax,es
	cmp ax,code
	jz exit
	

	mov ax,2508h
	int 21h
next:
	mov ah,0
	int 16h
	cmp al,'q'
	jne next
exit:
	mov ax,3508h
	int 21h
	;lds dx, dword ptr old_int
	;mov ax,2508h  ;恢复
	;int 21h
	mov dx,100h
	mov ah,31h
	int 21h
	;mov ah,4ch   ;退出
	;int 21h
code ends
	end begin




	   
