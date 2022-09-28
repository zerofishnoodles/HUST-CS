package main

import (
	"bytes"
	"encoding/gob"
	"fmt"
	mathrand "math/rand"
	"time"
)

type CuckooHashTable struct {
	Val1         [][]int
	Val2         [][]int
	OccupiedNum1 int
	OccupiedNum2 int
}

func (ht *CuckooHashTable) init() {
	ht.OccupiedNum1 = 0
	ht.OccupiedNum2 = 0
	ht.Val1 = make([][]int, HashTableSize)
	for i := range ht.Val1 {
		ht.Val1[i] = make([]int, PlaceNum)
	}
	ht.Val2 = make([][]int, HashTableSize)
	for i := range ht.Val2 {
		ht.Val2[i] = make([]int, PlaceNum)
	}
}

// 返回插入是否成功以及一个int，如果成功则返回插入的值，如果失败则返回当前无法插入的值（不一定是要插入的值）
func (ht *CuckooHashTable) insert(hash *Hash, a int) (bool, int) {
	if ht.search(hash, a) {
		return true, a
	}
	cur_byte := a
	pre_kick := -1
	i := 0
	for i = 0; i < MAX_KICK; i++ {
		index1 := hash.hash1(int(cur_byte))
		index2 := hash.hash2(int(cur_byte))
		flag := 0
		for j := 0; j < PlaceNum; j++ {
			if ht.Val1[index1][j] == 0 {
				ht.Val1[index1][j] = cur_byte
				ht.OccupiedNum1++
				flag = 1
				break
			}
		}
		if flag == 1 {
			break
		}

		for j := 0; j < PlaceNum; j++ {
			if ht.Val2[index2][j] == 0 {
				ht.Val2[index2][j] = cur_byte
				ht.OccupiedNum2++
				flag = 1
				break
			}
		}
		if flag == 1 {
			break
		}

		if pre_kick == 1 {
			temp := ht.Val2[index2][0]
			ht.Val2[index2][0] = cur_byte
			cur_byte = temp
			pre_kick = 2
		} else {
			temp := ht.Val1[index1][0]
			ht.Val1[index1][0] = cur_byte
			cur_byte = temp
			pre_kick = 1
		}
	}

	if i == MAX_KICK {
		return false, cur_byte
	} else {
		return true, a
	}
}

func (ht *CuckooHashTable) search(hash *Hash, a int) bool {
	index1 := hash.hash1(int(a))
	index2 := hash.hash2(int(a))
	for i := 0; i < PlaceNum; i++ {
		if ht.Val1[index1][i] == a {
			return true
		}
	}
	for i := 0; i < PlaceNum; i++ {
		if ht.Val2[index2][i] == a {
			return true
		}
	}
	return false
}

func (ht *CuckooHashTable) delete(hash *Hash, a int) bool {
	index1 := hash.hash1(int(a))
	index2 := hash.hash2(int(a))
	for i := 0; i < PlaceNum; i++ {
		if ht.Val1[index1][i] == a {
			ht.Val1[index1][i] = 0
			ht.OccupiedNum1--
			return true
		}
	}
	for i := 0; i < PlaceNum; i++ {
		if ht.Val2[index2][i] == a {
			ht.Val2[index2][i] = 0
			ht.OccupiedNum2--
			return true
		}
	}

	return false
}

func (ht *CuckooHashTable) cacu_lf() float32 {
	return ((float32(ht.OccupiedNum1) + float32(ht.OccupiedNum2)) / float32(2*HashTableSize*PlaceNum)) * 100
}

func (ht *CuckooHashTable) rehash(hash *Hash, bufferbytes []int, total_bytes int) bool {
	hash.rehash()
	ht.init()
	for i := 0; i < total_bytes; i++ {
		if suc, _ := ht.insert(hash, bufferbytes[i]); !suc {
			return false
		}
	}
	return true

}

func (ht *CuckooHashTable) copy(dest *CuckooHashTable) error {
	var buf bytes.Buffer
	if err := gob.NewEncoder(&buf).Encode(*ht); err != nil {
		fmt.Println(err)
		return err
	}
	return gob.NewDecoder(bytes.NewBuffer(buf.Bytes())).Decode(dest)
}

type Hash struct {
	h1 int
	h2 int
	h3 int
	h4 int
}

func (hash *Hash) init() {
	mathrand.Seed(time.Now().UnixNano())
	hash.h1 = mathrand.Intn(MAXRANDOM)
	hash.h2 = mathrand.Intn(MAXRANDOM)
	hash.h3 = mathrand.Intn(MAXRANDOM)
	hash.h4 = mathrand.Intn(MAXRANDOM)
}

func (hash *Hash) hash1(h int) int {
	h ^= (h << hash.h1) ^ (h << hash.h2)
	return ((h ^ (h >> hash.h3) ^ (h >> hash.h4)) & 0x7fffffff) % HashTableSize
}

func (hash *Hash) hash2(h int) int {
	h ^= (h << hash.h4) ^ (h << hash.h3)
	return ((h ^ (h >> hash.h2) ^ (h >> hash.h1)) & 0x7fffffff) % HashTableSize
}

func (hash *Hash) rehash() {
	// mathrand.Seed(time.Now().UnixNano())
	hash.h1 = mathrand.Intn(MAXRANDOM)
	hash.h2 = mathrand.Intn(MAXRANDOM)
	hash.h3 = mathrand.Intn(MAXRANDOM)
	hash.h4 = mathrand.Intn(MAXRANDOM)
}
