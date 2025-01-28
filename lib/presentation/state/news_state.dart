import '../../data/models/article.dart';

/// Represents the state of the news screen, including loading state,
/// fetched articles, error messages, and whether more data is available.
class NewsState {
  final bool isLoading;
  final List<Article> articles;
  final String? errorMessage;
  final bool hasMore;

  NewsState({
    this.isLoading = false,
    this.articles = const [],
    this.errorMessage = "",
    this.hasMore = true,
  });

  NewsState copyWith({
    bool? isLoading,
    List<Article>? articles,
    String? errorMessage,
    bool? hasMore,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      articles: articles ?? this.articles,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
