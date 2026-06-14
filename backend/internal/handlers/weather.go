package handlers

import (
	"net/http"

	"github.com/blexram-go/wheretoapp-backend/internal/services"
	"github.com/gin-gonic/gin"
)

func GetWeather(c *gin.Context) {
	lat := c.Query("lat")
	lng := c.Query("long")

	weather := services.GetWeather(lat, lng)

	c.JSON(http.StatusOK, weather)
}
