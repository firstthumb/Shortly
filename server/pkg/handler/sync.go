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
	Shortens []entity.Shorten `json:"shortens"`
	Deleted  []string         `json:"deleted"`
	Email    string           `json:"email"`
	Name     string           `json:"name"`
}

type SyncResponse struct {
	Shortens []entity.Shorten `json:"shortens"`
}

type ErrorResponse struct {
	Message string `json:"message"`
}

func syncShorten(srv service.ShortenService) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		userId := mux.Vars(r)["userId"]
		log.Infof("Sync Shortens => UserId : %s", userId)

		body, err := ioutil.ReadAll(r.Body)
		if err != nil {
			log.Errorf("Sync Shorten Handler => Could not read request. %v", err)
			errorJson, _ := json.Marshal(&ErrorResponse{Message: "Service Failed"})
			http.Error(w, string(errorJson), 500)
			return
		}

		request := &SyncRequest{}
		err = json.Unmarshal(body, request)
		if err != nil {
			log.Errorf("Sync Shorten Handler => Could not unmarshal request. %v", err)
			errorJson, _ := json.Marshal(&ErrorResponse{Message: "Service Failed"})
			http.Error(w, string(errorJson), 500)
			return
		}

		shortens, err := srv.Sync(userId, request.Email, request.Name, request.Shortens, request.Deleted)
		if err != nil {
			log.Errorf("Sync Shorten Handler => Could not call shorten service. %v", err)
			errorJson, _ := json.Marshal(&ErrorResponse{Message: "Service Failed"})
			http.Error(w, string(errorJson), 500)
			return
		}

		output, err := json.Marshal(SyncResponse{Shortens: shortens})
		if err != nil {
			log.Errorf("Shorten Handler => Could not marshal response. %v", err)
			errorJson, _ := json.Marshal(&ErrorResponse{Message: "Service Failed"})
			http.Error(w, string(errorJson), 500)
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
			errorJson, _ := json.Marshal(&ErrorResponse{Message: "Service Failed"})
			http.Error(w, string(errorJson), 500)
			return
		}

		output, err := json.Marshal(SyncResponse{Shortens: shortens})
		if err != nil {
			log.Errorf("Shorten Handler => Could not marshal response. %v", err)
			errorJson, _ := json.Marshal(&ErrorResponse{Message: "Service Failed"})
			http.Error(w, string(errorJson), 500)
			return
		}

		w.Header().Set("content-type", "application/json")
		_, _ = w.Write(output)
	})
}

func MakeSyncShortenHandlers(r *mux.Router, n negroni.Negroni, service service.ShortenService) {
	r.Handle("/v1/sync/{userId}", n.With(
		negroni.Wrap(syncShorten(service)),
	)).Methods("POST", "OPTIONS").Name("syncShorten")
	r.Handle("/v1/sync/{userId}", n.With(
		negroni.Wrap(getSyncShorten(service)),
	)).Methods("GET").Name("getSyncShorten")
}
