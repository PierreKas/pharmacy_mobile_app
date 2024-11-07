class User {
  String fullName;
  String phoneNumber;
  String? role;
  int? sellingPointId;
  String password;
  String? userState;
  int? userId;
  String? sellingPointName;

  User(
      {required this.fullName,
      required this.phoneNumber,
      this.role,
      required this.sellingPointId,
      required this.password,
      this.userState,
      this.userId,
      this.sellingPointName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        fullName: json['Full_name'],
        phoneNumber: json['phone_number'],
        role: json['role'],
        sellingPointId: json['selling_point_id'],
        password: json['pwd'],
        userState: json['user_state'],
        userId: json['user_id'],
        sellingPointName: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Full_name': fullName,
      'phone_number': phoneNumber,
      'role': role,
      'selling_point_id': sellingPointId,
      'pwd': password,
      'user_state': userState,
      'user_id': userId,
      'name': sellingPointName,
    };
  }
}
