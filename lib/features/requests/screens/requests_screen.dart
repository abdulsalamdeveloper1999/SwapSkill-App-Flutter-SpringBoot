// // lib/features/requests/screens/requests_screen.dart
// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class RequestsScreen extends StatelessWidget {
//   const RequestsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Skill Requests'),
//           bottom: TabBar(
//             tabs: [
//               Tab(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(LucideIcons.inbox),
//                     SizedBox(width: 8),
//                     Text('Received'),
//                   ],
//                 ),
//               ),
//               Tab(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(LucideIcons.send),
//                     SizedBox(width: 8),
//                     Text('Sent'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _RequestsList(requests: receivedRequests),
//             _RequestsList(requests: sentRequests),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _RequestsList extends StatelessWidget {
//   final List<SkillRequest> requests;

//   const _RequestsList({required this.requests});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: requests.length,
//       itemBuilder: (context, index) {
//         final request = requests[index];
//         return RequestCard(request: request);
//       },
//     );
//   }
// }

// class RequestCard extends StatelessWidget {
//   final SkillRequest request;

//   const RequestCard({super.key, required this.request});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 24,
//                   backgroundImage: NetworkImage(
//                     'https://api.dicebear.com/7.x/avataaars/png?seed=${request.username}',
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         request.username,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         request.status.toDisplayString(),
//                         style: TextStyle(
//                           color: request.status.toColor(),
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   request.timeAgo,
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: Theme.of(context).dividerColor,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Requested Skill',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         request.requestedSkill,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   Container(
//                     width: 1,
//                     height: 40,
//                     color: Theme.of(context).dividerColor,
//                   ),
//                   const Spacer(),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Offered Skill',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         request.offeredSkill,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             if (request.status == RequestStatus.pending) ...[
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () {},
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.red,
//                       ),
//                       child: const Text('Decline'),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                       ),
//                       child: const Text('Accept'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// // enum RequestStatus { pending, accepted, declined }

// // extension RequestStatusX on RequestStatus {
// //   String toDisplayString() {
// //     switch (this) {
// //       case RequestStatus.pending:
// //         return 'Pending';
// //       case RequestStatus.accepted:
// //         return 'Accepted';
// //       case RequestStatus.declined:
// //         return 'Declined';
// //     }
// //   }

// //   Color toColor() {
// //     switch (this) {
// //       case RequestStatus.pending:
// //         return Colors.orange;
// //       case RequestStatus.accepted:
// //         return Colors.green;
// //       case RequestStatus.declined:
// //         return Colors.red;
// //     }
// //   }
// // }

// class SkillRequest {
//   final String id;
//   final String username;
//   final String requestedSkill;
//   final String offeredSkill;
//   final RequestStatus status;
//   final String timeAgo;

//   SkillRequest({
//     required this.id,
//     required this.username,
//     required this.requestedSkill,
//     required this.offeredSkill,
//     required this.status,
//     required this.timeAgo,
//   });
// }

// // Sample data
// final receivedRequests = [
//   SkillRequest(
//     id: '1',
//     username: 'Sarah Chen',
//     requestedSkill: 'Flutter Development',
//     offeredSkill: 'Spring Boot',
//     status: RequestStatus.pending,
//     timeAgo: '2h ago',
//   ),
//   SkillRequest(
//     id: '2',
//     username: 'Mike Johnson',
//     requestedSkill: 'UI Design',
//     offeredSkill: 'React Native',
//     status: RequestStatus.accepted,
//     timeAgo: '1d ago',
//   ),
// ];

// final sentRequests = [
//   SkillRequest(
//     id: '3',
//     username: 'Alex Rivera',
//     requestedSkill: 'Node.js',
//     offeredSkill: 'Flutter Development',
//     status: RequestStatus.pending,
//     timeAgo: '5h ago',
//   ),
// ];
