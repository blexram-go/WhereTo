package services

import "github.com/blexram-go/wheretoapp-backend/internal/models"

type PlacesService struct {
	apiKey string
}

func NewPlacesService(apiKey string) *PlacesService {
	return &PlacesService{
		apiKey: apiKey,
	}
}

func (s *PlacesService) GetPlaces(category string) ([]models.Place, error) {
	switch category {
	case "Outdoor":
		return []models.Place{
			{
				Name:     "Griffith Park Hiking Trails",
				Address:  "Griffith Park, CA",
				Rating:   4.2,
				Category: "Outdoor",
			},
		}, nil
	}

	return []models.Place{}, nil
}
