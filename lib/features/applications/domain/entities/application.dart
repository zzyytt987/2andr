import '../../../home/domain/entities/job.dart';

enum ApplicationStatus {
  pending('PENDING', '待处理'),
  viewed('VIEWED', '已查看'),
  interview('INTERVIEW', '面试邀请'),
  offer('OFFER', '已发Offer'),
  rejected('REJECTED', '不合适');

  final String value;
  final String label;
  const ApplicationStatus(this.value, this.label);

  static ApplicationStatus fromValue(String value) {
    return ApplicationStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => ApplicationStatus.pending,
    );
  }
}

class JobApplication {
  final int id;
  final String status;
  final String? interviewTime;
  final String? interviewAddress;
  final String? remark;
  final String? createdAt;
  final String? updatedAt;
  final Job? job;

  const JobApplication({
    required this.id,
    required this.status,
    this.interviewTime,
    this.interviewAddress,
    this.remark,
    this.createdAt,
    this.updatedAt,
    this.job,
  });

  ApplicationStatus get applicationStatus => ApplicationStatus.fromValue(status);

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'] as int,
      status: json['status'] as String? ?? 'PENDING',
      interviewTime: json['interviewTime'] as String?,
      interviewAddress: json['interviewAddress'] as String?,
      remark: json['remark'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      job: json['job'] != null ? Job.fromJson(json['job'] as Map<String, dynamic>) : null,
    );
  }
}

class ApplicationStats {
  final int total;
  final Map<String, int> statusCounts;

  const ApplicationStats({required this.total, required this.statusCounts});

  factory ApplicationStats.fromJson(Map<String, dynamic> json) {
    final countsJson = json['statusCounts'] as Map<String, dynamic>?;
    final counts = <String, int>{};
    if (countsJson != null) {
      countsJson.forEach((k, v) => counts[k] = (v as num).toInt());
    }
    return ApplicationStats(
      total: json['total'] as int? ?? 0,
      statusCounts: counts,
    );
  }
}
