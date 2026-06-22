package services

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/blexram-go/wheretoapp-backend/internal/models"
)

type WeatherService struct {
	apiKey string
}

func NewWeatherService(apiKey string) *WeatherService {
	return &WeatherService{
		apiKey: apiKey,
	}
}

func (s *WeatherService) GetWeather(lat, lng string) (models.WeatherAPIResponse, error) {
	url := fmt.Sprintf(
		"http://api.weatherapi.com/v1/current.json?key=%s&q=%s,%s",
		s.apiKey,
		lat,
		lng,
	)

	resp, err := http.Get(url)
	if err != nil {
		return models.WeatherAPIResponse{}, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return models.WeatherAPIResponse{}, fmt.Errorf("weather api returned status %d", resp.StatusCode)
	}

	var providerResp models.WeatherProviderResponse

	err = json.NewDecoder(resp.Body).Decode(&providerResp)
	if err != nil {
		return models.WeatherAPIResponse{}, err
	}

	return models.WeatherAPIResponse{
		Temperature: providerResp.Current.TempF,
		Condition:   providerResp.Current.Condition.Text,
		City:        providerResp.Location.Name,
	}, nil
}
