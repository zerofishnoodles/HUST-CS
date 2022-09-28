###
### 相册处理程序
### 实现功能：前翻页， 后翻页， 显示图片
### 图片大小 128*128
### 将本程序转成hex导入指令存储器， turn-left 和 turn-right的入口地址需要自己硬件实现送入pc

.text
start:
	addi $s0, $0, 0  # 图片起始基址
	addi $s1, $zero, 128
	sll $s1, $s1, 7  # 图片大小
	addi $s2, $0, 0  # photo index
	addi $s3, $0, 1

album_display:
	add   $v0,$zero,$s2         # display
	syscall                  

halt:		
	addi   $v0,$zero,50         # system call for exit
	syscall                  # halt

turn_left:
	sub $s0, $s0, $s1
	sub $s2, $s2, $s3
	j album_display

turn_right:
	add $s0, $s0, $s1
	add $s2, $s2, $s3
	j album_display
