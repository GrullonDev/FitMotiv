import 'package:flutter/material.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/features/community/presentation/screens/chat_room_screen.dart';

class UserSelectionScreen extends StatelessWidget {
  const UserSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock users for demonstration
    final users = [
      {'name': 'Sophia Aris', 'status': 'Active 5m ago', 'level': 'Pro'},
      {'name': 'Ethan Hunt', 'status': 'Online', 'level': 'Expert'},
      {'name': 'Olivia Smith', 'status': 'Offline', 'level': 'Intermediate'},
      {'name': 'Jackson Hole', 'status': 'Active 1h ago', 'level': 'Beginner'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Start Conversation', style: AppTextStyles.heading3),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: users.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.surface),
              itemBuilder: (context, index) {
                final user = users[index];
                final name = user['name'] as String;
                final status = user['status'] as String;
                final level = user['level'] as String;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(name[0], style: const TextStyle(color: AppColors.primary)),
                  ),
                  title: Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(status, style: AppTextStyles.bodySmall),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(level, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontSize: 10)),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomScreen(userName: name),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
