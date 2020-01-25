all: etleneum runcall

etleneum: $(shell find . -name "*.go") bindata.go
	go build -ldflags="-s -w" -o ./etleneum

runcall: runlua/runlua.go runlua/cmd/main.go
	cd runlua/cmd && go build -o ../../runcall

bindata.go: static/bundle.js static/index.html static/global.css static/bundle.css
	go-bindata -o bindata.go static/...

static/bundle.js: $(shell find client)
	./node_modules/.bin/rollup -c

deploy_test: etleneum
	ssh root@nusakan-58 'systemctl stop etleneum-test'
	scp etleneum nusakan-58:etleneum-test/etleneum
	ssh root@nusakan-58 'systemctl start etleneum-test'
