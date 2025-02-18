package com.example.swap_skill_servver.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.swap_skill_servver.dto.ChatRoomDto;
import com.example.swap_skill_servver.dto.MessageDto;
import com.example.swap_skill_servver.model.ChatRoom;
import com.example.swap_skill_servver.model.Message;
import com.example.swap_skill_servver.model.User;
import com.example.swap_skill_servver.repository.UserRepository;
import com.example.swap_skill_servver.service.ChatService;

@RestController
@RequestMapping("/api/chat")
public class ChatController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/create")
    public ResponseEntity<ChatRoom> createChatRoom(@RequestParam UUID user1Id, @RequestParam UUID user2Id) {

        User user1 = userRepository.findById(user1Id)
                .orElseThrow(() -> new IllegalArgumentException("User 1 not found"));
        User user2 = userRepository.findById(user2Id)
                .orElseThrow(() -> new IllegalArgumentException("User 2 not found"));

        ChatRoom chatRoom = chatService.createChatRoom(user1, user2);
        return ResponseEntity.ok(chatRoom);

    }

    @GetMapping("/{chatRoomId}/messages")
    public ResponseEntity<List<MessageDto>> getMessages(@PathVariable UUID chatRoomId) {
        return ResponseEntity.ok(chatService.getMessagesForChatRoom(chatRoomId));
    }

    @PostMapping("/{chatRoomId}/send")
    public ResponseEntity<Message> sendMessage(@PathVariable UUID chatRoomId, @RequestParam UUID senderId,
            @RequestBody String content) {

        return ResponseEntity.ok(chatService.sendMessage(chatRoomId, senderId, content));
    }

    @GetMapping("getRooms")
    public ResponseEntity<List<ChatRoom>> getChatRooms() {
        return ResponseEntity.ok(chatService.findAllChatRooms());
    }

    @GetMapping("/{userId}")
    public ResponseEntity<List<ChatRoomDto>> getUserChats(@PathVariable UUID userId) {
        List<ChatRoomDto> chatRooms = chatService.getChatRoomsForUser(userId);
        return ResponseEntity.ok(chatRooms);
    }

}
