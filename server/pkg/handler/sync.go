package handler

import (
	"encoding/json"
	"github.com/codegangsta/negroni"
	"github.com/gorilla/mux"
	log "github.com/sirupsen/logrus"
	"io/ioutil"
	"net/http"
	"shortly/pkg/entity"
	"shortly/pkg/service"
)

type SyncRequest struct {
	UserId   string           `json:"user_id"`
	Shortens []entity.Shorten `json:"shortens"`
	Deleted  []string         `json:"deleted"`
}

type SyncResponse struct {
	Shortens []entity.Shorten `json:"shortens"`
}

func syncShorten(srv service.ShortenService) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		body, err := ioutil.ReadAll(r.Body)
		if err != nil {
			log.Errorf("Sync Shorten Handler => Could not read request. %v", err)
			http.Error(w, err.Error(), 500)
			return
		}

		request := &SyncRequest{}
		err = json.Unmarshal(body, request)
		if err != nil {
			log.Errorf("Sync Shorten Handler => Could not unmarshal request. %v", err)
			http.Error(w, err.Error(), 500)
			return
		}

		shortens, err := srv.Sync(request.UserId, request.Shortens)
		if err != nil {
			log.Errorf("Sync Shorten Handler => Could not call shorten service. %v", err)
			http.Error(w, err.Error(), 500)
			return
		}

		output, err := json.Marshal(SyncResponse{Shortens: shortens})
		if err != nil {
			log.Errorf("Shorten Handler => Could not marshal response. %v", err)
			http.Error(w, err.Error(), 500)
			return
		}

		w.Header().Set("content-type", "application/json")
		_, _ = w.Write(output)
	})
}

func getSyncShorten(srv service.ShortenService) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		userId := mux.Vars(r)["userId"]
		log.Infof("Get Sync Shortens => UserId : %s", userId)

		shortens, err := srv.GetSync(userId)
		if err != nil {
			log.Errorf("Sync Shorten Handler => Could not call shorten service. %v", err)
			http.Error(w, err.Error(), 500)
			return
		}

		output, err := json.Marshal(SyncResponse{Shortens: shortens})
		if err != nil {
			log.Errorf("Shorten Handler => Could not marshal response. %v", err)
			http.Error(w, err.Error(), 500)
			return
		}

		w.Header().Set("content-type", "application/json")
		_, _ = w.Write(output)
	})
}

func MakeSyncShortenHandlers(r *mux.Router, n negroni.Negroni, service service.ShortenService) {
	r.Handle("/v1/sync", n.With(
		negroni.Wrap(syncShorten(service)),
	)).Methods("POST", "OPTIONS").Name("syncShorten")
	r.Handle("/v1/sync/{userId}", n.With(
		negroni.Wrap(getSyncShorten(service)),
	)).Methods("GET").Name("getSyncShorten")
}
