package com.example.swap_skill_servver.service_impl;

import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import com.example.swap_skill_servver.dto.SkillsDTO;
import com.example.swap_skill_servver.exception.ApiException;
import com.example.swap_skill_servver.model.User;
import com.example.swap_skill_servver.repository.UserRepository;
import com.example.swap_skill_servver.service.UserSkillService;

import io.jsonwebtoken.ExpiredJwtException;
import jakarta.transaction.Transactional;

@Transactional
@Service
public class UserSkillServiceImpl implements UserSkillService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public User updateSkills(UUID userId, SkillsDTO skillsDTO) {

        Optional<User> userOptional = userRepository.findById(userId);

        if (!userOptional.isPresent()) {
            throw new ApiException("User not found with id: " + userId, HttpStatus.BAD_REQUEST);
        }

        User user = userOptional.get();

        if (skillsDTO.getCanTeach() == null || skillsDTO.getWantToLearn() == null) {
            throw new ApiException("Skill sets cannot be null", HttpStatus.BAD_REQUEST);
        }

        user.setCanTeach(skillsDTO.getCanTeach());
        user.setWantToLearn(skillsDTO.getWantToLearn());

        return userRepository.save(user);

    }

    @Override
    public User addTeachingSkills(UUID userId, String skill) {
        try {

            Optional<User> userOptional = userRepository.findById(userId);

            if (!userOptional.isPresent()) {
                throw new ApiException(skill, HttpStatus.BAD_REQUEST);
            }

            User user = userOptional.get();

            if (skill == null || skill.trim().isEmpty()) {
                throw new ApiException("Skill cannot be empty", HttpStatus.BAD_REQUEST);
            }
            if (user.getCanTeach().contains(skill)) {
                throw new ApiException("Skill already exists", HttpStatus.CONFLICT);
            }

            user.getCanTeach().add(skill);

            return userRepository.save(user);

        } catch (ExpiredJwtException e) {
            throw new ApiException("Token has expired", HttpStatus.UNAUTHORIZED);
        }
    }

    @Override
    public User addLearningSkill(UUID userId, String skill) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (!userOptional.isPresent()) {
            throw new ApiException("User not found", HttpStatus.BAD_GATEWAY);
        }

        User user = userOptional.get();

        user.getWantToLearn().add(skill);

        return userRepository.save(user);

    }

    @Override
    public void removeTeachingSkill(UUID userId, String skill) {
        Optional<User> optionalUser = userRepository.findById(userId);
        if (!optionalUser.isPresent()) {
            // Use NOT_FOUND instead of BAD_GATEWAY for user not found
            throw new ApiException("User not found", HttpStatus.NOT_FOUND);
        }

        User user = optionalUser.get();
        // Validate skill parameter
        if (skill == null || skill.trim().isEmpty()) {
            throw new ApiException("Skill cannot be empty", HttpStatus.BAD_REQUEST);
        }

        if (!user.getCanTeach().contains(skill)) {
            throw new ApiException("Skill not found", HttpStatus.NOT_FOUND);
        }

        user.getCanTeach().remove(skill);

        userRepository.save(user);

    }

    @Override
    public String removeLearningSkill(UUID userId, @RequestBody String skill) {
        Optional<User> userOptional = userRepository.findById(userId);

        if (!userOptional.isPresent()) {
            throw new ApiException("Skill does not exist", HttpStatus.BAD_REQUEST);
        }

        User user = userOptional.get();
        if (!user.getWantToLearn().contains(skill)) {
            throw new ApiException("Skill doesnot exist", HttpStatus.BAD_GATEWAY);
        }

        user.getWantToLearn().remove(skill);

        userRepository.save(user);

        return "Skill has been removed";

    }

    @Override
    public User getSkills(UUID Id) {
        User user = userRepository.findById(Id)
                .orElseThrow(() -> new ApiException("Issue while deleting", HttpStatus.BAD_REQUEST));

        return userRepository.save(user);
    }

}
