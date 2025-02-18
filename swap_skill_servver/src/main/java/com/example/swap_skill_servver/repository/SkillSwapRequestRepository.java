package com.example.swap_skill_servver.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.swap_skill_servver.model.SkillSwapRequest;
import com.example.swap_skill_servver.model.SkillSwapRequest.RequestStatus;

@Repository
public interface SkillSwapRequestRepository extends JpaRepository<SkillSwapRequest, UUID> {

    List<SkillSwapRequest> findBySenderId(UUID senderId);

    List<SkillSwapRequest> findByReceiverId(UUID receiverId);

    List<SkillSwapRequest> findByStatus(RequestStatus status);

    List<SkillSwapRequest> findBySenderIdAndReceiverId(UUID senderId, UUID receiverId);

}
