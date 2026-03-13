import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/features/community/presentation/providers/community_provider.dart';
import 'package:fit_motiv/features/community/presentation/screens/user_selection_screen.dart';
import 'package:fit_motiv/features/community/presentation/screens/chat_room_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text('Community', style: AppTextStyles.heading3),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.primary),
              onPressed: () => provider.refreshAll(),
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Feed'),
              Tab(text: 'Members'),
              Tab(text: 'Messages'),
            ],
          ),
        ),
        body: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : TabBarView(
                children: [
                  _FeedTab(provider: provider),
                  _MembersTab(provider: provider),
                  _MessagesTab(provider: provider),
                ],
              ),
      ),
    );
  }
}

/// Feed de posts
class _FeedTab extends StatelessWidget {
  const _FeedTab({required this.provider});
  final CommunityProvider provider;

  @override
  Widget build(BuildContext context) {
    if (provider.posts.isEmpty) {
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => provider.refreshAll(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Icon(
                    Icons.forum_outlined,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text('No posts yet', style: AppTextStyles.heading4),
                  const SizedBox(height: 8),
                  Text(
                    'Be the first to share something with the community!',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => provider.refreshAll(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: provider.posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          final post = provider.posts[i];
          final profiles = post['profiles'] as Map<String, dynamic>?;
          final authorName = profiles?['full_name'] as String? ??
              profiles?['username'] as String? ??
              'Anonymous';
          final content = post['content'] as String? ?? '';
          final likes = post['likes_count'] as int? ?? 0;
          final comments = post['comments_count'] as int? ?? 0;
          final createdAt = post['created_at'] as String? ?? '';

          final initials = authorName.isNotEmpty
              ? authorName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase()
              : '?';

          String timeAgo = '';
          if (createdAt.isNotEmpty) {
            try {
              final date = DateTime.parse(createdAt);
              final diff = DateTime.now().difference(date);
              if (diff.inDays > 0) {
                timeAgo = '${diff.inDays}d ago';
              } else if (diff.inHours > 0) {
                timeAgo = '${diff.inHours}h ago';
              } else {
                timeAgo = '${diff.inMinutes}m ago';
              }
            } catch (_) {}
          }

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(initials, style: const TextStyle(color: AppColors.primary, fontSize: 14)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authorName,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (timeAgo.isNotEmpty)
                            Text(timeAgo, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(content, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 18, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text('$likes', style: AppTextStyles.bodySmall),
                    const SizedBox(width: 16),
                    const Icon(Icons.comment, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('$comments', style: AppTextStyles.bodySmall),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Lista de miembros de la comunidad
class _MembersTab extends StatelessWidget {
  const _MembersTab({required this.provider});
  final CommunityProvider provider;

  @override
  Widget build(BuildContext context) {
    if (provider.profiles.isEmpty) {
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => provider.refreshAll(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text('No members yet', style: AppTextStyles.heading4),
                  const SizedBox(height: 8),
                  Text(
                    'Members will appear here as people join.',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => provider.refreshAll(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: provider.profiles.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.surface),
        itemBuilder: (context, index) {
          final profile = provider.profiles[index];
          final name = (profile['full_name'] as String? ?? '').isNotEmpty
              ? profile['full_name'] as String
              : profile['username'] as String? ?? 'User';
          final fitnessGoal = profile['fitness_goal'] as String? ?? '';
          final activityLevel = profile['activity_level'] as String? ?? '';
          final isOnline = profile['is_online'] as bool? ?? false;

          final initials = name.isNotEmpty
              ? name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase()
              : '?';

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(initials, style: const TextStyle(color: AppColors.primary)),
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
            title: Text(
              name,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              [activityLevel, fitnessGoal].where((s) => s.isNotEmpty).join(' • '),
              style: AppTextStyles.bodySmall,
            ),
            trailing: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoomScreen(userName: name),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Text(
                'Chat',
                style: TextStyle(color: AppColors.primary, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Tab de mensajes
class _MessagesTab extends StatelessWidget {
  const _MessagesTab({required this.provider});
  final CommunityProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserSelectionScreen()),
              );
            },
            icon: const Icon(Icons.add_comment),
            label: const Text('Start New Chat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: AppColors.textSecondary.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                Text('No conversations yet', style: AppTextStyles.heading4),
                const SizedBox(height: 8),
                Text(
                  'Start a conversation with a community member.',
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
