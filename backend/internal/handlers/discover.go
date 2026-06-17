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

func NewDiscoverHandler(weatherService *services.WeatherService, placesService *services.PlacesService) *DiscoverHandler {
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
	}

	activities, err := services.GetRecommendations(weather.Condition)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.ErrorResponse{
			Error: err.Error(),
		})
	}

	var places []models.Place

	if len(activities) > 0 {
		places, err = h.placesService.GetPlaces(activities[0].Category)
		if err != nil {
			c.JSON(http.StatusBadRequest, models.ErrorResponse{
				Error: err.Error(),
			})
		}
	}

	response := models.DiscoverResponse{
		Weather:    weather,
		Activities: activities,
		Places:     places,
	}

	c.JSON(http.StatusOK, response)
}
