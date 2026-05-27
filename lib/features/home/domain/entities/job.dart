class PageResult<T> {
  final List<T> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  const PageResult({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory PageResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    return PageResult(
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => fromItem(e as Map<String, dynamic>))
              .toList() ??
          [],
      page: json['page'] ?? 1,
      size: json['size'] ?? 20,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  bool get hasMore => page < totalPages;
}

class Job {
  final int id;
  final String title;
  final int salaryMin;
  final int salaryMax;
  final String experience;
  final String education;
  final String city;
  final String district;
  final String description;
  final List<String> benefits;
  final List<String> skills;
  final int viewCount;
  final bool isUrgent;
  final String? createdAt;
  final String? updatedAt;
  final int? companyId;
  final String? companyName;
  final String? companyLogo;
  final String? companySize;
  final String? companyIndustry;
  final String? companyFinancing;
  final String? companyDescription;
  final String? companyAddress;

  const Job({
    required this.id,
    required this.title,
    required this.salaryMin,
    required this.salaryMax,
    required this.experience,
    required this.education,
    required this.city,
    required this.district,
    required this.description,
    required this.benefits,
    required this.skills,
    required this.viewCount,
    required this.isUrgent,
    this.createdAt,
    this.updatedAt,
    this.companyId,
    this.companyName,
    this.companyLogo,
    this.companySize,
    this.companyIndustry,
    this.companyFinancing,
    this.companyDescription,
    this.companyAddress,
  });

  String get salaryRange {
    final minK = (salaryMin / 1000).toStringAsFixed(0);
    final maxK = (salaryMax / 1000).toStringAsFixed(0);
    return '${minK}K-${maxK}K';
  }

  String get salaryRangeFull => '${salaryMin / 1000}K-${salaryMax / 1000}K · 月薪';

  String get location => '$city · $district';

  String get companyMeta {
    final parts = <String>[];
    if (companySize != null && companySize!.isNotEmpty) parts.add(companySize!);
    if (companyIndustry != null && companyIndustry!.isNotEmpty) parts.add(companyIndustry!);
    if (companyFinancing != null && companyFinancing!.isNotEmpty) parts.add(companyFinancing!);
    return parts.join(' · ');
  }

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      salaryMin: json['salaryMin'] as int? ?? 0,
      salaryMax: json['salaryMax'] as int? ?? 0,
      experience: json['experience'] as String? ?? '',
      education: json['education'] as String? ?? '',
      city: json['city'] as String? ?? '',
      district: json['district'] as String? ?? '',
      description: json['description'] as String? ?? '',
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      viewCount: json['viewCount'] as int? ?? 0,
      isUrgent: json['isUrgent'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      companyId: json['companyId'] as int?,
      companyName: json['companyName'] as String?,
      companyLogo: json['companyLogo'] as String?,
      companySize: json['companySize'] as String?,
      companyIndustry: json['companyIndustry'] as String?,
      companyFinancing: json['companyFinancing'] as String?,
      companyDescription: json['companyDescription'] as String?,
      companyAddress: json['companyAddress'] as String?,
    );
  }
}
