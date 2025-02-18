package com.example.swap_skill_servver.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.swap_skill_servver.model.User;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {
    // @SuppressWarnings("null")
    // @Override
    // Optional<User> findById(UUID id);

    // Custom query methods
    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    Optional<User> findByUsername(String username); // Returns Optional<User>

    Optional<User> findByEmail(String email); // Returns Optional<User>
}
