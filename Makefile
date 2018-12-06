GO_ENV=CGO_ENABLED=0
GO_BUILD=go build -ldflags '-s -w'
GO_INSTALL=go install -ldflags '-s'
GO_LIB_FILES=lib.go
GO_BINARIES=ekshealthtest
GO_BIN_CMDS=ekshealthtest/cmd/ekshealthtest
GO_FMT=gofmt -s -w
GO_IMPORTS=goimports -w
GO_VET=go vet
all: ${GO_BINARIES}
ekshealthtest: cmd/ekshealthtest/ekshealthtest.go ${GO_LIB_FILES}
	 ${GO_ENV} ${GO_BUILD} -o ekshealthtest cmd/ekshealthtest/ekshealthtest.go
install: ${GO_BINARIES}
	${GO_INSTALL} ${GO_BIN_CMDS}
clean:
	rm -f ${GO_BINARIES}
check: fmt imports vet
fmt:
	./for_each_go_file.sh "${GO_FMT}"
imports:
	./for_each_go_file.sh "${GO_IMPORTS}"
vet:
	./vet_files.sh "${GO_VET}"
.PHONY: all
