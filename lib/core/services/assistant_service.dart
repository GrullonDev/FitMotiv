import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AssistantService {
  Future<String> getResponse(String message);
}

class AssistantServiceImpl implements AssistantService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<String> getResponse(String message) async {
    try {
      final response = await _client.functions.invoke('ai-assistant', body: {'message': message});

      if (response.status == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['reply'] ?? 'I received your message, but I cannot think of a reply right now.';
      } else {
        return 'Error: Could not connect to the AI assistant (Status ${response.status}).';
      }
    } catch (e) {
      // Fallback to local logic if the function is not deployed or fails
      if (message.toLowerCase().contains('workout')) {
        return "Recommended: 3 sets of 15 squats and 10 push-ups.";
      }
      return "I'm having trouble connecting to my brain right now, but stay motivated!";
    }
  }
}
