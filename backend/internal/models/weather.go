package models

type WeatherAPIResponse struct {
	Temperature float64 `json:"temperature"`
	Condition   string  `json:"condition"`
	City        string  `json:"city"`
}
