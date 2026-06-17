package models

type DiscoverResponse struct {
	Weather    WeatherAPIResponse `json:"weather"`
	Activities []Activity         `json:"activities"`
	Places     []Place            `json:"places"`
}
