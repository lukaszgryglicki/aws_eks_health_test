GO_ENV=CGO_ENABLED=0
GO_BUILD=go build -ldflags '-s -w'
GO_INSTALL=go install -ldflags '-s'
GO_LIB_FILES=lib.go
GO_BINARIES=ekshealthtest
GO_BIN_CMDS=ekshealthtest/cmd/ekshealthtest
all: ${GO_BINARIES}
ekshealthtest: cmd/ekshealthtest/ekshealthtest.go ${GO_LIB_FILES}
	 ${GO_ENV} ${GO_BUILD} -o ekshealthtest cmd/ekshealthtest/ekshealthtest.go
install: ${GO_BINARIES}
	${GO_INSTALL} ${GO_BIN_CMDS}
clean:
	rm -f ${GO_BINARIES}
.PHONY: all
