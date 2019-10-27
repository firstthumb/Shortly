package service

type ShortenType int

const (
	TIKITOK ShortenType = iota
	SHORTURL
)

type ShortenService interface {
	Shorten(ShortenType, string) (string, error)
}
