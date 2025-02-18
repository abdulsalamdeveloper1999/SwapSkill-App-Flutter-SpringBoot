package com.example.swap_skill_servver.dto;

import lombok.Data;

// This is like a registration form
@Data
public class UserRegistrationDto {
    private String username;
    private String email;
    private String password;
}
