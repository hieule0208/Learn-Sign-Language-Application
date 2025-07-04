class UserModel {
  final String userId;
  final String? userName;
  final int? age;
  final DateTime? dateOfBirth;
  final String? gender;

  UserModel({
    required this.userId,
    this.userName,
    this.age,
    this.dateOfBirth,
    this.gender,
  });

  // Parse JSON thành UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      age: json['age'] as int?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
    );
  }

  // Chuyển UserModel thành JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'age': age,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
    };
  }
}