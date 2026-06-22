package services

import (
	"testing"

	"github.com/blexram-go/wheretoapp-backend/internal/models"
	"github.com/stretchr/testify/assert"
)

func TestGetRecommendations(t *testing.T) {
	tests := []struct {
		name                  string
		input                 models.WeatherAPIResponse
		expectedFirstActivity string
		wantErr               bool
	}{
		{
			name: "sunny weather returns hiking",
			input: models.WeatherAPIResponse{
				Temperature: 75,
				Condition:   "Sunny",
			},
			expectedFirstActivity: "Hiking",
		},
		{
			name: "rain returns museum",
			input: models.WeatherAPIResponse{
				Temperature: 60,
				Condition:   "Light rain",
			},
			expectedFirstActivity: "Museum",
		},
		{
			name: "extreme heat returns indoor activities",
			input: models.WeatherAPIResponse{
				Temperature: 102,
				Condition:   "Sunny",
			},
			expectedFirstActivity: "Movie Theater",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := GetRecommendations(tt.input)

			if tt.wantErr {
				assert.Error(t, err)
				return
			}

			assert.NoError(t, err)
			assert.NotEmpty(t, got)
			assert.Equal(t, tt.expectedFirstActivity, got[0].Name)
		})
	}
}
