package services

import "github.com/blexram-go/wheretoapp-backend/internal/models"

func GetWeather(lat, lng string) models.WeatherAPIResponse {
	return models.WeatherAPIResponse{
		Temperature: 82,
		Condition:   "Sunny",
		City:        "Los Angeles",
	}
}
