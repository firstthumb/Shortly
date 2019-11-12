package service

import (
	"context"
	"encoding/json"
	"errors"
	firebase "firebase.google.com/go"
	"fmt"
	"github.com/go-resty/resty/v2"
	"github.com/jschoedt/go-firestorm"
	log "github.com/sirupsen/logrus"
	"google.golang.org/api/option"
	"os"
	"path/filepath"
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

var config = &firebase.Config{
	ProjectID: "shortly-8a1b4",
}

func NewShortenService() ShortenService {
	absPath, _ := filepath.Abs("./shortly-firebase-adminsdk.json")
	opt := option.WithCredentialsFile(absPath)
	app, err := firebase.NewApp(context.Background(), config, opt)
	if err != nil {
		log.Errorf("Cannot create firebase app => %v", err)
	}
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

func (s *ShortenServiceImpl) GetUser(userId string) (*entity.User, error) {
	ctx := context.Background()
	firestore, err := s.firebaseApp.Firestore(ctx)
	if err != nil {
		log.Error(err)
		return nil, err
	}
	defer firestore.Close()
	fsc := firestorm.New(firestore, "Id", "")

	user := &entity.User{Id: userId}
	_, err = fsc.NewRequest().GetEntities(ctx, user)()
	if err != nil {
		log.Error(err)
		return nil, err
	}

	return user, nil
}

func (s *ShortenServiceImpl) GetSync(userId string) ([]entity.Shorten, error) {
	user, err := s.GetUser(userId)
	if err != nil {
		log.Error(err)
		return nil, err
	}

	return user.GetShortens()
}

func (s *ShortenServiceImpl) Sync(userId string, shortens []entity.Shorten, deleted []string) ([]entity.Shorten, error) {
	ctx := context.Background()
	firestore, err := s.firebaseApp.Firestore(ctx)
	if err != nil {
		log.Error(err)
		return nil, err
	}
	defer firestore.Close()
	fsc := firestorm.New(firestore, "Id", "")

	var dbShortens []entity.Shorten
	user, err := s.GetUser(userId)
	if err != nil {
		log.Infof("Creating new entry for User : %s", userId)
		user = &entity.User{
			Id: userId,
		}
		err = fsc.NewRequest().CreateEntities(ctx, user)()
		if err != nil {
			log.Error(err)
		}
	} else {
		dbShortens, _ = user.GetShortens()
	}

	var result []entity.Shorten

	for _, s := range dbShortens {
		if deleted == nil || !contains(deleted, s.Id) {
			if containsShortenById(shortens, s.Id) {
				log.Infof("Update Shorten => Id: %s", s.Id)
			} else {
				result = append(result, s)
			}
		} else {
			log.Infof("Deleted Shorten => Id: %s", s.Id)
		}
	}

	for _, s := range shortens {
		result = append(result, s)
	}

	log.Infof("Result value : %v", result)

	payload, err := json.Marshal(result)
	if err != nil {
		log.Error(err)
		return nil, err
	}
	log.Infof("JSON : %s", payload)

	_ = user.SaveShortens(result)
	err = fsc.NewRequest().UpdateEntities(ctx, user)()
	if err != nil {
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

func containsShortenById(a []entity.Shorten, x string) bool {
	for _, n := range a {
		if x == n.Id {
			return true
		}
	}
	return false
}
