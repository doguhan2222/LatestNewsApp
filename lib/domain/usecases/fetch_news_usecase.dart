import '../../data/models/article.dart';
import '../repositories/news_repository.dart';

// A class that encapsulates the use case of fetching news
class FetchNewsUseCase {
  final NewsRepository repository; // The repository that fetches news data

  // Constructor that accepts a NewsRepository to be used for fetching news
  FetchNewsUseCase(this.repository);

  // This method is called to fetch news articles based on the query and page
  // It takes a query (search term) and page number as arguments
  Future<List<Article>> call(String query, int page) async {
    // Calls the fetchNews method from the repository and returns the result
    return await repository.fetchNews(query, page);
  }
}
