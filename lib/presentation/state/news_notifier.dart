import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/search_query_provider.dart';
import '../../domain/usecases/fetch_news_usecase.dart';
import 'news_state.dart';

class NewsNotifier extends StateNotifier<NewsState> {
  final FetchNewsUseCase _fetchNewsUseCase;
  final Ref ref;
  int _page = 1;

  NewsNotifier(this._fetchNewsUseCase, this.ref) : super(NewsState());

  // Fetches news articles based on the query
  Future<void> fetchNews(String query) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    _page = 1; // Reset page number
    try {
      final articles = await _fetchNewsUseCase(query, _page);
      state = state.copyWith(
        isLoading: false,
        articles: articles,
        hasMore: articles.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  // Fetch more news articles when scrolling
  Future<void> fetchMoreNews() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoading: true);
    try {
      _page++;
      final query = ref.read(searchQueryProvider);
      final articles = await _fetchNewsUseCase(query, _page);

      // Wait for a moment before checking if articles are returned
      await Future.delayed(const Duration(milliseconds: 1300));

      // If no articles are returned, set hasMore to false
      if (articles.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          hasMore: false, // No more data available
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          articles: [...state.articles, ...articles],
          hasMore: true,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // Validates the search query
  bool validateQuery(String query) {
    if (query.isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter a search query');
      return false;
    } else if (query.length < 3) {
      state = state.copyWith(
          errorMessage: 'Search query must be at least 3 characters long');
      return false;
    } else {
      state = state.copyWith(errorMessage: "");
      return true;
    }
  }
}
