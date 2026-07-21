class AdminUserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String role;
  final String createdAt;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    required this.createdAt,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
      role: json["role"] ?? "",
      createdAt: json["createdAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "role": role,
    };
  }
}