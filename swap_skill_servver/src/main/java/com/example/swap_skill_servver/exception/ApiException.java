package com.example.swap_skill_servver.exception;

import org.springframework.http.HttpStatus;

import lombok.Getter;

@Getter
public class ApiException extends RuntimeException {
    private final HttpStatus status; // Like HTTP 400, 404, etc.

    public ApiException(String message, HttpStatus status) {
        super(message);
        this.status = status;
    }

}
