class RegisterResponse {
  RegisterResponse({
    required this.email,
    required this.password,
    required this.username,
    required this.fullName,
    required this.fitnesGoal,
    required this.bio,
    required this.activityLevel,
    required this.age,
    required this.height,
    required this.weight,
    required this.id,
    required this.isActive,
    required this.isVerify,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      fitnesGoal: json['fitnesGoal'] ?? '',
      bio: json['bio'] ?? '',
      activityLevel: json['activityLevel'] ?? '',
      age: json['age'] ?? 0,
      height: json['height'] ?? 0.0,
      weight: json['weight'] ?? 0.0,
      id: json['id'] ?? 0,
      isActive: json['isActive'] ?? false,
      isVerify: json['isVerify'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'username': username,
      'full_name': fullName,
      'fitnes_goal': fitnesGoal,
      'bio': bio,
      'activity_level': activityLevel,
      'age': age,
      'height': height,
      'weight': weight,
      'id': id,
      'is_active': isActive,
      'is_verified': isVerify,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  final String email;
  final String password;
  final String username;
  final String fullName;
  final String fitnesGoal;
  final String bio;
  final String activityLevel;
  final int age;
  final double height;
  final double weight;
  final int id;
  final bool isActive;
  final bool isVerify;
  final String createdAt;
  final String updatedAt;
}
