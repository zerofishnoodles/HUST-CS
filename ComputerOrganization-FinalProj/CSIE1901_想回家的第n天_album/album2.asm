###
### ��ᴦ�����
### ʵ�ֹ��ܣ�ǰ��ҳ�� ��ҳ�� ��ʾͼƬ
### ͼƬ��С 128*128
### ��������ת��hex����ָ��洢���� turn-left �� turn-right����ڵ�ַ��Ҫ�Լ�Ӳ��ʵ������pc

.text
start:
	addi $s0, $0, 0  # ͼƬ��ʼ��ַ
	addi $s1, $zero, 128
	sll $s1, $s1, 7  # ͼƬ��С
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
