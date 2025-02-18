package com.example.swap_skill_servver.service_impl;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import com.example.swap_skill_servver.dto.SkillSwapRequestDto;
import com.example.swap_skill_servver.dto.SkillSwapRequestResponseDto;
import com.example.swap_skill_servver.dto.UserDto;
import com.example.swap_skill_servver.exception.ApiException;
import com.example.swap_skill_servver.model.SkillSwapRequest;
import com.example.swap_skill_servver.model.SkillSwapRequest.RequestStatus;
import com.example.swap_skill_servver.model.User;
import com.example.swap_skill_servver.repository.SkillSwapRequestRepository;
import com.example.swap_skill_servver.repository.UserRepository;
import com.example.swap_skill_servver.service.ChatService;
import com.example.swap_skill_servver.service.SwapSkillService;

import jakarta.transaction.Transactional;

@Service
public class SwapSkillServiceImpl implements SwapSkillService {
    private static final Logger logger = LoggerFactory.getLogger(SwapSkillServiceImpl.class);
    @Autowired
    private SkillSwapRequestRepository skillSwapRequestRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ChatService chatService;

    @Transactional
    @Override
    public SkillSwapRequestResponseDto createRequest(SkillSwapRequestDto requestDto) {
        User sender = userRepository.findById(requestDto.getSenderId())
                .orElseThrow(() -> new ApiException("Sender not found", HttpStatus.NOT_FOUND));

        User receiver = userRepository.findById(requestDto.getReceiverId())
                .orElseThrow(() -> new ApiException("Receiver not found", HttpStatus.NOT_FOUND));

        // Create request entity
        // Create request entity
        SkillSwapRequest request = new SkillSwapRequest();
        request.setSender(sender);
        request.setReceiver(receiver);
        request.setSenderTeachSkills(requestDto.getSenderTeachSkills());
        request.setSenderLearnSkills(requestDto.getSenderLearnSkills());
        request.setMessage(requestDto.getMessage());
        request.setStatus(SkillSwapRequest.RequestStatus.PENDING);
        request.setCreatedAt(LocalDateTime.now());

        return convertToResponseDto(skillSwapRequestRepository.save(request));

    }

    @Override
    public List<SkillSwapRequestResponseDto> getIncomingRequests(UUID userId) {

        return skillSwapRequestRepository.findByReceiverId(userId).stream()
                .map(request -> convertToResponseDto(request))
                .collect(Collectors.toList());

    }

    @Override
    public List<SkillSwapRequestResponseDto> getSentRequests(UUID userId) {

        return skillSwapRequestRepository.findBySenderId(userId).stream().map(request -> convertToResponseDto(request))
                .collect(Collectors.toList());
    }

    @Override
    public SkillSwapRequestResponseDto updateRequestStatus(UUID requestId, RequestStatus status) {
        try {
            SkillSwapRequest swapRequest = skillSwapRequestRepository.findById(requestId)
                    .orElseThrow(() -> new ApiException("Request could not be updated", HttpStatus.BAD_REQUEST));

            swapRequest.setStatus(status);
            swapRequest.setUpdatedAt(LocalDateTime.now());

            // Create chat room when accepted
            if (swapRequest.getStatus().equals(RequestStatus.ACCEPTED)) {
                chatService.createChatRoom(swapRequest.getSender(), swapRequest.getReceiver());
            }

            return convertToResponseDto(skillSwapRequestRepository.save(swapRequest));
        } catch (Exception e) {

            logger.info("Received status: " + status);
            logger.error("Received status: " + status);
            throw new ApiException("Failed to update request status: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public SkillSwapRequestResponseDto convertToResponseDto(SkillSwapRequest request) {

        SkillSwapRequestResponseDto responseDto = new SkillSwapRequestResponseDto();

        responseDto.setId(request.getId());
        responseDto.setSender(request.getSender());
        responseDto.setReceiver(request.getReceiver());
        responseDto.setSenderLearnSkills(request.getSenderLearnSkills());
        responseDto.setSenderTeachSkills(request.getSenderTeachSkills());
        responseDto.setStatus(request.getStatus().name());
        responseDto.setMessage(request.getMessage());
        responseDto.setCreateAt(request.getCreatedAt());

        return responseDto;

    }

    @Override
    public UserDto convertUserToDto(User user) {

        UserDto dto = new UserDto();

        dto.setId(user.getId());
        dto.setUserName(user.getUsername());
        return dto;

    }

    // Total score is the sum of the sizes of the two sets

    @Override
    public double calculateMatchPercentage(User currentUser, User otherUser) {
        Set<String> currentUserSkills = new HashSet<>();
        currentUserSkills.addAll(currentUser.getCanTeach());
        currentUserSkills.addAll(currentUser.getWantToLearn());

        Set<String> otherUserSkills = new HashSet<>();
        otherUserSkills.addAll(otherUser.getCanTeach());
        otherUserSkills.addAll(otherUser.getWantToLearn());

        Set<String> matchingSkills = new HashSet<>(currentUserSkills);
        matchingSkills.retainAll(otherUserSkills);

        // Intersection over union
        double unionSize = currentUserSkills.size() + otherUserSkills.size() - matchingSkills.size();
        return (double) matchingSkills.size() / unionSize * 100;
    }

    @Override
    public double findMatches(User currentUser, User otherUser) {
        // Calculate match score
        double score = calculateMatchPercentage(currentUser, otherUser);

        // Return only the match score
        return score;
    }
}
