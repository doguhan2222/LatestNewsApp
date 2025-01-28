import '../../domain/repositories/news_repository.dart';
import '../datasources/news_api_service.dart';
import '../models/article.dart';

class NewsRepositoryImpl implements NewsRepository {
  // The NewsApiService instance that this repository will interact with.
  final NewsApiService _apiService;

  NewsRepositoryImpl(this._apiService);

  // Fetch the news based on the query and page number for pagination.
  @override
  Future<List<Article>> fetchNews(String query, int page) {
    return _apiService.fetchNews(query, page);
  }
}
