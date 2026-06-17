package handlers

import (
	"net/http"

	"github.com/blexram-go/wheretoapp-backend/internal/models"
	"github.com/blexram-go/wheretoapp-backend/internal/services"
	"github.com/gin-gonic/gin"
)

type WeatherHandler struct {
	weatherService *services.WeatherService
}

func NewWeatherHandler(weatherService *services.WeatherService) *WeatherHandler {
	return &WeatherHandler{
		weatherService: weatherService,
	}
}

func (h *WeatherHandler) GetWeather(c *gin.Context) {
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
		c.JSON(
			http.StatusBadRequest,
			models.ErrorResponse{
				Error: err.Error(),
			},
		)
		return
	}

	c.JSON(http.StatusOK, weather)
}
