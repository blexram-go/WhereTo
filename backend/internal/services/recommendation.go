package services

import "github.com/blexram-go/wheretoapp-backend/internal/models"

func GetRecommendations(condition string) ([]models.Activity, error) {
	switch condition {
	case "Sunny", "Clear":
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
	case "Rain":
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
	default:
		return []models.Activity{
			{
				Name:        "Explore Local Attractions",
				Category:    "General",
				Description: "Suggested based on your location.",
			},
		}, nil
	}
}
