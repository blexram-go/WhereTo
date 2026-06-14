package handlers

import (
	"net/http"

	"github.com/blexram-go/wheretoapp-backend/internal/services"
	"github.com/gin-gonic/gin"
)

func GetPlaces(c *gin.Context) {
	category := c.Query("category")

	places := services.GetPlaces(category)

	c.JSON(http.StatusOK, places)
}
