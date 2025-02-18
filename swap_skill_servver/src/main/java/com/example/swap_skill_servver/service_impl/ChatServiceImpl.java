package com.example.swap_skill_servver.service_impl;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.swap_skill_servver.dto.ChatRoomDto;
import com.example.swap_skill_servver.dto.MessageDto;
import com.example.swap_skill_servver.exception.ApiException;
import com.example.swap_skill_servver.model.ChatRoom;
import com.example.swap_skill_servver.model.Message;
import com.example.swap_skill_servver.model.User;
import com.example.swap_skill_servver.repository.ChatRoomRepository;
import com.example.swap_skill_servver.repository.MessageRepository;
import com.example.swap_skill_servver.repository.UserRepository;
import com.example.swap_skill_servver.service.ChatService;

@Service
public class ChatServiceImpl implements ChatService {

    @Autowired
    private ChatRoomRepository chatRoomRepository;

    @Autowired
    private MessageRepository messageRepository;

    private final UserRepository userRepository;

    public ChatServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public ChatRoom createChatRoom(User user1, User user2) {
        Optional<ChatRoom> existingRoom = chatRoomRepository.findByUser1AndUser2(user1, user2);

        if (existingRoom.isPresent()) {
            return existingRoom.get();
        }

        ChatRoom chatRoom = new ChatRoom();

        chatRoom.setUser1(user1);
        chatRoom.setUser2(user2);
        chatRoom.setActive(true);

        return chatRoomRepository.save(chatRoom);

    }

    @Override
    public Message sendMessage(UUID chatRoomId, UUID senderId, String content) {
        ChatRoom chatRoom = chatRoomRepository.findById(chatRoomId)
                .orElseThrow(() -> new IllegalArgumentException("Chat Room not found"));

        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        Message message = new Message();
        message.setChatRoom(chatRoom);
        message.setSender(sender);
        message.setContent(content);

        return messageRepository.save(message);

    }

    @Override
    public List<ChatRoom> findAllChatRooms() {

        List<ChatRoom> chatRooms = chatRoomRepository.findAll();

        if (chatRooms.isEmpty()) {
            throw new ApiException("Chat room are empty", HttpStatus.NOT_FOUND);
        }

        return chatRooms;

    }

    @Override
    @Transactional(readOnly = true)
    public List<ChatRoomDto> getChatRoomsForUser(UUID userId) {
        try {
            // Fetch user (optional check if user exists)
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            // Fetch chat rooms where the user is involved
            List<ChatRoom> chatRooms = chatRoomRepository.findByUser1OrUser2(user, user);

            // Convert to DTOs
            return chatRooms.stream().map((chat) -> convertToChatRoomDTO(chat)).collect(Collectors.toList());
        } catch (Exception e) {
            throw new ApiException("Error occured $e", HttpStatus.BAD_REQUEST);
        }
    }

    private ChatRoomDto convertToChatRoomDTO(ChatRoom chatRoom) {
        return new ChatRoomDto(
                chatRoom.getId(),
                chatRoom.getUser1().getId(),
                chatRoom.getUser1().getUsername(),
                chatRoom.getUser2().getId(),
                chatRoom.getUser2().getUsername(),
                chatRoom.getMessages().stream()
                        .map(this::convertToMessageDTO)
                        .collect(Collectors.toList()));
    }

    @Override
    public List<MessageDto> getMessagesForChatRoom(UUID chatRoomId) {
        try {
            ChatRoom chatRoom = chatRoomRepository.findById(chatRoomId)
                    .orElseThrow(() -> new RuntimeException("Chat room not found"));

            List<Message> messages = messageRepository.findByChatRoomId(chatRoom.getId());

            return messages.stream()
                    .map(this::convertToMessageDTO)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            throw new ApiException("Error occured " + e, HttpStatus.BAD_REQUEST);
        }

    }

    private MessageDto convertToMessageDTO(Message message) {
        return new MessageDto(
                message.getId(),
                message.getSender().getId(),
                message.getContent(),
                message.getTimestamp());
    }
}
