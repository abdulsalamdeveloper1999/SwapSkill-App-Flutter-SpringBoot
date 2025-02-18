package com.example.swap_skill_servver.dto;

import java.util.Set;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SkillSwapRequestDto {
    private UUID senderId;
    private UUID receiverId;
    private Set<String> senderTeachSkills;
    private Set<String> senderLearnSkills;
    private String message;
}