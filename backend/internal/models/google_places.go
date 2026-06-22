package models

type GooglePlacesResponse struct {
	Places []struct {
		DisplayName struct {
			Text string `json:"text"`
		} `json:"displayName"`

		FormattedAddress string  `json:"formattedAddress"`
		Rating           float64 `json:"rating,omitempty"`
	} `json:"places"`
}

type PlacesSearchRequest struct {
	TextQuery string `json:"textQuery"`

	LocationBias struct {
		Circle struct {
			Center struct {
				Latitude  float64 `json:"latitude"`
				Longitude float64 `json:"longitude"`
			} `json:"center"`

			Radius float64 `json:"radius"`
		} `json:"circle"`
	} `json:"locationBias"`
}
