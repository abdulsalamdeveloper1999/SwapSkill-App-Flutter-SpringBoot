package com.example.swap_skill_servver.dto;

import java.util.UUID;

import com.example.swap_skill_servver.model.User;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor // Creater constructor with all fiels
public class AuthResponse {
    private String token; // JWT Token
    private String username; // User username
    private String email;// User email
    private UUID id; // Add this
    private String refreshToken;

    // Constructor that takes token and user object

    public AuthResponse(String token, User user, String refreshToken) {
        this.token = token;
        this.username = user.getUsername();
        this.email = user.getEmail();
        this.id = user.getId();
        this.refreshToken = refreshToken;
    }

}
