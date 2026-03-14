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
import 'package:shimmer/shimmer.dart';

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
        body: TabBarView(
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
                // Mostrar en la pestaña de Feed (index 0) para nuevo post
                if (tabController.index == 0) {
                  return FloatingActionButton.extended(
                    onPressed: () => _showCreatePostDialog(context, provider),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text(l10n.translate('new_post'), style: const TextStyle(color: Colors.white)),
                  );
                }
                // Mostrar en la pestaña de Mensajes (index 2) para nuevo chat
                if (tabController.index == 2) {
                  return FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UserSelectionScreen()));
                    },
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    icon: const Icon(Icons.add_comment, color: Colors.white),
                    label: Text(l10n.translate('new_chat'), style: const TextStyle(color: Colors.white)),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context, CommunityProvider provider) {
    final controller = TextEditingController();
    final l10n = context.read<LocaleProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate('create_post')),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: l10n.translate('whats_on_your_mind'),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.translate('cancel'))),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                final success = await provider.createPost(controller.text.trim());
                if (success && context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(l10n.translate('publish'), style: const TextStyle(color: Colors.white)),
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
    if (provider.isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, _) => _buildShimmerCard(context),
      );
    }

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
                  Text('No hay publicaciones', style: AppTextStyles.heading4),
                  const SizedBox(height: 8),
                  Text(
                    '¡Sé el primero en compartir algo con la comunidad!',
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
          final authorName = profiles?['full_name'] as String? ?? profiles?['username'] as String? ?? 'Usuario';
          final content = post['content'] as String? ?? '';
          final likes = post['likes_count'] as int? ?? 0;
          final comments = post['comments_count'] as int? ?? 0;
          final createdAt = post['created_at'] as String? ?? '';
          final isLiked = post['is_liked'] as bool? ?? false;

          final avatarUrl = 'https://api.dicebear.com/8.x/initials/png?seed=${Uri.encodeComponent(authorName)}';

          String timeAgo = '';
          if (createdAt.isNotEmpty) {
            try {
              final date = DateTime.parse(createdAt);
              final diff = DateTime.now().difference(date);
              if (diff.inDays > 0) {
                timeAgo = '${diff.inDays}d';
              } else if (diff.inHours > 0) {
                timeAgo = '${diff.inHours}h';
              } else {
                timeAgo = '${diff.inMinutes}m';
              }
            } catch (_) {}
          }

          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailsScreen(post: post)));
            },
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color ?? Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Encabezado de la tarjeta
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(avatarUrl),
                          radius: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                authorName,
                                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (timeAgo.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '• $timeAgo',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Contenido principal
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Text(
                      content,
                      style: AppTextStyles.bodyLarge.copyWith(height: 1.4),
                    ),
                  ),
                  // Barra de Acciones
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color ?? Colors.white,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => provider.toggleLike(post['id']),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                                  child: Icon(
                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                    key: ValueKey(isLiked),
                                    size: 22,
                                    color: isLiked ? Colors.red : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$likes',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                      color: isLiked ? Colors.red : AppColors.textSecondary,
                                      fontWeight: isLiked ? FontWeight.bold : FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        InkWell(
                          onTap: () => _showCommentDialog(context, provider, post['id']),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.chat_bubble_outline_rounded, size: 20, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Text(
                                  '$comments',
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _showCommentDialog(BuildContext context, CommunityProvider provider, String postId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Añadir Comentario'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Escribe un comentario...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.addComment(postId, controller.text.trim());
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Publicar', style: TextStyle(color: Colors.white)),
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
    if (provider.isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        separatorBuilder: (_, __) => Divider(height: 1, color: Theme.of(context).dividerColor),
        itemBuilder: (context, _) => _buildShimmerTile(context),
      );
    }

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
                  Text('Aún no hay miembros', style: AppTextStyles.heading4),
                  const SizedBox(height: 8),
                  Text(
                    'Los miembros aparecerán aquí cuando se unan.',
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
              : profile['username'] as String? ?? 'Usuario';
          final fitnessGoal = profile['fitness_goal'] as String? ?? '';
          final activityLevel = profile['activity_level'] as String? ?? '';
          final isOnline = profile['is_online'] as bool? ?? false;

          final avatarUrl = 'https://api.dicebear.com/8.x/initials/png?seed=${Uri.encodeComponent(name)}';

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  radius: 24,
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
            trailing: IconButton(
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al iniciar chat: $e')));
                }
              },
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              ),
              icon: Icon(Icons.chat_bubble_outline, color: Theme.of(context).colorScheme.primary, size: 20),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerTile(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: const CircleAvatar(radius: 24, backgroundColor: Colors.white),
        title: Container(height: 14, width: 100, color: Colors.white),
        subtitle: Container(height: 12, width: 150, color: Colors.white, margin: const EdgeInsets.only(top: 8)),
        trailing: Container(width: 40, height: 40, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
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
    if (provider.isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        separatorBuilder: (_, __) => Divider(height: 1, color: Theme.of(context).dividerColor, indent: 70),
        itemBuilder: (context, _) => _buildShimmerTile(context),
      );
    }

    if (provider.conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text('No tienes mensajes aún', style: AppTextStyles.heading4),
            const SizedBox(height: 8),
            Text(
              'Inicia una conversación con algún miembro de la comunidad.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: provider.conversations.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Theme.of(context).dividerColor, indent: 70),
      itemBuilder: (context, index) {
        final conv = provider.conversations[index];
        final currentUserId = provider.isLoading ? '' : Supabase.instance.client.auth.currentUser?.id;

        // Identificar al otro participante
        final isP1Other = conv['participant_1_id'] != currentUserId;
        final otherProfile = isP1Other ? conv['p1'] : conv['p2'];

        final otherId = otherProfile['id'] as String;
        final name = otherProfile['full_name'] as String? ?? otherProfile['username'] as String? ?? 'Usuario';
        final lastMsgText = conv['last_message_text'] as String? ?? 'Sin mensajes';
        final lastAt = conv['last_message_at'] as String? ?? '';
        final isOnline = otherProfile['is_online'] as bool? ?? false;

        final avatarUrl = 'https://api.dicebear.com/8.x/initials/png?seed=${Uri.encodeComponent(name)}';
        final hasUnread = conv['unread_count'] != null && (conv['unread_count'] as int) > 0;

        // Para distinguir el preview del mensaje:
        final lastMessageSenderId = conv['last_message_sender_id'] as String?;
        final isMe = lastMessageSenderId == currentUserId;
        final previewStr = isMe ? 'Tú: $lastMsgText' : '$name: $lastMsgText';

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          onTap: () {
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
                radius: 26,
                backgroundImage: NetworkImage(avatarUrl),
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
                    fontSize: 12,
                    color: hasUnread ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  previewStr,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text(
                    '${conv['unread_count']}',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerTile(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: const CircleAvatar(radius: 26, backgroundColor: Colors.white),
        title: Container(height: 14, width: 100, color: Colors.white),
        subtitle: Container(height: 12, width: 150, color: Colors.white, margin: const EdgeInsets.only(top: 8)),
      ),
    );
  }

  String _formatTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final diff = DateTime.now().difference(date);
      if (diff.inDays > 0) return '${diff.inDays}d';
      if (diff.inHours > 0) return '${diff.inHours}h';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m';
      return 'ahora';
    } catch (_) {
      return '';
    }
  }
}
