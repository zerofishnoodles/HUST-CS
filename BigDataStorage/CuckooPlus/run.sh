#!/usr/bin/env zsh
# echo "test"

filepath="result3.txt"
CuckooPlus=/home/ray/junior/BigDataStorage/CuckooHash/CuckooPlus/CuckooPlus1

declare  -a  HashTableSize
declare  -a  PlaceNum
declare -a lf

HashTableSize=(250000)
PlaceNum=(4)
lf=(70)

#display run progress
progress=12

for ((i=1;i<=${#HashTableSize[@]};i++)) 
do  
# run sh
./CuckooPlus1 -HashTableSize=$HashTableSize[i] -Debug=false -PlaceNum=$PlaceNum[i] -lf=$lf[i]>> $filepath

echo -e "=========================================================> $i/$progress done\n" >> $filepath
echo -e "=========================================================> $i/$progress done\n"

done
