class User {
  final int id;
  final String phone;
  final String? nickname;
  final String? avatarUrl;
  final String? email;
  final int? gender;
  final String? birthday;
  final String? city;
  final String? expectedPosition;
  final int? expectedSalaryMin;
  final int? expectedSalaryMax;
  final String? jobStatus;

  const User({
    required this.id,
    required this.phone,
    this.nickname,
    this.avatarUrl,
    this.email,
    this.gender,
    this.birthday,
    this.city,
    this.expectedPosition,
    this.expectedSalaryMin,
    this.expectedSalaryMax,
    this.jobStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      phone: json['phone'] ?? '',
      nickname: json['nickname'],
      avatarUrl: json['avatarUrl'],
      email: json['email'],
      gender: json['gender'],
      birthday: json['birthday'],
      city: json['city'],
      expectedPosition: json['expectedPosition'],
      expectedSalaryMin: json['expectedSalaryMin'],
      expectedSalaryMax: json['expectedSalaryMax'],
      jobStatus: json['jobStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'nickname': nickname,
      'avatarUrl': avatarUrl,
      'email': email,
      'gender': gender,
      'birthday': birthday,
      'city': city,
      'expectedPosition': expectedPosition,
      'expectedSalaryMin': expectedSalaryMin,
      'expectedSalaryMax': expectedSalaryMax,
      'jobStatus': jobStatus,
    };
  }
}
