package main

import (
	"log"

	"github.com/blexram-go/wheretoapp-backend/internal/config"
	"github.com/blexram-go/wheretoapp-backend/internal/database"
	"github.com/blexram-go/wheretoapp-backend/internal/handlers"
	"github.com/blexram-go/wheretoapp-backend/internal/repository"
	"github.com/blexram-go/wheretoapp-backend/internal/services"
	"github.com/gin-gonic/gin"
)

func main() {
	cfg := config.Load()

	// Start DB conn
	db, err := database.Connect(cfg.DatabaseURL)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	log.Printf("Starting server on port %s", cfg.Port)

	router := gin.Default()

	api := router.Group("/api/v1")

	// Instantiate repositories, services and handler managers
	userRepository := repository.NewUserRepository(db)

	weatherService := services.NewWeatherService(cfg.WeatherAPIKey)
	placesService := services.NewPlacesService(cfg.PlacesAPIKey)
	authService := services.NewAuthService(userRepository)

	weatherHandler := handlers.NewWeatherHandler(weatherService)
	recommendationHandler := handlers.NewRecommendationHandler(weatherService)
	placesHandler := handlers.NewPlacesHandler(placesService)
	discoverHandler := handlers.NewDiscoverHandler(weatherService, placesService)
	authHandler := handlers.NewAuthHandler(authService)

	// routes
	api.GET("/health", handlers.Health)
	api.GET("/weather", weatherHandler.GetWeather)
	api.GET("/recommendations", recommendationHandler.GetRecommendations)
	api.GET("/places", placesHandler.GetPlaces)
	api.GET("/discover", discoverHandler.Discover)
	api.GET("/popular-places", placesHandler.GetPopularPlaces)

	api.POST("/register", authHandler.Register)
	api.POST("/login", authHandler.Login)

	if err := router.Run(":" + cfg.Port); err != nil {
		log.Fatal(err)
	}
}
