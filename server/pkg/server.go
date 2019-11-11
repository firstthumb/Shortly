package server

import (
	"github.com/codegangsta/negroni"
	"github.com/gorilla/mux"
	"net/http"
	"shortly/pkg/handler"
	"shortly/pkg/wire"
)

type Server interface {
	NewMux() *http.ServeMux
}

type HttpServer struct {
}

func (s *HttpServer) NewMux() *http.ServeMux {
	shortenService := wire.NewContext()

	m := http.NewServeMux()
	r := mux.NewRouter()

	//handlers
	n := negroni.New(
		negroni.NewLogger(),
	)

	//shorten handlers
	handler.MakeShortenHandlers(r, *n, shortenService)
	handler.MakeSyncShortenHandlers(r, *n, shortenService)

	m.Handle("/", r)
	r.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	return m
}
