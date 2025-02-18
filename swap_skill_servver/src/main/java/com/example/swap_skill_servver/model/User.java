package com.example.swap_skill_servver.model;

import java.util.Set;
import java.util.UUID;

import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
// The @Entity annotation is a crucial part of Java Persistence API (JPA) that
// marks a Java class as a database table.
@Table(name = "users") // Creates a table named "users" in database
// Getter Setter
@Data
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(unique = true) // Each username must be unique
    private String username;

    @Column(unique = true) // Each username must be unique
    private String email;

    private String password;

    @ElementCollection(fetch = FetchType.LAZY)
    @CollectionTable(name = "user_can_teach", joinColumns = @JoinColumn(name = "user_id"))
    private Set<String> canTeach;

    @ElementCollection(fetch = FetchType.LAZY)
    @CollectionTable(name = "user_want_to_learn", joinColumns = @JoinColumn(name = "user_id"))
    private Set<String> wantToLearn;
}