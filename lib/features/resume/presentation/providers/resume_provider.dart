import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/resume_models.dart';
import '../../domain/repositories/resume_repository.dart';
import '../../data/repositories/resume_repository_impl.dart';

final resumeRepositoryProvider = Provider<ResumeRepository>((ref) => ResumeRepositoryImpl());

final resumeProvider = FutureProvider<ResumeData>((ref) {
  return ref.read(resumeRepositoryProvider).getResume();
});

final resumeProgressProvider = FutureProvider<int>((ref) {
  return ref.read(resumeRepositoryProvider).getProgress();
});
