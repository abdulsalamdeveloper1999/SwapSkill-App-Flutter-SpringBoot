package com.example.swap_skill_servver.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.swap_skill_servver.model.ChatRoom;
import com.example.swap_skill_servver.model.Message;

public interface MessageRepository extends JpaRepository<Message, UUID> {

    // Fetch all messages for a chat room, ordered by timestamp
    List<Message> findByChatRoomOrderByTimestampAsc(ChatRoom chatRoom);

    // Fetch only the latest 10 messages for performance
    List<Message> findTop10ByChatRoomOrderByTimestampDesc(ChatRoom chatRoom);

    List<Message> findByChatRoomId(UUID chatRoomId);
}