class AdminDashboardModel {
  final int totalUser;
  final int totalAdmin;
  final int totalProduct;
  final int totalCategory;
  final int totalOrder;

  AdminDashboardModel({
    required this.totalUser,
    required this.totalAdmin,
    required this.totalProduct,
    required this.totalCategory,
    required this.totalOrder,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardModel(
      totalUser: json["totalUser"] ?? 0,
      totalAdmin: json["totalAdmin"] ?? 0,
      totalProduct: json["totalProduct"] ?? 0,
      totalCategory: json["totalCategory"] ?? 0,
      totalOrder: json["totalOrder"] ?? 0,
    );
  }
}