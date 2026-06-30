package repository

import (
	"database/sql"
	"errors"

	"github.com/blexram-go/wheretoapp-backend/internal/models"
)

type UserRepository struct {
	db *sql.DB
}

func NewUserRepository(db *sql.DB) *UserRepository {
	return &UserRepository{
		db: db,
	}
}

func (r *UserRepository) CreateUser(user *models.User) error {
	err := r.db.QueryRow(
		`
	INSERT INTO users
	    (username, email, password_hash)
	VALUES
	    ($1, $2, $3)
	RETURNING id, created_at
	`,
		user.Username,
		user.Email,
		user.PasswordHash,
	).Scan(
		&user.ID,
		&user.CreatedAt,
	)

	return err
}

func (r *UserRepository) FindByEmail(email string) (*models.User, error) {
	var user models.User

	err := r.db.QueryRow(
		`
		SELECT
			id,
			username,
			email,
			password_hash,
			created_at
		FROM users
		WHERE email = $1
		`,
		email,
	).Scan(
		&user.ID,
		&user.Username,
		&user.Email,
		&user.PasswordHash,
		&user.CreatedAt,
	)

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	return &user, nil
}
