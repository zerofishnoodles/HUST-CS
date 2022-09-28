#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>

typedef struct item {
	char itemName[10];
	short buyPrice;
	short sellPrice;
	short buyNum;
	short sellNum;
	short profit;
}Item;

extern int flag;
extern char bname;
extern char bpass;
extern int itemNum;
extern Item GA1;
void showFull(Item* base);
void profitCal(void);
void encode_pw(char* pw);



int myStrCmp(char* s1, char* s2) {
	int i = 0;
	while (s1[i] != 0 && s2[i] != 0) {
		if (s1[i] != s2[i]) return 0;
		i++;
	}
	if (s1[i] != 0 || s2[i] != 0) return 0;
	return 1;
}

int login(void) {
	flag = 1;
	char acc[20] = { 0 };
	char pw[20] = { 0 };
	printf("please enter your account:\n");
	scanf("%s", acc);
	printf("please enter your password:\n");
	scanf("%s", pw);
	int i = 0;
	encode_pw(pw);
	flag = myStrCmp(acc, &bname);
	flag = myStrCmp(pw, &bpass);
	return 0;
}

void showMenu(void) {
	printf("--------------menu-------------\n");
	printf("1.show the item information\n");
	printf("2.sell the item\n");
	printf("3.buy the item\n");
	printf("4.calculate the profit\n");
	printf("5.sort by the profit\n");
	printf("6.add item\n");
	printf("9.exit the program\n");
	printf("please enter your choice:\n");
	
	return;
}

void addNewItem(void)
{
	char itemName[10] = { 0 };
	printf("please enter the item name:");
	scanf("%s", itemName);
	for (int i = 0; i < itemNum; i++) {
		if (!strcmp(itemName, &GA1 + i))
		{
			printf("wrong!\n");
			return;
		}
	}
	
	short buyPrice;
	printf("please enter the buy price:");
	scanf("%hd", &buyPrice);

	short sellPrice;
	printf("please enter the sell price:");
	scanf("%hd", &sellPrice);

	short buyNum;
	printf("please enter the buy Num:");
	scanf("%hd", &buyNum);

	short sellNum;
	printf("please enter the sell Num:");
	scanf("%hd", &sellNum);
	if (sellNum > buyNum) {
		printf("wrong!\n");
		return;
	}

	Item *newItem = &GA1 + itemNum;
	strcpy(newItem->itemName, itemName);
	newItem->buyNum = buyNum;
	newItem->buyPrice = buyPrice;
	newItem->sellNum = sellNum;
	newItem->sellPrice = sellPrice;

	itemNum++;
	profitCal();
	showFull(&GA1);
	return;
}

