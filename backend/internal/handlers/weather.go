package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetWeather(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"temperature": 82,
		"condition":   "Sunny",
	})
}
