import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/state/news_notifier.dart';
import '../../presentation/state/news_state.dart';
import 'fetch_news_usecase_provider.dart';

// The NewsNotifierProvider manages the state of the news feature
final newsNotifierProvider = StateNotifierProvider<NewsNotifier, NewsState>(
  (ref) {
    final fetchNewsUseCase = ref.read(fetchNewsUseCaseProvider);
    return NewsNotifier(fetchNewsUseCase, ref);
  },
);
