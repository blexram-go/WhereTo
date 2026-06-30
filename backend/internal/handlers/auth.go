package handlers

import (
	"net/http"

	"github.com/blexram-go/wheretoapp-backend/internal/models"
	"github.com/blexram-go/wheretoapp-backend/internal/services"
	"github.com/gin-gonic/gin"
)

type AuthHandler struct {
	authService *services.AuthService
}

func NewAuthHandler(authService *services.AuthService) *AuthHandler {
	return &AuthHandler{
		authService: authService,
	}
}

func (h *AuthHandler) Register(c *gin.Context) {
	var req models.RegisterRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.ErrorResponse{
			Error: err.Error(),
		})
		return
	}

	err := h.authService.Register(req)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.ErrorResponse{
			Error: err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "user registered successfully",
	})
}

func (h *AuthHandler) Login(c *gin.Context) {

	var req models.LoginRequest

	if err := c.ShouldBindJSON(&req); err != nil {

		c.JSON(http.StatusBadRequest, models.ErrorResponse{
			Error: err.Error(),
		})

		return
	}

	reponse, err := h.authService.Login(req)
	if err != nil {

		c.JSON(http.StatusUnauthorized, models.ErrorResponse{
			Error: err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, reponse)
}
