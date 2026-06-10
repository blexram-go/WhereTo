package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetRecommendations(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"activities": []string{
			"Hiking",
			"Park",
			"Outdoor Dining",
		},
	})
}
