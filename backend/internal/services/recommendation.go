package services

import (
	"strings"

	"github.com/blexram-go/wheretoapp-backend/internal/models"
)

func GetRecommendations(
	weather models.WeatherAPIResponse,
) ([]models.Activity, error) {

	condition := strings.ToLower(weather.Condition)
	temp := weather.Temperature

	switch {

	case strings.Contains(condition, "rain"),
		strings.Contains(condition, "drizzle"):

		return []models.Activity{
			{
				Name:        "Museum",
				Category:    "Indoor",
				Description: "Stay dry while exploring exhibits.",
			},
			{
				Name:        "Coffee Shop",
				Category:    "Indoor",
				Description: "Relax indoors with a warm drink.",
			},
		}, nil

	case temp >= 90:

		return []models.Activity{
			{
				Name:        "Movie Theater",
				Category:    "Indoor",
				Description: "Too hot outside for extended outdoor activities.",
			},
			{
				Name:        "Shopping Center",
				Category:    "Indoor",
				Description: "Stay cool indoors.",
			},
		}, nil

	case temp >= 70 && temp < 90:

		return []models.Activity{
			{
				Name:        "Hiking",
				Category:    "Outdoor",
				Description: "Excellent weather for hiking.",
			},
			{
				Name:        "Park Visit",
				Category:    "Outdoor",
				Description: "Enjoy local parks and outdoor spaces.",
			},
		}, nil

	case temp >= 50 && temp < 70:

		return []models.Activity{
			{
				Name:        "City Walk",
				Category:    "Outdoor",
				Description: "Comfortable weather for exploring.",
			},
			{
				Name:        "Local Attraction",
				Category:    "General",
				Description: "Visit nearby attractions.",
			},
		}, nil
	}

	// fallback activity
	return []models.Activity{
		{
			Name:        "Coffee Shop",
			Category:    "Indoor",
			Description: "Relax indoors.",
		},
	}, nil
}
