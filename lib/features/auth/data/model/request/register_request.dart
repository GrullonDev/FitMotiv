class RegisterRequest {
  RegisterRequest({
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
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: json['email'],
      password: json['password'],
      username: json['username'],
      fullName: json['fullName'],
      fitnesGoal: json['fitnesGoal'],
      bio: json['bio'],
      activityLevel: json['activityLevel'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
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
}
