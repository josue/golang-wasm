package main

import (
	"fmt"
	"syscall/js"
	"time"
)

func initHTMLContainer() {
	document := js.Global().Get("document")

	// create DIV tag with attribute [ID = data]
	p := document.Call("createElement", "div")
	p.Set("id", "data")
	document.Get("body").Call("appendChild", p)
}

func relayMessages(messages chan string) {
	data := js.Global().Get("document").Call("getElementById", "data")

	for m := range messages {
		data.Set("innerHTML", m)
	}
}

func main() {
	messages := make(chan string)
	count := 1

	initHTMLContainer()
	go relayMessages(messages)

	for {
		messages <- fmt.Sprintf("[%v] Hello from Golang WebAssembly =)", count)
		count++
		time.Sleep(time.Millisecond)
	}
}
