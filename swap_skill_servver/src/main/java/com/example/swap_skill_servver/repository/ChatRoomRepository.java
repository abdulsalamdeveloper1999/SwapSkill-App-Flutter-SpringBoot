package com.example.swap_skill_servver.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.swap_skill_servver.model.ChatRoom;
import com.example.swap_skill_servver.model.User;

public interface ChatRoomRepository extends JpaRepository<ChatRoom, UUID> {

    @Query("SELECT c FROM ChatRoom c WHERE c.user1.id = :userId OR c.user2.id = :userId")
    List<ChatRoom> findChatRoomsByUserId(@Param("userId") UUID userId);

    Optional<ChatRoom> findByUser1AndUser2(User user1, User user2);

    List<ChatRoom> findByUser1OrUser2(User user1, User user2);

}
