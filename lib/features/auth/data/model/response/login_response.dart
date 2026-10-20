class LoginResponse {
  LoginResponse({required this.accessToken, required this.refreshToken, required this.tokenType, this.errorDetail});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenType: json['token_type'] ?? 'bearer',
      errorDetail: json['detail'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      if (errorDetail != null) 'detail': errorDetail,
    };
  }

  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final List<dynamic>? errorDetail; // Para manejar errores del servicio

  // Helper para verificar si la respuesta tiene errores
  bool get hasError => errorDetail != null && errorDetail!.isNotEmpty;

  // Helper para obtener el mensaje de error
  String get errorMessage {
    if (!hasError) return '';

    if (errorDetail!.isNotEmpty && errorDetail![0] is Map) {
      final error = errorDetail![0] as Map<String, dynamic>;
      return error['msg'] ?? 'Error desconocido';
    }

    return 'Error en el servidor';
  }
}
