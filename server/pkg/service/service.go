package service

import "shortly/pkg/entity"

type ShortenType int

const (
	TIKITOK ShortenType = iota
	SHORTURL
)

type ShortenService interface {
	Shorten(ShortenType, string) (string, error)
	Sync(string, []entity.Shorten, []string) ([]entity.Shorten, error)
	GetSync(string) ([]entity.Shorten, error)
}
