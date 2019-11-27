package entity

import (
	b64 "encoding/base64"
	"encoding/json"
	"time"
)

type Shorten struct {
	Id        string `json:"id" bson:"_id"`
	Link      string `json:"link" bson:"link"`
	ShortLink string `json:"short_link" bson:"short_link"`
	Fav       bool   `json:"fav" bson:"fav"`
	CreatedAt int    `json:"created_at" bson:"created_at"`
}

type User struct {
	Id        string    `json:"id"`
	Email     string    `json:"email"`
	Name      string    `json:"name"`
	Shortens  string    `json:"shortens"` // base64 encoded string
	UpdatedAt time.Time `json:"updated_at"`
}

func (f *User) GetShortens() ([]Shorten, error) {
	jsonPayload, err := b64.StdEncoding.DecodeString(f.Shortens)
	if err != nil {
		return nil, err
	}

	var shortens []Shorten
	err = json.Unmarshal(jsonPayload, &shortens)
	if err != nil {
		return nil, err
	}

	return shortens, nil
}

func (f *User) SaveShortens(shortens []Shorten) error {
	jsonPayload, err := json.Marshal(shortens)
	if err != nil {
		return err
	}

	f.Shortens = b64.StdEncoding.EncodeToString(jsonPayload)
	f.UpdatedAt = time.Now().UTC()

	return nil
}
