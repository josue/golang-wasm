build_app:
	GOOS=js GOARCH=wasm go build -o ./public/main.wasm ./src

copy_wasm_js:
	cp "`go env GOROOT`/misc/wasm/wasm_exec.js" ./public/

install_goexec:
	@[ "`command -v goexec`" == "" ] && go get -u github.com/shurcooL/goexec || echo "Found: goexec"

run_local: build_app copy_wasm_js install_goexec
	open http://localhost:4000
	goexec 'http.ListenAndServe(":4000", http.FileServer(http.Dir("./public/")))'

buid_docker:
	docker build -t test-golang-wasm .

run_docker: buid_docker
	docker stop golang-wasm-app || true && docker rm golang-wasm-app || true
	docker run --rm --name golang-wasm-app -d -p 5000:80 test-golang-wasm
	open http://localhost:5000