package com.example.swap_skill_servver.exception;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data // @Data (from Lombok): auto genereate getter setter
@AllArgsConstructor
// @AllArgsConstructor (from Lombok):
// Automatically generates a constructor with all class fields
// as parameters
public class ErrorResponse {
    private int status; // Error code (like 400)
    private String message; // Error message
    private LocalDateTime timestamp; // When error happened
}