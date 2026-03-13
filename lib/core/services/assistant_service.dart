import 'dart:async';

abstract class AssistantService {
  Future<String> getResponse(String message);
}

class AssistantServiceImpl implements AssistantService {
  @override
  Future<String> getResponse(String message) async {
    // Mocking an AI response for now. 
    // In a real implementation, this would call Gemini, OpenAI, or a custom backend.
    await Future.delayed(const Duration(seconds: 1));
    
    final lowerMsg = message.toLowerCase();
    
    if (lowerMsg.contains('workout') || lowerMsg.contains('entrenar')) {
      return "Sure! For a quick workout today, I recommend 3 sets of 15 squats, 10 push-ups, and a 1-minute plank. How does that sound?";
    } else if (lowerMsg.contains('hello') || lowerMsg.contains('hola')) {
      return "Hello! I'm your FitMotiv Assistant. How can I help you with your training goals today?";
    } else if (lowerMsg.contains('motivation') || lowerMsg.contains('motivación')) {
      return "Remember: 'Your only limit is you.' Keep pushing, every rep counts!";
    }
    
    return "That's interesting! Tell me more about your fitness journey so I can provide better advice.";
  }
}
