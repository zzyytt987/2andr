class SmsRequest {
  final String phone;
  final String type;

  const SmsRequest({required this.phone, required this.type});

  Map<String, dynamic> toJson() => {'phone': phone, 'type': type};
}
