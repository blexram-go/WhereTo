package handlers

import (
	"net/http"

	"github.com/blexram-go/wheretoapp-backend/internal/models"
	"github.com/blexram-go/wheretoapp-backend/internal/services"
	"github.com/gin-gonic/gin"
)

type RecommendationHandler struct {
	weatherService *services.WeatherService
}

func NewRecommendationHandler(WeatherService *services.WeatherService) *RecommendationHandler {
	return &RecommendationHandler{
		weatherService: WeatherService,
	}
}

func (h *RecommendationHandler) GetRecommendations(c *gin.Context) {
	lat := c.Query("lat")
	lng := c.Query("lng")

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

	response := models.RecommendationResponse{
		Weather:    weather.Condition,
		Activities: activities,
	}

	c.JSON(http.StatusOK, response)
}
