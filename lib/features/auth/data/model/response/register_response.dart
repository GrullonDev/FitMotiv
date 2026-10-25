class RegisterResponse {
  RegisterResponse({required this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] as String? ?? '',
    );
  }

  final String message;

  bool get isSuccess => message.isNotEmpty;
}
