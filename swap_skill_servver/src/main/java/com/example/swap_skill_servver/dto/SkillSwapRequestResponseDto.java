package com.example.swap_skill_servver.dto;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.UUID;

import com.example.swap_skill_servver.model.User;

import lombok.Data;

@Data
public class SkillSwapRequestResponseDto {
    private UUID id;
    private User sender;
    private User receiver;
    private Set<String> senderTeachSkills;
    private Set<String> senderLearnSkills;
    private String message;
    private String status;
    private LocalDateTime createAt;
}
