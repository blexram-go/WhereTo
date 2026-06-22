package services

import (
	"strings"

	"github.com/blexram-go/wheretoapp-backend/internal/models"
)

func GetRecommendations(condition string) ([]models.Activity, error) {
	condition = strings.ToLower(condition)

	switch {

	case strings.Contains(condition, "sunny"),
		strings.Contains(condition, "clear"):

		return []models.Activity{
			{
				Name:        "Hiking",
				Category:    "Outdoor",
				Description: "Great weather for hiking trails",
			},
			{
				Name:        "Park Visit",
				Category:    "Outdoor",
				Description: "Enjoy a local park",
			},
		}, nil

	case strings.Contains(condition, "cloud"),
		strings.Contains(condition, "overcast"):

		return []models.Activity{
			{
				Name:        "City Walk",
				Category:    "Outdoor",
				Description: "Comfortable weather for exploring",
			},
			{
				Name:        "Local Attraction",
				Category:    "General",
				Description: "Visit nearby attractions",
			},
		}, nil

	case strings.Contains(condition, "rain"),
		strings.Contains(condition, "drizzle"):

		return []models.Activity{
			{
				Name:        "Museum",
				Category:    "Indoor",
				Description: "Stay dry while exploring exhibits",
			},
			{
				Name:        "Coffee Shop",
				Category:    "Indoor",
				Description: "Relax indoors with a drink",
			},
		}, nil

	case strings.Contains(condition, "fog"),
		strings.Contains(condition, "mist"):

		return []models.Activity{
			{
				Name:        "Museum",
				Category:    "Indoor",
				Description: "Good option during low visibility conditions",
			},
			{
				Name:        "Coffee Shop",
				Category:    "Indoor",
				Description: "Relax indoors",
			},
		}, nil
	}

	return []models.Activity{
		{
			Name:        "Explore Local Attractions",
			Category:    "General",
			Description: "Suggested based on your location.",
		},
	}, nil
}
