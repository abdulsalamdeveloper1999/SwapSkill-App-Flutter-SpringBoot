package com.example.swap_skill_servver.controller;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.swap_skill_servver.dto.SkillsDTO;
import com.example.swap_skill_servver.model.User;
import com.example.swap_skill_servver.service.UserSkillService;

@RestController
@RequestMapping("/api/users")
public class SkillsController {

    @Autowired
    private UserSkillService userSkillService;

    @PutMapping("/{userId}/skills")
    public ResponseEntity<User> updateSkills(@PathVariable UUID userId, @RequestBody SkillsDTO skillsDTO) {
        User user = userSkillService.updateSkills(userId, skillsDTO);

        return ResponseEntity.ok(user);
    }

    @PostMapping("/{userId}/skills/teach")
    public ResponseEntity<User> addTeachingSkills(@PathVariable UUID userId, @RequestBody String skill) {
        // Clean the string - remove any quotes at the start and end
        String cleanSkill = skill.replaceAll("^\"|\"$", "");
        User user = userSkillService.addTeachingSkills(userId, cleanSkill);

        return ResponseEntity.ok(user);
    }

    @PostMapping("/{userId}/skills/learn")
    public ResponseEntity<User> addLearningSkill(@PathVariable UUID userId, @RequestBody String skill) {
        String cleanSkill = skill.replaceAll("^\"|\"$", "");
        User user = userSkillService.addLearningSkill(userId, cleanSkill);
        return ResponseEntity.ok(user);
    }

    @DeleteMapping("/{userId}/skill/teach/{skill}")
    public void deleteSkill(@PathVariable UUID userId, @PathVariable String skill) {
        userSkillService.removeTeachingSkill(userId, skill);

    }

    @GetMapping("/{userId}/skills")
    public ResponseEntity<User> getSkills(@PathVariable UUID userId) {

        User user = userSkillService.getSkills(userId);
        return ResponseEntity.ok(user);
    }

    @DeleteMapping("/{userId}/skill/learn/{skill}")
    public ResponseEntity<String> deleteLearnSkill(@PathVariable UUID userId, @PathVariable String skill) {
        String res = userSkillService.removeLearningSkill(userId, skill);

        return ResponseEntity.ok(res);
    }

}
