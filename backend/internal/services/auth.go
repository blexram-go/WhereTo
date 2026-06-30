package services

import (
	"errors"
	"net/mail"

	"github.com/blexram-go/wheretoapp-backend/internal/models"
	"github.com/blexram-go/wheretoapp-backend/internal/repository"
	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	userRepo *repository.UserRepository
}

func NewAuthService(
	userRepo *repository.UserRepository,
) *AuthService {

	return &AuthService{
		userRepo: userRepo,
	}
}

func (s *AuthService) Register(req models.RegisterRequest) error {
	if req.Username == "" {
		return errors.New("username is required")
	}

	if req.Password == "" {
		return errors.New("password is required")
	}

	if _, err := mail.ParseAddress(req.Email); err != nil {
		return errors.New("invalid email address")
	}

	hash, err := bcrypt.GenerateFromPassword(
		[]byte(req.Password),
		bcrypt.DefaultCost,
	)
	if err != nil {
		return err
	}

	user := &models.User{
		Username:     req.Username,
		Email:        req.Email,
		PasswordHash: string(hash),
	}

	return s.userRepo.CreateUser(user)
}

func (s *AuthService) Login(req models.LoginRequest) (string, error) {
	if req.Email == "" {
		return "", errors.New("email is required")
	}

	if req.Password == "" {
		return "", errors.New("password is required")
	}

	user, err := s.userRepo.FindByEmail(req.Email)
	if err != nil {
		return "", errors.New("invalid email or password")
	}

	err = bcrypt.CompareHashAndPassword(
		[]byte(user.PasswordHash),
		[]byte(req.Password),
	)
	if err != nil {
		return "", errors.New("invalid email or password")
	}

	// Will add JWT generation here
	return "login successful", nil
}
