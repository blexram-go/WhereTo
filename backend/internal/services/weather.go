package services

import "github.com/blexram-go/wheretoapp-backend/internal/models"

type WeatherService struct {
	apiKey string
}

func NewWeatherService(apiKey string) *WeatherService {
	return &WeatherService{
		apiKey: apiKey,
	}
}

func (s *WeatherService) GetWeather(lat, lng string) (models.WeatherAPIResponse, error) {
	return models.WeatherAPIResponse{
		Temperature: 82,
		Condition:   "Sunny",
		City:        "Los Angeles",
	}, nil
}
