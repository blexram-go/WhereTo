package config

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

// Config will hold all API keys and configurations for the backend system
type Config struct {
	Port          string
	WeatherAPIKey string
	PlacesAPIKey  string
	DatabaseURL   string
	JWTSecret     string
}

// Load will actively load the config for the backend system
func Load() *Config {
	err := godotenv.Load()

	if err != nil {
		log.Println("No .env file found")
	}

	weatherAPIKey := getEnv("WEATHER_API_KEY", "")
	if weatherAPIKey == "" {
		log.Fatal("WEATHER_API_KEY is not set")
	}

	placesAPIKey := getEnv("GOOGLE_PLACES_API_KEY", "")
	if placesAPIKey == "" {
		log.Fatal("GOOGLE_PLACES_API_KEY is not set")
	}

	dbURL := getEnv("DATABASE_URL", "")
	if dbURL == "" {
		log.Fatal("DATABASE_URL is not set")
	}

	jwtSecret := getEnv("JWT_SECRET", "")
	if jwtSecret == "" {
		log.Fatal("JWT_SECRET is not set")
	}

	return &Config{
		Port:          getEnv("PORT", "8080"),
		WeatherAPIKey: weatherAPIKey,
		PlacesAPIKey:  placesAPIKey,
		DatabaseURL:   dbURL,
		JWTSecret:     jwtSecret,
	}
}

// getEnv is a helper method that returns the environment variable from .env or a a fallback string
func getEnv(key, fallback string) string {
	value := os.Getenv(key)

	if value == "" {
		return fallback
	}

	return value
}
