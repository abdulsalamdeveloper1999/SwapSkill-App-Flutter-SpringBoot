package com.example.swap_skill_servver.controller;

import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.swap_skill_servver.dto.SkillSwapRequestDto;
import com.example.swap_skill_servver.dto.SkillSwapRequestResponseDto;
import com.example.swap_skill_servver.model.SkillSwapRequest;
import com.example.swap_skill_servver.model.User;
import com.example.swap_skill_servver.repository.UserRepository;
import com.example.swap_skill_servver.service.SwapSkillService;

@RestController
@RequestMapping("/api/skill-swap-requests")
public class SkillSwapRequestController {

    @Autowired
    private SwapSkillService skillService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("create-request")
    public ResponseEntity<SkillSwapRequestResponseDto> createRequest(
            @RequestBody SkillSwapRequestDto requestDto) {
        SkillSwapRequestResponseDto request = skillService.createRequest(requestDto);
        return ResponseEntity.ok(request);
    }

    @GetMapping("/sent/{userId}")
    public ResponseEntity<List<SkillSwapRequestResponseDto>> getSentRequests(@PathVariable UUID userId) {
        List<SkillSwapRequestResponseDto> sentRequests = skillService.getSentRequests(userId);
        return ResponseEntity.ok(sentRequests);
    }

    @GetMapping("/receiver/{userId}")
    public ResponseEntity<List<SkillSwapRequestResponseDto>> getIncomingRequests(@PathVariable UUID userId) {
        List<SkillSwapRequestResponseDto> incomingRequests = skillService.getIncomingRequests(userId);
        return ResponseEntity.ok(incomingRequests);
    }

    @PatchMapping("/{requestId}/status")
    public ResponseEntity<?> updateRequestStatus(
            @PathVariable UUID requestId,
            @RequestParam("status") String status) {
        try {
            // Trim and convert to uppercase
            status = status.trim().toUpperCase();

            // Log the processed status value for debugging
            Logger logger = LoggerFactory.getLogger(SkillSwapRequestController.class);
            logger.info("Processed status: " + status);

            // Convert the string status to the enum
            SkillSwapRequest.RequestStatus requestStatus = SkillSwapRequest.RequestStatus.valueOf(status);

            // Call service to update the request status
            SkillSwapRequestResponseDto responseDto = skillService.updateRequestStatus(requestId, requestStatus);
            return ResponseEntity.ok(responseDto);
        } catch (IllegalArgumentException e) {
            // Log the invalid status error for debugging purposes
            Logger logger = LoggerFactory.getLogger(SkillSwapRequestController.class);
            logger.error("Invalid status value received: {}", status);

            // Return a bad request response with a clear error message
            return ResponseEntity.badRequest().body(
                    "Invalid status value: " + status + ". Valid values are: PENDING, ACCEPTED, REJECTED, CANCELLED.");
        }
    }

    /**
     * Endpoint to find matches for a specific user.
     *
     * @param userId   The ID of the current user.
     * @param allUsers List of all users (can be fetched from a database or passed
     *                 as a request body).
     * @return A list of UserMatchDTO objects representing potential matches.
     */
    @PostMapping("/find")
    public ResponseEntity<Double> findMatch(
            @RequestParam("userId") UUID userId,
            @RequestBody User otherUser) {

        // Get the current user from the database
        User currentUser = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User with ID " + userId + " not found"));

        // Find the match score for the current user and the provided other user
        return ResponseEntity.ok(skillService.findMatches(currentUser, otherUser));
    }

}
