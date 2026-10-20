import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/features/community/presentation/providers/community_provider.dart';
import 'package:fit_motiv/features/community/presentation/screens/chat_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();
    final allProfiles = provider.profiles;

    // Filtrar por búsqueda
    final filtered = _searchQuery.isEmpty
        ? allProfiles
        : allProfiles.where((p) {
            final name = (p['full_name'] as String? ?? '').toLowerCase();
            final username = (p['username'] as String? ?? '').toLowerCase();
            return name.contains(_searchQuery) || username.contains(_searchQuery);
          }).toList();

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
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          if (provider.isLoading)
            Expanded(
              child: Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
            )
          else if (filtered.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.4)),
                    const SizedBox(height: 12),
                    Text(
                      _searchQuery.isEmpty ? 'No users found' : 'No results for "$_searchQuery"',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.surface),
                itemBuilder: (context, index) {
                  final user = filtered[index];
                  final name = (user['full_name'] as String? ?? '').isNotEmpty
                      ? user['full_name'] as String
                      : user['username'] as String? ?? 'User';
                  final activityLevel = user['activity_level'] as String? ?? '';
                  final isOnline = user['is_online'] as bool? ?? false;

                  final initials = name.isNotEmpty
                      ? name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase()
                      : '?';

                  return ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          child: Text(initials, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                        ),
                        if (isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      isOnline
                          ? 'Online'
                          : activityLevel.isNotEmpty
                          ? activityLevel
                          : 'Offline',
                      style: AppTextStyles.bodySmall,
                    ),
                    onTap: () async {
                      try {
                        final conv = await provider.startConversation(user['id']);
                        if (!context.mounted) return;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatRoomScreen(userName: name, conversationId: conv['id'], otherUserId: user['id']),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error starting conversation: $e')));
                      }
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
