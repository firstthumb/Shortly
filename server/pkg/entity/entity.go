package entity

type Shorten struct {
	Id        string `json:"id" bson:"_id"`
	Link      string `json:"link" bson:"link"`
	ShortLink string `json:"short_link" bson:"short_link"`
	Fav       bool   `json:"fav" bson:"fav"`
	CreatedAt int    `json:"created_at" bson:"created_at"`
}
