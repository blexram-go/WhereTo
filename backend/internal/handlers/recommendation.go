package handlers

import (
	"net/http"

	"github.com/blexram-go/wheretoapp-backend/internal/models"
	"github.com/blexram-go/wheretoapp-backend/internal/services"
	"github.com/gin-gonic/gin"
)

func GetRecommendations(c *gin.Context) {
	lat := c.Query("lat")
	lng := c.Query("lng")

	weather := services.GetWeather(lat, lng)

	activities := services.GetRecommmendations(weather.Condition)

	response := models.RecommendationResponse{
		Weather:    weather.Condition,
		Activities: activities,
	}

	c.JSON(http.StatusOK, response)
}
