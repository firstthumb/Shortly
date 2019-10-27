package service

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/go-resty/resty/v2"
	log "github.com/sirupsen/logrus"
	"os"
	"strings"
)

const BaseUrl = "https://firebasedynamiclinks.googleapis.com"
const TikitokType = "https://tikitok.tk"
const ShorturlType = "https://shorturl.tk"

type ShortenServiceImpl struct {
	client *resty.Client
}

func NewShortenService() ShortenService {
	return &ShortenServiceImpl{
		client: resty.New(),
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
