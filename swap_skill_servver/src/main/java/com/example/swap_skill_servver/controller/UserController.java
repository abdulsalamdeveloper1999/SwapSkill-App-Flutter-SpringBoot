package com.example.swap_skill_servver.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.swap_skill_servver.dto.AuthResponse;
import com.example.swap_skill_servver.dto.LoginDto;
import com.example.swap_skill_servver.dto.UserRegistrationDto;
import com.example.swap_skill_servver.exception.ApiException;
import com.example.swap_skill_servver.model.User;
import com.example.swap_skill_servver.service.UserService;

@RestController // Combines @Controller and @ResponseBody this is a RESTful web service
                // controller
@RequestMapping("/api/auth") // Defines the base URL path for all endpoints in this controller
public class UserController {

    // Enables automatic dependency injection
    // Spring automatically provides (injects) the required dependencies
    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> registerUser(@RequestBody UserRegistrationDto registrationDto) {
        AuthResponse registeredUser = userService.registerUser(registrationDto);
        return ResponseEntity.ok(registeredUser);

    }

    @GetMapping("/username/{username}")
    public ResponseEntity<User> getUserByUsername(@PathVariable String username) {
        User user = userService.findByUsername(username);
        if (user != null) {
            return ResponseEntity.ok(user);
        }
        throw new ApiException("User not found", HttpStatus.NOT_FOUND);
    }

    // controller/UserController.java
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> loginUser(@RequestBody LoginDto loginDto) {
        AuthResponse response = userService.loginUser(loginDto);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/id/{userId}")
    public ResponseEntity<User> getUserById(@PathVariable UUID userId) {
        User user = userService.getUserById(userId);
        return ResponseEntity.ok(user);
    }

    @GetMapping("/getAllUsers")
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.findAll();

        return ResponseEntity.ok(users);
    }

}
