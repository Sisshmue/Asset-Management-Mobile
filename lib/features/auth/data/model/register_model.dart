class RegisterModel {
  String name;
  String email;
  String password;
  String role;
  String position;

  RegisterModel({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.position,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    data['position'] = position;
    return data;
  }
}
