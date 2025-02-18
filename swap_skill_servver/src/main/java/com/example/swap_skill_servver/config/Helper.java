package com.example.swap_skill_servver.config;

import org.springframework.stereotype.Component;

@Component
public class Helper {

    public static boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        return email != null && email.matches(emailRegex);
    }
}