package handlers

import (
	"net/http"

	"github.com/blexram-go/wheretoapp-backend/internal/models"
	"github.com/blexram-go/wheretoapp-backend/internal/services"
	"github.com/gin-gonic/gin"
)

type DiscoverHandler struct {
	weatherService *services.WeatherService
	placesService  *services.PlacesService
}

func NewDiscoverHandler(
	weatherService *services.WeatherService,
	placesService *services.PlacesService,
) *DiscoverHandler {
	return &DiscoverHandler{
		weatherService: weatherService,
		placesService:  placesService,
	}
}

func (h *DiscoverHandler) Discover(c *gin.Context) {
	lat := c.Query("lat")
	lng := c.Query("lng")

	if lat == "" || lng == "" {
		c.JSON(http.StatusBadRequest, models.ErrorResponse{
			Error: "lat and lng are required",
		})
		return
	}

	weather, err := h.weatherService.GetWeather(lat, lng)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.ErrorResponse{
			Error: err.Error(),
		})
		return
	}

	activities, err := services.GetRecommendations(weather)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.ErrorResponse{
			Error: err.Error(),
		})
		return
	}

	var places []models.Place

	seen := make(map[string]bool)

	for _, activity := range activities {
		results, err := h.placesService.GetPlaces(
			activity.Name,
			lat,
			lng,
		)
		if err != nil {
			continue
		}

		if len(results) > 5 {
			results = results[:5]
		}

		for _, place := range results {
			key := place.Name + place.Address

			if !seen[key] {
				seen[key] = true
				places = append(places, place)
			}
		}
	}

	response := models.DiscoverResponse{
		Weather:    weather,
		Activities: activities,
		Places:     places,
	}

	c.JSON(http.StatusOK, response)
}
