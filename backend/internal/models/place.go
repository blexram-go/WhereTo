package models

type Place struct {
	Name     string  `json:"name"`
	Address  string  `json:"address"`
	Rating   float64 `json:"rating"`
	Category string  `json:"category"`
}
