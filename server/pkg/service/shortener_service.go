package service

import (
	"context"
	"encoding/json"
	"errors"
	firebase "firebase.google.com/go"
	"fmt"
	"github.com/go-resty/resty/v2"
	log "github.com/sirupsen/logrus"
	"google.golang.org/api/option"
	"os"
	"shortly/pkg/entity"
	"strings"
)

const BaseUrl = "https://firebasedynamiclinks.googleapis.com"
const TikitokType = "https://tikitok.tk"
const ShorturlType = "https://shorturl.tk"

type ShortenServiceImpl struct {
	client      *resty.Client
	firebaseApp *firebase.App
}

// TODO: Fill
var config = &firebase.Config{
	AuthOverride:     nil,
	DatabaseURL:      "",
	ProjectID:        "",
	ServiceAccountID: "",
	StorageBucket:    "",
}

func NewShortenService() ShortenService {
	opt := option.WithCredentialsJSON([]byte("a.sa"))
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		log.Errorf("Cannot create firebase app => %v", err)
	}
	app.Firestore()
	return &ShortenServiceImpl{
		client:      resty.New(),
		firebaseApp: app,
	}
}

type ShortenRequest struct {
	Info DynamicLinkInfo `json:"dynamicLinkInfo"`
}

type DynamicLinkInfo struct {
	DomainUriPrefix string `json:"domainUriPrefix"`
	Link            string `json:"link"`
}

type ShortenResponse struct {
	ShortLink   string `json:"shortLink"`
	PreviewLink string `json:"previewLink"`
}

type ShortenErrorResponse struct {
	Error ShortenError `json:"error"`
}

type ShortenError struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
	Status  string `json:"status"`
}

func (s *ShortenServiceImpl) GetSync(userId string) ([]entity.Shorten, error) {
	ctx := context.Background()
	database, err := s.firebaseApp.Database(ctx)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}

	var shortens []entity.Shorten
	if err := database.NewRef("users/"+userId+"/shortens").Get(ctx, &shortens); err != nil {
		log.Fatal(err)
		return nil, err
	}

	return shortens, nil
}

func (s *ShortenServiceImpl) Sync(userId string, shortens []entity.Shorten, deleted []string) ([]entity.Shorten, error) {
	ctx := context.Background()
	database, err := s.firebaseApp.Database(ctx)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}

	var result []entity.Shorten

	var dbShortens []entity.Shorten
	if err := database.NewRef("users/"+userId+"/shortens").Get(ctx, &dbShortens); err != nil {
		log.Fatal(err)
		return nil, err
	}

	for _, s := range dbShortens {
		if deleted == nil || !contains(deleted, s.Id) {
			result = append(result, s)
		} else {
			log.Infof("Deleted Shorten => Id: %s", s.Id)
		}
	}

	for _, s := range shortens {
		result = append(result, s)
	}

	if err := database.NewRef("users/"+userId+"/shortens").Set(ctx, result); err != nil {
		log.Fatal(err)
		return nil, err
	}

	return result, nil
}

func (s *ShortenServiceImpl) Shorten(shortenType ShortenType, url string) (string, error) {
	log.Infof("Shorten Service => Type: %d Url: %s", shortenType, url)

	uriPrefix := "https://tikitok.tk"
	switch shortenType {
	case TIKITOK:
		uriPrefix = TikitokType
	case SHORTURL:
		uriPrefix = ShorturlType
	}

	if !strings.HasPrefix(url, "http") {
		url = fmt.Sprintf("%s%s", "http://", url)
		log.Infof("Updated Url: %s", url)
	}

	req := &ShortenRequest{
		Info: DynamicLinkInfo{
			DomainUriPrefix: uriPrefix,
			Link:            url,
		},
	}

	data, err := json.Marshal(req)
	if err != nil {
		log.Errorf("Error on marshal: %v", err)
		return "", err
	}

	resp, err := s.client.R().EnableTrace().
		SetHeader("Content-Type", "application/json").
		SetBody(data).
		SetResult(&ShortenResponse{}).
		Post(fmt.Sprintf("%s%s?key=%s", BaseUrl, "/v1/shortLinks", os.Getenv("FIREBASE_KEY")))

	if err != nil {
		log.Errorf("Error on request: %v", err)
		return "", err
	}

	if resp.StatusCode() >= 400 {
		log.Errorf("Body: %s", resp)
		shortenError := &ShortenError{}
		if err := json.Unmarshal(resp.Body(), shortenError); err != nil {
			return "", err
		}
		log.Errorf("Error on request: %s", shortenError.Message)
		return "", errors.New(shortenError.Message)
	}

	shortenResp := &ShortenResponse{}
	if err := json.Unmarshal(resp.Body(), shortenResp); err != nil {
		log.Errorf("Error on unmarshal: %v", err)
		return "", err
	}

	log.Infof("Result: %s", shortenResp.ShortLink)
	return shortenResp.ShortLink, nil
}

func contains(a []string, x string) bool {
	for _, n := range a {
		if x == n {
			return true
		}
	}
	return false
}
