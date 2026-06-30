package handlers

import (
	"net/http"

	"github.com/blexram-go/wheretoapp-backend/internal/models"
	"github.com/blexram-go/wheretoapp-backend/internal/services"
	"github.com/gin-gonic/gin"
)

type PlacesHandler struct {
	placesService *services.PlacesService
}

func NewPlacesHandler(placesService *services.PlacesService) *PlacesHandler {
	return &PlacesHandler{
		placesService: placesService,
	}
}

func (h *PlacesHandler) GetPlaces(c *gin.Context) {
	category := c.Query("category")

	places, err := h.placesService.GetPlaces(category, "", "")
	if err != nil {
		c.JSON(http.StatusBadRequest, models.ErrorResponse{
			Error: err.Error(),
		})
	}

	c.JSON(http.StatusOK, places)
}

func (h *PlacesHandler) GetPopularPlaces(c *gin.Context) {
	lat := c.Query("lat")
	lng := c.Query("lng")

	if lat == "" || lng == "" {
		c.JSON(http.StatusBadRequest, models.ErrorResponse{
			Error: "lat and lng are required",
		})
		return
	}

	places, err := h.placesService.GetPopularPlaces(lat, lng)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.ErrorResponse{
			Error: err.Error(),
		})
		return
	}

	response := models.PlacesResponse{
		Places: places,
	}

	c.JSON(http.StatusOK, response)
}
