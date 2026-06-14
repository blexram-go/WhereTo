package services

import "github.com/blexram-go/wheretoapp-backend/internal/models"

func GetPlaces(category string) []models.Place {
	switch category {
	case "Hiking":
		return []models.Place{
			{
				Name:     "Griffith Park Hiking Trails",
				Address:  "Griffith Park, CA",
				Rating:   4.2,
				Category: "Hiking",
			},
		}
	}

	return []models.Place{}
}
