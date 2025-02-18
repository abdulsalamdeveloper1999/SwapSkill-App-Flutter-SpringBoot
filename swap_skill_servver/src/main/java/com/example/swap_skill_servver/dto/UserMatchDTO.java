package com.example.swap_skill_servver.dto;

import java.util.Set;
import java.util.UUID;

public class UserMatchDTO {
    private UUID userId;
    private String username;
    private Set<String> teachSkills;
    private Set<String> learnSkills;
    private double matchPercentage; // Store match percentage instead of raw score

    // Constructor
    public UserMatchDTO(UUID userId, String username, Set<String> teachSkills, Set<String> learnSkills,
            double matchPercentage) {
        this.userId = userId;
        this.username = username;
        this.teachSkills = teachSkills;
        this.learnSkills = learnSkills;
        this.matchPercentage = matchPercentage;
    }

    // Getters and Setters
    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Set<String> getTeachSkills() {
        return teachSkills;
    }

    public void setTeachSkills(Set<String> teachSkills) {
        this.teachSkills = teachSkills;
    }

    public Set<String> getLearnSkills() {
        return learnSkills;
    }

    public void setLearnSkills(Set<String> learnSkills) {
        this.learnSkills = learnSkills;
    }

    public double getMatchPercentage() {
        return matchPercentage;
    }

    public void setMatchPercentage(double matchPercentage) {
        this.matchPercentage = matchPercentage;
    }
}
