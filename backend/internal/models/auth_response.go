package models

type LoginResponse struct {
	Token     string       `json:"token"`
	ExpiresIn int64        `json:"expires_in"`
	User      UserResponse `json:"user"`
}

type UserResponse struct {
	ID       int64  `json:"id"`
	Username string `json:"username"`
	Email    string `json:"email"`
}
