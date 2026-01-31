class SignupModel {
  final String name;
  final String email;
  final String phone;
  final String password;

  SignupModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toBody() {
    return {'name': name, 'phone': phone};
  }
}
