package main

import (
	"fmt"

	"github.com/blexram-go/wheretoapp-backend/internal/handlers"
	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	api := router.Group("/api/v1")

	api.GET("/health", handlers.Health)
	api.GET("/weather", handlers.GetWeather)
	api.GET("/recommendations", handlers.GetRecommendations)
	api.GET("/places", handlers.GetPlaces)

	fmt.Println("Starting server...")
	router.Run()
}
