class RegisterRequest {
  final String phone;
  final String smsCode;
  final String password;

  const RegisterRequest({
    required this.phone,
    required this.smsCode,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'smsCode': smsCode,
      'password': password,
    };
  }
}
