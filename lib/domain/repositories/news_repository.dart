import '../../data/models/article.dart';

// An abstract class that defines the contract for the NewsRepository
abstract class NewsRepository {
  // A method to fetch news articles based on a query and page number
  // It returns a Future containing a list of Article objects
  Future<List<Article>> fetchNews(String query, int page);
}
