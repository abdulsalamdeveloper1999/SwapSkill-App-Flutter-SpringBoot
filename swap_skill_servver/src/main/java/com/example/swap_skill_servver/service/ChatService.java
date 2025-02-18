package com.example.swap_skill_servver.service;

import java.util.List;
import java.util.UUID;

import com.example.swap_skill_servver.dto.ChatRoomDto;
import com.example.swap_skill_servver.dto.MessageDto;
import com.example.swap_skill_servver.model.ChatRoom;
import com.example.swap_skill_servver.model.Message;
import com.example.swap_skill_servver.model.User;

public interface ChatService {

    ChatRoom createChatRoom(User user1, User user2);

    public List<ChatRoom> findAllChatRooms();

    List<MessageDto> getMessagesForChatRoom(UUID chatRoomId);

    Message sendMessage(UUID chatRoomId, UUID senderId, String content);

    public List<ChatRoomDto> getChatRoomsForUser(UUID userId);

}
