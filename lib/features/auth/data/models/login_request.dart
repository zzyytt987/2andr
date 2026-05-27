class LoginRequest {
  final String phone;
  final String? password;
  final String? smsCode;

  const LoginRequest({
    required this.phone,
    this.password,
    this.smsCode,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'phone': phone};
    if (password != null) map['password'] = password;
    if (smsCode != null) map['smsCode'] = smsCode;
    return map;
  }
}
