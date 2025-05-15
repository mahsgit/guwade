
class AuthResponseModel {
  final String accessToken;
  final String tokenType;
  final String role;
  final String userId;

  AuthResponseModel({
    required this.accessToken,
    required this.tokenType,
    required this.role,
    required this.userId,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      role: json['role'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'token_type': tokenType,
        'role': role,
        'user_id': userId,
      };
}
