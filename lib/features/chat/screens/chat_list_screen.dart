import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/provider/user_provider.dart';
import '../models/chat_model.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch the current user ID
      String userId = context.read<UserProvider>().currentUser.id!;
      // Fetch the chats for the current user
      context.read<ChatProvider>().getUserChats(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          // If chats are still loading or not available
          if (chatProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Display chat rooms
          return ListView.builder(
            itemCount: chatProvider.chats.length,
            itemBuilder: (context, index) {
              final chatRoom = chatProvider.chats[index];

              return ChatListTile(
                onTap: () {
                  // Navigate to ChatScreen for the selected chat room
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        chatRoom: chatRoom,
                      ),
                    ),
                  );
                },
                chatRoom: chatRoom, // Pass the chat room to the tile
              );
            },
          );
        },
      ),
    );
  }
}

class ChatListTile extends StatelessWidget {
  final VoidCallback onTap;
  final Chat chatRoom;

  const ChatListTile({super.key, required this.onTap, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    // Assuming that we want to show the other participant's username
    String otherUserName =
        chatRoom.senderId != context.read<UserProvider>().currentUser.id
            ? chatRoom.senderUsername
            : chatRoom.reciverName;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(
          'https://api.dicebear.com/7.x/avataaars/png?seed=$otherUserName', // Placeholder image URL
        ),
      ),
      title: Text(otherUserName), // Show the other user's name
      subtitle: Text(
        chatRoom.messages.isNotEmpty
            ? chatRoom.messages.last.content
            : 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chatRoom.messages.isNotEmpty
                ? chatRoom.messages.last.timestamp.toString()
                : '',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          // if (chatRoom
          //     .messages.isNotEmpty) // Only show new message count if available
          //   Expanded(
          //     child: Container(
          //       padding: const EdgeInsets.all(6),
          //       decoration: const BoxDecoration(
          //         color: Colors.blue,
          //         shape: BoxShape.circle,
          //       ),
          //       child: Text(
          //         '${chatRoom.messages.length}',
          //         style: const TextStyle(
          //           color: Colors.white,
          //           fontSize: 12,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
