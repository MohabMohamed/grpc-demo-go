# ───────────────────────────────────────────────────────────────
# Makefile – go-service  (output in ./pb)
# ───────────────────────────────────────────────────────────────

MODULE      := github.com/MohabMohamed/grpc-demo-go
PROTO_DIR   := ./proto
OUT_DIR     := pb
BIN         := bin/server

PROTO_FILES := $(wildcard $(PROTO_DIR)/*.proto)

GO_VERSION  := 1.21
PROTOC_GEN_GO_VER        := v1.35.1
PROTOC_GEN_GO_GRPC_VER   := v1.5.1

define green
	@printf "\033[32m▶ %s\033[0m\n" $(1)
endef

.PHONY: proto tools tidy build run test clean subupdate

tools:  ## install protoc plug‑ins in $$GOBIN
	$(call green,"Installing protoc plugins (only first time)…")
	go install google.golang.org/protobuf/cmd/protoc-gen-go@$(PROTOC_GEN_GO_VER)
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@$(PROTOC_GEN_GO_GRPC_VER)

proto:
	protoc -I $(PROTO_DIR) --go_out=$(OUT_DIR) --go_opt=paths=source_relative --go-grpc_out=$(OUT_DIR) --go-grpc_opt=paths=source_relative $(PROTO_DIR)/*.proto

tidy:  ## go mod tidy
	go mod tidy

build: proto tidy  ## compile
	$(call green,"Building $(BIN)…")
	go vet ./...
	go build -o $(BIN) ./cmd/server

run: build  ## build & start
	$(call green,"Running gRPC Orders service on :50051")
	./$(BIN)

test: proto tidy
	go test ./...

clean:  ## wipe generated code & binary
	rm -rf $(OUT_DIR) $(BIN)

subupdate:  ## update
