class UserModel {
  final String id;
  final String name;
  final String email;

  final String role;
  final String wardId;

  final String? phone;

  final bool isActive;

  // ⭐ ADD THIS
  final double? averageRating;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.wardId,
    this.phone,
    this.isActive = true,
    this.averageRating,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, {required String role}) {
    return UserModel(
      id: map['userId'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: role,
      wardId: map['wardId'] ?? '',
      phone: map['phone'],
      isActive: (map['status'] ?? 'available') != 'off-duty',
      averageRating: (map['averageRating'] as num?)?.toDouble(), // ⭐ added
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': id,
      'name': name,
      'email': email,
      'wardId': wardId,
      'phone': phone,
      'status': isActive ? 'available' : 'off-duty',
      'averageRating': averageRating,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? wardId,
    String? phone,
    bool? isActive,
    double? averageRating,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      wardId: wardId ?? this.wardId,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      averageRating: averageRating ?? this.averageRating,
    );
  }
}
