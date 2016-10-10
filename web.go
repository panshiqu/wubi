package main

import (
	"crypto/md5"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

func procRequest(w http.ResponseWriter, r *http.Request) {
	if r.URL.RequestURI() != "/" {
		return
	}

	f, err := os.Open("index.html")
	if err != nil {
		log.Fatal("os.Open failed", err)
	}

	defer f.Close()

	body, err := ioutil.ReadAll(f)
	if err != nil {
		log.Fatal("ioutil.ReadAll failed", err)
	}

	h := md5.New()
	io.WriteString(h, HanZi[Pos])
	fmt.Fprint(w, fmt.Sprintf(string(body), h.Sum(nil), h.Sum(nil), h.Sum(nil)))

	fmt.Println(Pos)

	Pos++
}

func main() {
	http.HandleFunc("/", procRequest)
	http.Handle("/gif/", http.FileServer(http.Dir(".")))
	http.Handle("/swf/", http.FileServer(http.Dir(".")))

	if err := http.ListenAndServe(":8081", nil); err != nil {
		log.Fatal("http.ListenAndServe failed", err)
	}
}

// HanZi 汉字
var HanZi = []string{"一", "乙"}

// Pos 位置
var Pos int
