package com.example.swap_skill_servver.dto;

import java.util.Set;

import lombok.Data;

@Data // Create getter setter
public class SkillsDTO {
    private Set<String> canTeach;
    private Set<String> wantToLearn;
}
