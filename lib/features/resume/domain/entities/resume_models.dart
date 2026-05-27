class Education {
  final int? id;
  final String school;
  final String major;
  final String degree;
  final String startDate;
  final String? endDate;
  final int sortOrder;

  const Education({
    this.id,
    required this.school,
    required this.major,
    required this.degree,
    required this.startDate,
    this.endDate,
    this.sortOrder = 0,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] as int?,
      school: json['school'] as String? ?? '',
      major: json['major'] as String? ?? '',
      degree: json['degree'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String?,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'school': school,
      'major': major,
      'degree': degree,
      'startDate': startDate,
      'endDate': endDate,
      'sortOrder': sortOrder,
    };
  }
}

class WorkExperience {
  final int? id;
  final String companyName;
  final String position;
  final String startDate;
  final String? endDate;
  final String? description;
  final int sortOrder;

  const WorkExperience({
    this.id,
    required this.companyName,
    required this.position,
    required this.startDate,
    this.endDate,
    this.description,
    this.sortOrder = 0,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['id'] as int?,
      companyName: json['companyName'] as String? ?? '',
      position: json['position'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String?,
      description: json['description'] as String?,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'companyName': companyName,
      'position': position,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'sortOrder': sortOrder,
    };
  }
}

class UserSkill {
  final int? id;
  final String skillName;

  const UserSkill({this.id, required this.skillName});

  factory UserSkill.fromJson(Map<String, dynamic> json) {
    return UserSkill(
      id: json['id'] as int?,
      skillName: json['skillName'] as String? ?? '',
    );
  }
}

class SelfIntroduction {
  final int? id;
  final int? userId;
  final String? content;

  const SelfIntroduction({this.id, this.userId, this.content});

  factory SelfIntroduction.fromJson(Map<String, dynamic> json) {
    return SelfIntroduction(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      content: json['content'] as String?,
    );
  }
}

class ResumeData {
  final List<Education> educationList;
  final List<WorkExperience> workExperienceList;
  final List<UserSkill> skillList;
  final SelfIntroduction? selfIntroduction;
  final int completeness;

  const ResumeData({
    required this.educationList,
    required this.workExperienceList,
    required this.skillList,
    this.selfIntroduction,
    required this.completeness,
  });

  factory ResumeData.fromJson(Map<String, dynamic> json) {
    return ResumeData(
      educationList: (json['educationList'] as List<dynamic>?)
              ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      workExperienceList: (json['workExperienceList'] as List<dynamic>?)
              ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      skillList: (json['skillList'] as List<dynamic>?)
              ?.map((e) => UserSkill.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      selfIntroduction: json['selfIntroduction'] != null
          ? SelfIntroduction.fromJson(json['selfIntroduction'] as Map<String, dynamic>)
          : null,
      completeness: json['completeness'] as int? ?? 0,
    );
  }
}
