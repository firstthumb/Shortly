package shortly

import (
	"net/http"
	server "shortly/pkg"
)

var mux = (&server.HttpServer{}).NewMux()

func ShortlyService(w http.ResponseWriter, r *http.Request) {
	mux.ServeHTTP(w, r)
}
