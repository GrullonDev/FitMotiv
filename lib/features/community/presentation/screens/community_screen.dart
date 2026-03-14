import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/features/community/presentation/providers/community_provider.dart';
import 'package:fit_motiv/features/community/presentation/screens/chat_room_screen.dart';
import 'package:fit_motiv/features/community/presentation/screens/post_details_screen.dart';
import 'package:fit_motiv/features/community/presentation/screens/user_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();
    final l10n = context.watch<LocaleProvider>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.translate('community'), style: AppTextStyles.heading3),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary),
              onPressed: () => provider.refreshAll(),
            ),
          ],
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(text: l10n.translate('feed')),
              Tab(text: l10n.translate('members')),
              Tab(text: l10n.translate('messages')),
            ],
          ),
        ),
        body: provider.isLoading
            ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
            : TabBarView(
                children: [
                  _FeedTab(provider: provider),
                  _MembersTab(provider: provider),
                  _MessagesTab(provider: provider),
                ],
              ),
        floatingActionButton: Builder(
          builder: (context) {
            final tabController = DefaultTabController.of(context);
            return AnimatedBuilder(
              animation: tabController,
              builder: (context, child) {
                // Solo mostrar en la pestaña de Feed (index 0)
                if (tabController.index != 0) return const SizedBox.shrink();
                return FloatingActionButton(
                  onPressed: () => _showCreatePostDialog(context, provider),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.add, color: Colors.white),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context, CommunityProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Post'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(hintText: "What's on your mind?", border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                final success = await provider.createPost(controller.text.trim());
                if (success && context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
            child: const Text('Post', style: TextStyle(color: Colors.white)),
          ),
        ],
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
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () => provider.refreshAll(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Icon(Icons.forum_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.4)),
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
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () => provider.refreshAll(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: provider.posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          final post = provider.posts[i];
          final profiles = post['profiles'] as Map<String, dynamic>?;
          final authorName = profiles?['full_name'] as String? ?? profiles?['username'] as String? ?? 'Anonymous';
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

          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailsScreen(post: post)));
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color ?? Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        child: Text(
                          initials,
                          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(authorName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
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
                      InkWell(
                        onTap: () => provider.toggleLike(post['id']),
                        child: Row(
                          children: [
                            Icon(
                              (post['is_liked'] ?? false) ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: (post['is_liked'] ?? false) ? Colors.red : Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text('$likes', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () => _showCommentDialog(context, provider, post['id']),
                        child: Row(
                          children: [
                            const Icon(Icons.mode_comment_outlined, size: 18, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text('$comments', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCommentDialog(BuildContext context, CommunityProvider provider, String postId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Write a comment...'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.addComment(postId, controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Post'),
          ),
        ],
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
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () => provider.refreshAll(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Icon(Icons.people_outline, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.4)),
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
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () => provider.refreshAll(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: provider.profiles.length,
        separatorBuilder: (_, __) => Divider(height: 1, color: Theme.of(context).dividerColor),
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
            title: Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [activityLevel, fitnessGoal].where((s) => s.isNotEmpty).join(' • '),
                  style: AppTextStyles.bodySmall,
                ),
                if (profile['latitude'] != null)
                  Text(
                    provider.getDistanceString(profile['latitude'], profile['longitude']),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            trailing: OutlinedButton(
              onPressed: () async {
                try {
                  final conv = await provider.startConversation(profile['id']);
                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatRoomScreen(userName: name, conversationId: conv['id'], otherUserId: profile['id']),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error starting conversation: $e')));
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Text('Chat', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12)),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UserSelectionScreen()));
            },
            icon: const Icon(Icons.add_comment),
            label: const Text('Start New Chat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        Expanded(
          child: provider.conversations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.4)),
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
                )
              : ListView.separated(
                  itemCount: provider.conversations.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: Theme.of(context).dividerColor, indent: 70),
                  itemBuilder: (context, index) {
                    final conv = provider.conversations[index];
                    final currentUserId = provider.isLoading ? '' : Supabase.instance.client.auth.currentUser?.id;

                    // Identificar al otro participante
                    final isP1Other = conv['participant_1_id'] != currentUserId;
                    final otherProfile = isP1Other ? conv['p1'] : conv['p2'];

                    final otherId = otherProfile['id'] as String;
                    final name = otherProfile['full_name'] as String? ?? otherProfile['username'] as String? ?? 'User';
                    final lastMsg = conv['last_message_text'] as String? ?? 'No messages yet';
                    final lastAt = conv['last_message_at'] as String? ?? '';
                    final isOnline = otherProfile['is_online'] as bool? ?? false;

                    final initials = name.isNotEmpty
                        ? name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase()
                        : '?';
                    final hasUnread = conv['unread_count'] != null && (conv['unread_count'] as int) > 0;

                    return ListTile(
                      onTap: () {
                        // Marcar como leído (pendiente implementar en provider)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatRoomScreen(userName: name, conversationId: conv['id'], otherUserId: otherId),
                          ),
                        );
                      },
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            child: Text(
                              initials,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isOnline)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                          ),
                          if (lastAt.isNotEmpty)
                            Text(
                              _formatTime(lastAt),
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 10,
                                color: hasUnread ? Theme.of(context).colorScheme.primary : AppColors.textSecondary,
                                fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastMsg,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: hasUnread ? AppColors.textPrimary : AppColors.textSecondary,
                                fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasUnread)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${conv['unread_count']}',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _formatTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inDays > 0) return '${diff.inDays}d';
      if (diff.inHours > 0) return '${diff.inHours}h';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m';
      return 'now';
    } catch (_) {
      return '';
    }
  }
}
