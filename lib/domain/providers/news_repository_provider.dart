import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../repositories/news_repository.dart';
import 'news_api_service_provider.dart';

// The newsRepositoryProvider is responsible for providing the NewsRepository instance
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final apiService = ref.read(newsApiServiceProvider);
  return NewsRepositoryImpl(apiService);
});
