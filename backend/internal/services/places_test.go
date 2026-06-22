package services

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestActivitySearchMap(t *testing.T) {
	tests := []struct {
		name     string
		activity string
		expected string
	}{
		{
			name:     "hiking maps to hiking trail",
			activity: "Hiking",
			expected: "hiking trail",
		},
		{
			name:     "park visit maps to park",
			activity: "Park Visit",
			expected: "park",
		},
		{
			name:     "movie theater maps correctly",
			activity: "Movie Theater",
			expected: "movie theater",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := activitySearchMap[tt.activity]

			assert.Equal(t, tt.expected, got)
		})
	}
}
