;Muhammad Awais		20L-2188
;Ahmad Mamoon		20L2128
org 0x100
jmp start
ballx: dw 38
bally: dw 23
name:db 'WELCOME' , 0
n: db'WELL PLAYED', 0

clearscr:	push es
		push ax
		push cx
		push di
		mov ax , 0xb800
		mov es , ax
		xor di , di
		mov ax , 0x0720
		mov cx , 2000
		cld
		rep stosw
		pop di
		pop cx
		pop ax
		pop es
		ret

Hailo:		push es
		push ax
		push cx
		push di
		mov ax , 0xb800
		mov es , ax
		mov di , 800
		mov ax , 0x0720
		mov cx , 1520
		cld
		rep stosw
		pop di
		pop cx
		pop ax
		pop es
		ret

brick:		push bp
		mov bp , sp
		push es
		push ax
		push cx
		push bx
		push di
		mov ax , 0xb800
		mov es , ax
		mov bx , 11
l:		mov al , 80
		mul byte [bp+6]
		add ax , [bp+8]
		shl ax , 1
		mov di , ax
		mov ax , [bp+4]
		mov cx , 6
		cld
		repne stosw
		add word [bp+8] , 7
		dec bx
		mov cx , 0
		cmp cx , bx
		jne l
		pop di
		pop bx
		pop cx
		pop ax
		pop es
		pop bp
		ret 6

board:		push bp
		mov bp , sp
		push es
		push ax
		push cx
		push di
		mov ax , 0xb800
		mov es , ax
		mov al , 80
		mul byte [bp+6]
		add ax , [bp+8]
		shl ax , 1
		mov di , ax
		mov ax , [bp+4]
		mov cx , 10
		cld
		repne stosw

		pop di
		pop cx
		pop ax
		pop es
		pop bp
		ret 6

ball:		push bp
		mov bp , sp
		push es
		push ax
		push cx
		push di
		mov ax , 0xb800
		mov es , ax
		mov al , 80
		mul byte [bp+6]
		add ax , [bp+8]
		shl ax , 1
		mov di , ax
		mov ax , [bp+4]
		mov cx , 1
		cld
		repne stosw

		pop di
		pop cx
		pop ax
		pop es
		pop bp
		ret 6

sleep:		push cx
		mov cx , 0xffff
delay:		loop delay
		mov cx , 0xffff
delay1:		loop delay1
		pop cx
		ret

remove:		push bp
		mov bp , sp
		push es
		push ax
		push cx
		push bx
		push di
		mov ax , 0xb800
		mov es , ax
		mov al , 80
		mul byte [bp+4]
		add ax , [bp+6]
		shl ax , 1
		mov di , ax
		mov ax , 0x720
		mov cx , 6
		cld
		repne stosw
		pop di
		pop bx
		pop cx
		pop ax
		pop es
		pop bp
		ret 4


str_len:	push bp
		mov bp , sp
		push es
		push cx
		push di

		les di , [bp+4]
		xor al , al
		mov cx , 0xffff
		repne scasb
		mov ax , 0xffff
		sub ax , cx
		dec ax 		;Total length in ax 

		pop di
		pop cx
		pop es
		pop bp
		ret 4

print_scr	push bp
		mov bp , sp
		push es
		push ax
		push cx
		push si
		push di
		
		push ds
		mov ax , [bp+4]
		push ax
		call str_len
		cmp ax , 0
		jz exit
		mov cx , ax		;length of string in cx register
		
		mov ax , 0xb800
		mov es , ax
		mov al , 80
		mul byte [bp+8]
		add ax , [bp+10]
		shl ax , 1
		mov di , ax
		mov si , [bp+4]
		mov ah , [bp+6]
next:		cld
		lodsb
		stosw
		loop next

exit:		pop di
		pop si
		pop cx
		pop ax
		pop es
		pop bp
		ret 8

start:		call clearscr
		mov ax , 25	;x pos
		push ax
		mov ax , 12	;y pos
		push ax
		mov ax , 0x50	;attribute
		push ax
		mov ax , name
		push ax
		call print_scr	;function to print welcome
		mov ah , 0	;service 0 keyboard strike
		int 0x16	;BIOS keyboard service
		call clearscr

		mov ax , 1	;x pos
		push ax
		mov ax , 0	;y pos
		push ax
		mov ax , 0x7120	;attribute
		push ax
		call brick	;function to print bricks

		
		mov ax , 1	;x pos
		push ax
		mov ax , 2	;y pos
		push ax
		mov ax , 0x1720	;attribute
		push ax
		call brick	;function to print bricks
		

		mov ax , 1	;x pos
		push ax
		mov ax , 4	;y pos
		push ax
		mov ax , 0x2020	;attribute
		push ax
		call brick	;function to print bricks


		mov ax , 34	;x pos
		push ax
		mov ax , 24 	;y pos
		push ax
		mov ax , 0x4520	;attribute
		push ax
		call board	;function to print board

		mov ah , 0	;service 0 keyboard strike
		int 0x16	;BIOS keyboard service

		mov cx , 10
loop1:
		mov ax , [ballx]	;x pos
		push ax
		mov ax , [bally]	;y pos
		push ax
		mov ax , 0x034f		;attribute of ball
		push ax
		call ball		;function to print ball
		call sleep
		call sleep
		call sleep
		call sleep
		call sleep
		call sleep
		call Hailo		;function to clrscren below the bricks
		sub word [bally] , 2
		dec cx
		jnz loop1
		
		mov ax , 36
		push ax
		mov ax , 4
		push ax
		call remove
		
		mov ah , 0	;service 0 keyboard strike
		int 0x16	;BIOS keyboard service

		call clearscr

		mov ah , 0	;service 0 keyboard strike
		int 0x16	;BIOS keyboard service

		mov ax , 25
		push ax
		mov ax , 12
		push ax
		mov ax , 0x60
		push ax
		mov ax , n
		push ax
		call print_scr

e:		mov ax , 0x4c00
		int 21h