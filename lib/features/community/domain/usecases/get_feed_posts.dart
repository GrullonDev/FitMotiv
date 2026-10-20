import 'package:fit_motiv/features/community/domain/entities/post.dart';

class GetFeedPosts {
  Future<List<PostEntity>> call() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      PostEntity(id: 'p1', author: 'Sophia', content: 'First week done!'),
    ];
  }
}
