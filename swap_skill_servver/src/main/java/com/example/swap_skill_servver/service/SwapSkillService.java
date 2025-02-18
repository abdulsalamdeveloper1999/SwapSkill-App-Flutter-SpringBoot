package com.example.swap_skill_servver.service;

import java.util.List;
import java.util.UUID;

import com.example.swap_skill_servver.dto.SkillSwapRequestDto;
import com.example.swap_skill_servver.dto.SkillSwapRequestResponseDto;
import com.example.swap_skill_servver.dto.UserDto;
import com.example.swap_skill_servver.model.SkillSwapRequest;
import com.example.swap_skill_servver.model.User;

public interface SwapSkillService {

    SkillSwapRequestResponseDto createRequest(SkillSwapRequestDto requestDto);

    List<SkillSwapRequestResponseDto> getIncomingRequests(UUID userId);

    List<SkillSwapRequestResponseDto> getSentRequests(UUID userId);

    SkillSwapRequestResponseDto updateRequestStatus(UUID requestId, SkillSwapRequest.RequestStatus status);

    SkillSwapRequestResponseDto convertToResponseDto(SkillSwapRequest request);

    UserDto convertUserToDto(User user);

    double calculateMatchPercentage(User currentUser, User otherUser);

    double findMatches(User currentUser, User otherUser);
}