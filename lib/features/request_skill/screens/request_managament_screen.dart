import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:skill_swap_with_spring/features/chat/screens/chat_list_screen.dart';
import 'package:skill_swap_with_spring/features/request_skill/providers/skill_swap_provider.dart';
import 'package:skill_swap_with_spring/shared/provider/user_provider.dart';
import 'package:skill_swap_with_spring/shared/widgets/custom_button.dart';
import 'package:skill_swap_with_spring/shared/widgets/navigator.dart';
import 'package:skill_swap_with_spring/shared/widgets/snackBar.dart';

import '../models/request_enum.dart';
import '../models/skill_swap_request_response_dto.dart';

class RequestsManagementScreen extends StatefulWidget {
  const RequestsManagementScreen({super.key});

  @override
  State<RequestsManagementScreen> createState() =>
      _RequestsManagementScreenState();
}

class _RequestsManagementScreenState extends State<RequestsManagementScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<SkillSwapProvider>(context, listen: false)
      //     .getsentRequest(context.read<UserProvider>().currentUser.id!);
      context
          .read<SkillSwapProvider>()
          .getSentRequests(context.read<UserProvider>().currentUser.id!);

      context
          .read<SkillSwapProvider>()
          .getIncomingRequest(context.read<UserProvider>().currentUser.id!);

      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:
          Consumer<SkillSwapProvider>(builder: (context, skillProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Skill Swap Requests',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Incoming (${skillProvider.incomingRequest.length})'),
                Tab(text: 'Sent (${skillProvider.sentRequest.length})'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildRequestList(skillProvider.incomingRequest, true),
              _buildRequestList(skillProvider.sentRequest, false),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRequestList(
      List<SkillSwapRequestResponseDto> requests, bool isIncoming) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.inbox,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isIncoming
                  ? 'No incoming skill swap requests'
                  : 'No sent skill swap requests',
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
      );
    }

    return Consumer<SkillSwapProvider>(builder: (context, provider, child) {
      return provider.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: isIncoming
                  ? provider.incomingRequest.length
                  : provider.sentRequest.length,
              itemBuilder: (context, index) {
                final request = isIncoming
                    ? provider.incomingRequest[index]
                    : provider.sentRequest[index];
                return _buildRequestCard(request, isIncoming);
              },
            );
    });
  }

  Widget _buildRequestCard(
      SkillSwapRequestResponseDto request, bool isIncoming) {
    // Safely handle null and provide default values
    final sender = request.sender.username;
    final skillsToLearn = (request.senderLearnSkills as List?)?.join(", ") ??
        'No skills specified';
    final skillsToTeach = (request.senderTeachSkills).join(", ");
    final status = request.status;
    final message = request.message;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User and Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    sender,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusChip(status),
              ],
            ),
            const SizedBox(height: 12),

            // Skills Section
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text:
                        isIncoming ? 'Wants to learn: ' : 'You want to learn: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: skillsToLearn),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: isIncoming ? 'Can teach: ' : 'You can teach: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: skillsToTeach),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            if (isIncoming && status == 'ACCEPTED')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: CustomButton(
                  text: 'Go to Chats',
                  onPressed: () {
                    navigator(context, ChatListScreen());
                  },
                ),
              ),

            // Action Buttons for Incoming Requests
            if (isIncoming && status == 'PENDING')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _handleRequestAction(request, RequestStatus.accepted);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _handleRequestAction(request, RequestStatus.rejected);
                        },
                        // _handleRequestAction(request, 'reject'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Reject'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status) {
      case 'Pending':
        chipColor = Colors.orange;
        break;
      case 'Accepted':
        chipColor = Colors.green;
        break;
      case 'Rejected':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(status),
      backgroundColor: chipColor.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: chipColor),
    );
  }

  void _handleRequestAction(
    SkillSwapRequestResponseDto request,
    RequestStatus action,
  ) async {
    // Show a loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Updating request status...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      // Update the request status
      await context
          .read<SkillSwapProvider>()
          .updateRequestsStatus(request.id, action);
      if (!mounted) return;

      // Refresh the data
      await refreshData();
      if (!mounted) return;

      showSnackBar(
        context,
        action == RequestStatus.accepted
            ? 'Request from ${request.receiver.username} accepted'
            : 'Request from ${request.receiver.username} rejected',
        action == RequestStatus.accepted ? Colors.green : Colors.red,
      );
    } catch (e) {
      // Handle errors
      showSnackBar(
        context,
        "Failed to update request status: $e",
        Colors.red,
      );
    }
  }

  Future<void> refreshData() async {
    final userId = context.read<UserProvider>().currentUser.id!;
    await context.read<SkillSwapProvider>().getIncomingRequest(userId);

    if (!mounted) return;

    await context.read<SkillSwapProvider>().getSentRequests(userId);
  }
}
