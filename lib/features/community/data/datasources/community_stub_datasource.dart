class CommunityStubDatasource {
  Future<List<Map<String, dynamic>>> getProfiles({
    double? myLat,
    double? myLon,
  }) async {
    return [];
  }

  Future<List<Map<String, dynamic>>> getFeedPosts() async {
    return [];
  }

  Future<void> toggleLike(String postId) async {}

  Future<void> addComment(String postId, String content) async {}

  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    return [];
  }

  Future<void> createPost(String content) async {}

  Future<List<Map<String, dynamic>>> getConversations() async {
    return [];
  }

  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    return [];
  }

  Stream<List<Map<String, dynamic>>> streamMessages(String conversationId) {
    return const Stream.empty();
  }

  Future<void> sendMessage({
    required String conversationId,
    required String receiverId,
    required String text,
  }) async {}

  Future<Map<String, dynamic>> getOrCreateConversation(
    String otherUserId,
  ) async {
    return {};
  }

  Future<void> ensureProfileExists() async {}

  Future<void> updateLocation(double lat, double lon) async {}
}
