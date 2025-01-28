import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../usecases/fetch_news_usecase.dart';
import 'news_repository_provider.dart';

// Provider for the FetchNewsUseCase, which is responsible for fetching news
final fetchNewsUseCaseProvider = Provider<FetchNewsUseCase>((ref) {
  final repository = ref.read(newsRepositoryProvider);
  return FetchNewsUseCase(repository);
});
