class UserProfile {
  final int id;
  final String phone;
  final String? nickname;
  final String? avatarUrl;
  final String? email;
  final int gender;
  final String? birthday;
  final String? city;
  final String? expectedPosition;
  final int? expectedSalaryMin;
  final int? expectedSalaryMax;
  final String? jobStatus;

  const UserProfile({
    required this.id,
    required this.phone,
    this.nickname,
    this.avatarUrl,
    this.email,
    this.gender = 0,
    this.birthday,
    this.city,
    this.expectedPosition,
    this.expectedSalaryMin,
    this.expectedSalaryMax,
    this.jobStatus,
  });

  String get displayName => nickname ?? '用户${phone.substring(phone.length - 4)}';
  String get genderText => gender == 1 ? '男' : (gender == 2 ? '女' : '未设置');

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      phone: json['phone'] as String? ?? '',
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as int? ?? 0,
      birthday: json['birthday'] as String?,
      city: json['city'] as String?,
      expectedPosition: json['expectedPosition'] as String?,
      expectedSalaryMin: json['expectedSalaryMin'] as int?,
      expectedSalaryMax: json['expectedSalaryMax'] as int?,
      jobStatus: json['jobStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
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
