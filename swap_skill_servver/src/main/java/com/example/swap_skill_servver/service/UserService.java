package com.example.swap_skill_servver.service;

import java.util.List;
import java.util.UUID;

import com.example.swap_skill_servver.dto.AuthResponse;
import com.example.swap_skill_servver.dto.LoginDto;
import com.example.swap_skill_servver.dto.UserRegistrationDto;
import com.example.swap_skill_servver.model.User;

public interface UserService {
    AuthResponse registerUser(UserRegistrationDto registrationDto);

    List<User> findAll();

    AuthResponse loginUser(LoginDto loginDto);

    User findByUsername(String username);

    public User getUserById(UUID id);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

}
