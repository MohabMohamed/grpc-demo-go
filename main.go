package main

import (
	"log"
	"net"

	ordersPB "github.com/MohabMohamed/grpc-demo-go/pb"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

func createServer() *grpc.Server {
	srv := grpc.NewServer()
	var u Orders
	ordersPB.RegisterOrdersServer(srv, &u)
	reflection.Register(srv)
	return srv
}

func main() {
	addr := ":9090"

	lis, err := net.Listen("tcp", addr)

	if err != nil {
		log.Fatalf("error: can't listen - %s", err)
	}

	srv := createServer()

	log.Printf("info: server ready on %s", addr)
	if err := srv.Serve(lis); err != nil {
		log.Fatalf("error: can't serve - %s", err)
	}

}

type Orders struct {
	ordersPB.UnimplementedOrdersServer
}