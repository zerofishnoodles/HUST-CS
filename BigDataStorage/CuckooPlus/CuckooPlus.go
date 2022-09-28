package main

import (
	"flag"
	"fmt"
	"math/rand"
	"time"
)

var HashTableSize int
var PlaceNum int
var Debug bool

func main() {
	fmt.Println("this is a simple trial of the cuckoo hasing.")
	// parse arguments
	insert := true
	search := true
	delete := false
	HashTableSize_t := flag.Int("HashTableSize", 1000, "the size of the hash table")
	PlaceNum_t := flag.Int("PlaceNum", 1, "the place num of one place")
	Debug_t := flag.Bool("Debug", false, "if debug")
	lf := flag.Float64("lf", 100.0, "the lf you want to stop")
	flag.Parse()

	HashTableSize = *HashTableSize_t
	PlaceNum = *PlaceNum_t
	Debug := *Debug_t

	fmt.Println("Params setting:")
	fmt.Println("HashTableSize:", HashTableSize)
	fmt.Println("PlaceNum:", PlaceNum)
	fmt.Println()
	fmt.Println()

	// init hash table
	fmt.Println("preparing the hash table...")
	var HT CuckooHashTable
	var hash Hash
	HT.init()
	hash.init()
	fmt.Println("finsih preparing the hash table")

	// generate sample
	fmt.Println("Generate sample...")
	bufferInt := make([]int, 2*HashTableSize*PlaceNum)
	for i := 0; i < 2*HashTableSize*PlaceNum; i++ {
		bufferInt[i] = rand.Int()
	}

	// start modeling
	// insert test
	total_bytes := 0
	specila_byte := 0
	if insert {
		fmt.Println("Insert test...")
		startTime := time.Now()
		rehashTime := int64(0)

		for _, a := range bufferInt {
			i := 0
			for suc, cur := HT.insert(&hash, a); !suc; {
				j := 0
				rehashStartTime := time.Now()
				specila_byte = cur

				// copy
				tempHash := hash
				var tempHT CuckooHashTable
				err := HT.copy(&tempHT)
				if err != nil {
					panic("copy failed!")
				}

				// rehash
				for !HT.rehash(&hash, bufferInt, total_bytes) {
					j++
					if j == MAX_REHASH {
						fmt.Println("rehash failed, can't find another hash function")
						i = MAX_INSERT - 1
						err := tempHT.copy(&HT)
						if err != nil {
							panic("copy failed!")
						}
						hash = tempHash
						break
					}
				}
				subRehashTime := time.Since(rehashStartTime)
				rehashTime += int64(subRehashTime)
				i++
				if i == MAX_INSERT {
					break
				}
			}

			if i == MAX_INSERT {
				fmt.Println("Insert failed, the hash table is full")
				break
			}

			if Debug {
				err := HT.search(&hash, a)
				if !err {
					panic("error")
				} else {
					fmt.Printf("Successfully insert %d\n", a)
				}

			}
			total_bytes++
			if float64(HT.cacu_lf()) >= *lf {
				break;
			}
		}
		fmt.Printf("Insert test finish, use %s\n", time.Since(startTime))
		fmt.Printf("Rehash time %s", time.Duration(rehashTime))
		fmt.Println()
	}

	// search test
	if search {
		fmt.Println("Search test start...")
		startTime := time.Now()
		for i := 0; i < total_bytes; i++ {
			if !HT.search(&hash, bufferInt[i]) && bufferInt[i] != specila_byte {
				panic("search failed")
			}
		}
		fmt.Printf("Search test finish, use %s", time.Since(startTime))
		fmt.Println()
	}

	// delete test
	if delete {
		fmt.Println("Delete test start...")
		for i := 0; i < total_bytes; i++ {
			if !HT.delete(&hash, bufferInt[i]) {
				panic("delete failed")
			}
		}
		fmt.Println("Delete test finish")
	}

	// caculate the load factor
	load_factor := HT.cacu_lf()
	fmt.Printf("the load factor is %.2f%%\n", load_factor)
	fmt.Printf("total_insert:%d\n", HT.OccupiedNum1+HT.OccupiedNum2)
}
