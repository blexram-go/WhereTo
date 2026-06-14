package models

type RecommendationResponse struct {
	Weather    string     `json:"weather"`
	Activities []Activity `json:"activities"`
}
