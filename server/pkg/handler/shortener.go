package handler

import (
	"encoding/json"
	"github.com/codegangsta/negroni"
	"github.com/gorilla/mux"
	"io/ioutil"
	log "github.com/sirupsen/logrus"
	"net/http"
	"shortly/pkg/service"
)

type ShortlyRequest struct {
	Link string `json:"link"`
	Type string `json:"type,omitempty"`
}

type ShortlyResponse struct {
	ShortUrl 	string `json:"short_url"`
	Url 		string `json:"url"`
}

func shortenIndex(srv service.ShortenService) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		body, err := ioutil.ReadAll(r.Body)
		if err != nil {
			log.Errorf("Shorten Handler => Could not read request. %v", err)
			http.Error(w, err.Error(), 500)
			return
		}

		request := &ShortlyRequest{}
		err = json.Unmarshal(body, request)
		if err != nil {
			log.Errorf("Shorten Handler => Could not unmarshal request. %v", err)
			http.Error(w, err.Error(), 500)
			return
		}

		resp, err := srv.Shorten(service.TIKITOK, request.Link)
		if err != nil {
			log.Errorf("Shorten Handler => Could not call shorten service. %v", err)
			http.Error(w, err.Error(), 500)
			return
		}

		output, err := json.Marshal(ShortlyResponse{ShortUrl: resp, Url: request.Link})
		if err != nil {
			log.Errorf("Shorten Handler => Could not marshal response. %v", err)
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
