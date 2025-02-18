package com.example.swap_skill_servver.security;

import java.security.Key;
import java.util.Date;
import java.util.function.Function;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import com.example.swap_skill_servver.exception.ApiException;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

@Component // Marks this class as a Spring-managed bean
public class JwtUtil {
    // Injects the JWT secret key from application properties
    @Value("${jwt.secret}")
    private String secret;

    // Generates a JWT token for a given username
    public String generateToken(String username) {
        return Jwts.builder()
                .setSubject(username) // Set username as the token subject
                .setIssuedAt(new Date()) // Set token creation time
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 10)) // Set expiration (10 hours)
                .signWith(getSignKey(), SignatureAlgorithm.HS256) // Sign the token with a secret key
                .compact(); // Compact to a URL-safe string
    }

    public String generateRefreshToken(String username) {
        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24 * 7)) // 7 days
                .signWith(getSignKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    // Extracts username from the token
    public String extractUsername(String token) {
        // Uses method reference to get subject claim
        return extractClaim(token, Claims::getSubject);
    }

    // Generic method to extract any claim from the token
    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        // Apply the provided claims resolver function to extracted claims
        return claimsResolver.apply(extractAllClaims(token));
    }

    // Internal method to extract all claims from the token
    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSignKey()) // Set the signing key for verification
                .build() // Build the parser
                .parseClaimsJws(token) // Parse and validate the token
                .getBody(); // Get the claims body
    }

    // Convert the secret key to a cryptographic key
    private Key getSignKey() {
        // Decode the base64 encoded secret and create an HMAC SHA key
        return Keys.hmacShaKeyFor(Decoders.BASE64.decode(secret));
    }

    // Validate the token
    public boolean validateToken(String token) {
        try {
            // Attempt to parse and validate the token
            Jwts.parserBuilder()
                    .setSigningKey(getSignKey())
                    .build()
                    .parseClaimsJws(token);
            return true; // Token is valid
        } catch (ExpiredJwtException e) {
            throw new ApiException("Token has expired", HttpStatus.UNAUTHORIZED);
        } catch (Exception e) {
            throw new ApiException("Invalid token", HttpStatus.UNAUTHORIZED);
        }
    }

    public boolean validateRefreshToken(String token) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(getSignKey())
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}