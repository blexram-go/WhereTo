package main

import (
	"log"

	"github.com/blexram-go/wheretoapp-backend/internal/config"
	"github.com/blexram-go/wheretoapp-backend/internal/handlers"
	"github.com/blexram-go/wheretoapp-backend/internal/services"
	"github.com/gin-gonic/gin"
)

func main() {
	cfg := config.Load()

	log.Printf("Starting server on port %s", cfg.Port)

	router := gin.Default()

	api := router.Group("/api/v1")

	// Instantiate services and handler manager
	weatherService := services.NewWeatherService(cfg.WeatherAPIKey)
	placesService := services.NewPlacesService(cfg.PlacesAPIKey)

	weatherHandler := handlers.NewWeatherHandler(weatherService)
	recommendationHandler := handlers.NewRecommendationHandler(weatherService)
	placesHandler := handlers.NewPlacesHandler(placesService)
	discoverHandler := handlers.NewDiscoverHandler(weatherService, placesService)

	// routes
	api.GET("/health", handlers.Health)
	api.GET("/weather", weatherHandler.GetWeather)
	api.GET("/recommendations", recommendationHandler.GetRecommendations)
	api.GET("/places", placesHandler.GetPlaces)
	api.GET("/discover", discoverHandler.Discover)
	api.GET("/popular-places", discoverHandler.GetPopularPlaces) // THis will work with the WhereTo button

	if err := router.Run(":" + cfg.Port); err != nil {
		log.Fatal(err)
	}
}
