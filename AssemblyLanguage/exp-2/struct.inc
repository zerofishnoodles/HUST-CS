sort_opt_struct struct
	address dd 0
	profit dw 0
sort_opt_struct ends

item struct	
	itemName  db 10 dup(0)
	buyPrice dw 0
	sellPrice dw 0
	buyNum dw 0
	sellNum dw 0
	profit dw 0
item ends