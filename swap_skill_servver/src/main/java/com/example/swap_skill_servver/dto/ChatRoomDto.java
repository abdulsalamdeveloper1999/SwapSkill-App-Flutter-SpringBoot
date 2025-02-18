package com.example.swap_skill_servver.dto;

import java.util.List;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatRoomDto {
    private UUID id;
    private UUID senderId;
    private String senderUsername;

    private UUID receiverId;
    private String reciverName;
    private List<MessageDto> messages;
}