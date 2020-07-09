FROM golang:1.14 AS builder
WORKDIR /app/
COPY . /app/
RUN cp "`go env GOROOT`/misc/wasm/wasm_exec.js" ./public
RUN GOOS=js GOARCH=wasm go build -o ./public/main.wasm ./src/...

FROM nginx:alpine
RUN sed -i -e "s/}/\napplication\/wasm wasm;\n}/g" /etc/nginx/mime.types
COPY --from=builder /app/public /usr/share/nginx/html/