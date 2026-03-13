/// Modelo del perfil del usuario que se mapea desde Supabase Auth metadata.
class UserProfileModel {
  const UserProfileModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.username,
    required this.bio,
    required this.fitnessGoal,
    required this.activityLevel,
    required this.age,
    required this.height,
    required this.weight,
    required this.avatarUrl,
    required this.createdAt,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] as String? ?? '',
      email: map['email'] as String? ?? '',
      fullName: map['full_name'] as String? ?? '',
      username: map['username'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      fitnessGoal: map['fitness_goal'] as String? ?? '',
      activityLevel: map['activity_level'] as String? ?? '',
      age: _parseToInt(map['age']),
      height: _parseToDouble(map['height']),
      weight: _parseToDouble(map['weight']),
      avatarUrl: map['avatar_url'] as String? ?? '',
      createdAt: map['created_at'] as String? ?? '',
    );
  }

  final String id;
  final String email;
  final String fullName;
  final String username;
  final String bio;
  final String fitnessGoal;
  final String activityLevel;
  final int age;
  final double height; // in meters
  final double weight; // in pounds
  final String avatarUrl;
  final String createdAt;

  /// Nombre para mostrar: usa fullName si disponible, si no username, si no email
  String get displayName {
    if (fullName.isNotEmpty) return fullName;
    if (username.isNotEmpty) return username;
    return email.split('@').first;
  }

  /// Inicial del nombre para el avatar
  String get initials {
    if (fullName.isNotEmpty) {
      final parts = fullName.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return fullName[0].toUpperCase();
    }
    if (username.isNotEmpty) return username[0].toUpperCase();
    return email[0].toUpperCase();
  }

  /// Tiempo desde que se unió
  String get memberSince {
    if (createdAt.isEmpty) return '';
    try {
      final date = DateTime.parse(createdAt);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays < 1) return 'Joined today';
      if (diff.inDays < 7) return 'Joined ${diff.inDays} days ago';
      if (diff.inDays < 30) return 'Joined ${(diff.inDays / 7).floor()} weeks ago';
      if (diff.inDays < 365) return 'Joined ${(diff.inDays / 30).floor()} months ago';
      return 'Joined ${(diff.inDays / 365).floor()} years ago';
    } catch (_) {
      return '';
    }
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
