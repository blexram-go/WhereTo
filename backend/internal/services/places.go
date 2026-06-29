package services

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"sort"
	"strconv"
	"time"

	"github.com/blexram-go/wheretoapp-backend/internal/models"
)

// Const variable for providing Google Places API the required area to look for activities
const RADIUS = 2000

type PlacesService struct {
	apiKey string
}

func NewPlacesService(apiKey string) *PlacesService {
	return &PlacesService{
		apiKey: apiKey,
	}
}

// Simple mapping for activities and recommendations
var activitySearchMap = map[string]string{
	"Hiking":           "hiking trail",
	"Park Visit":       "park",
	"Museum":           "museum",
	"Coffee Shop":      "coffee shop",
	"Movie Theater":    "movie theater",
	"Shopping Center":  "shopping mall",
	"City Walk":        "tourist attraction",
	"Local Attraction": "tourist attraction",
}

func (s *PlacesService) GetPlaces(activity string, lat, lng string) ([]models.Place, error) {
	searchQuery := activitySearchMap[activity]

	if searchQuery == "" {
		searchQuery = "tourist attraction"
	}

	latFloat, err := strconv.ParseFloat(lat, 64)
	if err != nil {
		return nil, err
	}

	lngFloat, err := strconv.ParseFloat(lng, 64)
	if err != nil {
		return nil, err
	}

	var payload models.PlacesSearchRequest
	payload.TextQuery = searchQuery
	payload.LocationBias.Circle.Center.Latitude = latFloat
	payload.LocationBias.Circle.Center.Longitude = lngFloat
	payload.LocationBias.Circle.Radius = RADIUS

	body, err := json.Marshal(payload)
	if err != nil {
		return nil, err
	}

	req, err := http.NewRequest(
		"POST",
		"https://places.googleapis.com/v1/places:searchText",
		bytes.NewBuffer(body),
	)
	if err != nil {
		return nil, err
	}

	req.Header.Set(
		"Content-Type",
		"application/json",
	)
	req.Header.Set(
		"X-Goog-Api-Key",
		s.apiKey,
	)

	req.Header.Set(
		"X-Goog-FieldMask",
		"places.displayName,places.formattedAddress,places.rating",
	)

	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		bodyBytes, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("google places returned status %d: %s", resp.StatusCode, string(bodyBytes))
	}

	var googleResp models.GooglePlacesResponse

	err = json.NewDecoder(resp.Body).Decode(&googleResp)
	if err != nil {
		return nil, err
	}

	fmt.Printf("Google returned %d places\n", len(googleResp.Places))

	if len(googleResp.Places) > 0 {
		fmt.Printf("First place: %+v\n", googleResp.Places[0])
	}

	var places []models.Place

	for _, place := range googleResp.Places {
		places = append(places, models.Place{
			Name:     place.DisplayName.Text,
			Address:  place.FormattedAddress,
			Rating:   place.Rating,
			Category: activity,
		})
	}

	sort.Slice(
		places,
		func(i, j int) bool {
			return places[i].Rating > places[j].Rating
		},
	)

	return places, nil
}

func (s *PlacesService) GetPopularPlaces(lat, lng string) ([]models.Place, error) {
	latFloat, err := strconv.ParseFloat(lat, 64)
	if err != nil {
		return nil, err
	}

	lngFloat, err := strconv.ParseFloat(lng, 64)
	if err != nil {
		return nil, err
	}

	var payload models.PlacesSearchRequest
	payload.TextQuery = "tourist attraction"
	payload.LocationBias.Circle.Center.Latitude = latFloat
	payload.LocationBias.Circle.Center.Longitude = lngFloat
	payload.LocationBias.Circle.Radius = RADIUS

	body, err := json.Marshal(payload)
	if err != nil {
		return nil, err
	}

	req, err := http.NewRequest(
		"POST",
		"https://places.googleapis.com/v1/places:searchText",
		bytes.NewBuffer(body),
	)
	if err != nil {
		return nil, err
	}

	req.Header.Set(
		"Content-Type",
		"application/json",
	)
	req.Header.Set(
		"X-Goog-Api-Key",
		s.apiKey,
	)

	req.Header.Set(
		"X-Goog-FieldMask",
		"places.displayName,places.formattedAddress,places.rating",
	)

	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		bodyBytes, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("google places returned status %d: %s", resp.StatusCode, string(bodyBytes))
	}

	var googleResp models.GooglePlacesResponse

	err = json.NewDecoder(resp.Body).Decode(&googleResp)
	if err != nil {
		return nil, err
	}

	fmt.Printf("Google returned %d places\n", len(googleResp.Places))

	if len(googleResp.Places) > 0 {
		fmt.Printf("First place: %+v\n", googleResp.Places[0])
	}

	var places []models.Place

	for _, place := range googleResp.Places {
		places = append(places, models.Place{
			Name:     place.DisplayName.Text,
			Address:  place.FormattedAddress,
			Rating:   place.Rating,
			Category: "Popular",
		})
	}

	sort.Slice(
		places,
		func(i, j int) bool {
			return places[i].Rating > places[j].Rating
		},
	)

	return places, nil
}
