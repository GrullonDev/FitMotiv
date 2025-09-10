import 'package:flutter/material.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              icon: const Icon(Icons.search, color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Following'),
              Tab(text: 'For You'),
            ],
          ),
        ),
        body: TabBarView(children: List.generate(3, (_) => _buildFeed())),
      ),
    );
  }

  static Widget _buildFeed() {
    final posts = [
      {
        'name': 'Sophia',
        'time': '10 min ago',
        'content':
            'Just completed my first week of the beginner’s routine! Feeling energized and ready for more. #fitnessjourney',
        'likes': 23,
        'comments': 5,
      },
      {
        'name': 'Ethan',
        'time': '25 min ago',
        'content':
            'Hit a new personal best on my run today! Consistency pays off. #running #progress',
        'likes': 18,
        'comments': 3,
      },
      {
        'name': 'Olivia',
        'time': '40 min ago',
        'content':
            'Trying out a new healthy recipe tonight. Wish me luck! #healthyeating #cooking',
        'likes': 32,
        'comments': 8,
      },
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (context, i) {
        final post = posts[i];
        final initials = (post['name'] as String)
            .split(' ')
            .map((e) => e[0])
            .join();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    initials,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['name'] as String,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      post['time'] as String,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(post['content'] as String, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.favorite, size: 20, color: AppColors.primary),
                const SizedBox(width: 4),
                Text('${post['likes']}', style: AppTextStyles.bodySmall),
                const SizedBox(width: 16),
                const Icon(
                  Icons.comment,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text('${post['comments']}', style: AppTextStyles.bodySmall),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.share, color: AppColors.textSecondary),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
