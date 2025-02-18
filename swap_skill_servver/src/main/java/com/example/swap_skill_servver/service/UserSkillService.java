package com.example.swap_skill_servver.service;

import java.util.UUID;

import com.example.swap_skill_servver.dto.SkillsDTO;
import com.example.swap_skill_servver.model.User;

public interface UserSkillService {
    User updateSkills(UUID userId, SkillsDTO skillsDTO);

    User addTeachingSkills(UUID userId, String skill);

    User addLearningSkill(UUID userId, String skill);

    void removeTeachingSkill(UUID userId, String skill);

    String removeLearningSkill(UUID userId, String skill);

    User getSkills(UUID Id);

}
