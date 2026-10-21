abstract class AssistantService {
  Future<String> getResponse(String message);
}

class AssistantServiceImpl implements AssistantService {
  @override
  Future<String> getResponse(String message) async {
    if (message.toLowerCase().contains('workout')) {
      return "Recommended: 3 sets of 15 squats and 10 push-ups.";
    }
    return "I'm having trouble connecting to my brain right now, but stay motivated!";
  }
}
