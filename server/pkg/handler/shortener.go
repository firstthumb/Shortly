package handler

import (
	"encoding/json"
	"github.com/codegangsta/negroni"
	"github.com/gorilla/mux"
	"io/ioutil"
	"net/http"
	"shortly/pkg/service"
)

type ShortlyRequest struct {
	Link string `json:"link"`
	Type string `json:"type,omitempty"`
}

type ShortlyResponse struct {
	ShortUrl string `json:"short_url"`
}

func shortenIndex(srv service.ShortenService) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		body, err := ioutil.ReadAll(r.Body)
		if err != nil {
			http.Error(w, err.Error(), 500)
			return
		}

		request := &ShortlyRequest{}
		err = json.Unmarshal(body, request)
		if err != nil {
			http.Error(w, err.Error(), 500)
			return
		}

		resp, err := srv.Shorten(service.TIKITOK, request.Link)
		if err != nil {
			http.Error(w, err.Error(), 500)
			return
		}

		output, err := json.Marshal(ShortlyResponse{ShortUrl: resp})
		if err != nil {
			http.Error(w, err.Error(), 500)
			return
		}

		w.Header().Set("content-type", "application/json")
		w.Write(output)
	})
}

func MakeShortenHandlers(r *mux.Router, n negroni.Negroni, service service.ShortenService) {
	r.Handle("/v1/shorten", n.With(
		negroni.Wrap(shortenIndex(service)),
	)).Methods("POST", "OPTIONS").Name("shortenIndex")
}
