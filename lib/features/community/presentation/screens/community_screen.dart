import 'package:flutter/material.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/features/community/presentation/screens/user_selection_screen.dart';
import 'package:fit_motiv/features/community/presentation/screens/chat_room_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
            isScrollable: true,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Following'),
              Tab(text: 'For You'),
              Tab(text: 'Messages'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFeed(),
            _buildFeed(),
            _buildFeed(),
            _buildMessagesTab(context),
          ],
        ),
      ),
    );
  }

  static Widget _buildMessagesTab(BuildContext context) {
    // Mock conversations
    final conversations = [
      {'name': 'Sophia', 'lastMsg': 'Thanks for the routine!', 'time': '2m ago', 'unread': 2},
      {'name': 'Ethan', 'lastMsg': 'Ready for today\'s run?', 'time': '15m ago', 'unread': 0},
    ];

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
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: conversations.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.surface),
            itemBuilder: (context, index) {
              final conv = conversations[index];
              final name = conv['name'] as String;
              final lastMsg = conv['lastMsg'] as String;
              final time = conv['time'] as String;
              final unread = conv['unread'] as int;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(name[0], style: const TextStyle(color: AppColors.primary)),
                ),
                title: Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                subtitle: Text(lastMsg, style: AppTextStyles.bodySmall),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(time, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                    if (unread > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
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
