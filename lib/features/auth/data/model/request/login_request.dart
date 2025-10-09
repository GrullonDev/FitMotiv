class LoginRequest {
  LoginRequest({required this.username, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(username: json['username'], password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }

  final String username;
  final String password;
}
