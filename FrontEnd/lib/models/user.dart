class User {
  final int id;
  final String? fullName;
  final String email;
  final String? phone;
  final DateTime? createdAt;
  final String? address;
  final String? role;
  final DateTime? dateOfBirth;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.address,
    required this.role,
    required this.dateOfBirth,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      address: json['address'] as String?,
      role: json['role'] as String?,
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth']) : null,
    );
  }
}
