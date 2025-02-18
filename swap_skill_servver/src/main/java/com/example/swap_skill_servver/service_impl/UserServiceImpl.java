package com.example.swap_skill_servver.service_impl;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.swap_skill_servver.config.Helper;
import com.example.swap_skill_servver.dto.AuthResponse;
import com.example.swap_skill_servver.dto.LoginDto;
import com.example.swap_skill_servver.dto.UserRegistrationDto;
import com.example.swap_skill_servver.exception.ApiException;
import com.example.swap_skill_servver.model.User;
import com.example.swap_skill_servver.repository.UserRepository;
import com.example.swap_skill_servver.security.JwtUtil;
import com.example.swap_skill_servver.service.UserService;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    public AuthResponse registerUser(UserRegistrationDto registrationDto) {
        if (existsByUsername(registrationDto.getUsername())) {
            throw new ApiException("Username already exists", HttpStatus.BAD_REQUEST);
        }
        // Correct version
        if (existsByEmail(registrationDto.getEmail())) {
            throw new ApiException("Email already exists", HttpStatus.BAD_REQUEST);
        }

        if (registrationDto.getPassword() == null || registrationDto.getPassword().length() < 6) {
            throw new ApiException("Password must be at least 6 characters", HttpStatus.BAD_REQUEST);
        }

        if (!Helper.isValidEmail(registrationDto.getEmail())) {
            throw new ApiException("Invalid email format", HttpStatus.BAD_REQUEST);
        }
        // Convert DTO to User entity
        User user = new User();

        user.setUsername(registrationDto.getUsername());
        user.setEmail(registrationDto.getEmail());
        user.setPassword(passwordEncoder.encode(registrationDto.getPassword())); // Encoded password for security

        // Save user
        String accessToken = jwtUtil.generateToken(user.getUsername());
        String refreshToken = jwtUtil.generateRefreshToken(user.getUsername());
        userRepository.save(user);
        return new AuthResponse(accessToken, user, refreshToken);

    }

    @Override
    public User findByUsername(String username) {
        Optional<User> userOptional = userRepository.findByUsername(username);

        if (userOptional.isPresent()) {
            return userOptional.get();
        } else {
            throw new ApiException("User not found", HttpStatus.NOT_FOUND);
        }
    }

    @Override
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    @Override
    public AuthResponse loginUser(LoginDto loginDto) {
        // Find user by email
        Optional<User> optionalUser = userRepository.findByEmail(loginDto.getEmail());

        User user = optionalUser.orElseThrow(() -> new ApiException("Invalid credentials", HttpStatus.BAD_REQUEST));

        if (loginDto.getEmail() == null || loginDto.getPassword() == null) {
            throw new ApiException("Email and password required", HttpStatus.BAD_REQUEST);
        }

        // Verify password
        if (!passwordEncoder.matches(loginDto.getPassword(), user.getPassword())) {
            throw new ApiException("Invalid credentials", HttpStatus.UNAUTHORIZED);
        }

        String accessToken = jwtUtil.generateToken(user.getUsername());
        String refreshToken = jwtUtil.generateRefreshToken(user.getUsername());

        return new AuthResponse(accessToken, user, refreshToken);
    }

    @Override
    public User getUserById(UUID id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new ApiException("User not found", HttpStatus.NOT_FOUND));
    }

    @Override
    public List<User> findAll() {
        List<User> users = userRepository.findAll();

        if (users.isEmpty()) {
            throw new ApiException("Users not found", HttpStatus.NOT_FOUND);
        }
        return users;
    }
}
