import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/features/community/presentation/providers/community_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({super.key, required this.post});
  final Map<String, dynamic> post;

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityProvider>().loadComments(widget.post['id']);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      context.read<CommunityProvider>().addComment(widget.post['id'], text);
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();
    final post = widget.post;
    final profiles = post['profiles'] as Map<String, dynamic>?;
    final l10n = context.read<LocaleProvider>();
    final authorName = profiles?['full_name'] as String? ?? profiles?['username'] as String? ?? l10n.translate('anonymous');
    final content = post['content'] as String? ?? '';

    final avatarUrl = 'https://api.dicebear.com/8.x/initials/png?seed=${Uri.encodeComponent(authorName)}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.translate('post_view')),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(avatarUrl),
                      ),
                      const SizedBox(width: 12),
                      Text(authorName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(content, style: AppTextStyles.bodyLarge),
                  const Divider(height: 32),
                  Text(l10n.translate('comments'), style: AppTextStyles.heading4),
                  const SizedBox(height: 16),

                  // Comments List
                  if (provider.postComments.isEmpty)
                    Center(
                      child: Padding(padding: const EdgeInsets.all(32.0), child: Text(l10n.translate('no_comments_yet'))),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.postComments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final comment = provider.postComments[index];
                        final cProfiles = comment['profiles'] as Map<String, dynamic>?;
                        final cAuthor =
                            cProfiles?['full_name'] as String? ?? cProfiles?['username'] as String? ?? l10n.translate('user');
                        final cAvatarUrl = 'https://api.dicebear.com/8.x/initials/png?seed=${Uri.encodeComponent(cAuthor)}';

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(cAvatarUrl),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.textSecondary.withValues(alpha: 0.08),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cAuthor, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                    const SizedBox(height: 4),
                                    Text(comment['content'] ?? '', style: AppTextStyles.bodyMedium),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          // Comment Input
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: MediaQuery.of(context).padding.bottom + 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: l10n.translate('write_comment'),
                      hintStyle: AppTextStyles.bodySmall,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.border)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    onPressed: _submitComment,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
