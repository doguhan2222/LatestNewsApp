import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Utils/screen_sizes.dart';
import '../../Utils/text_files.dart';
import '../../domain/providers/news_provider.dart';
import '../widgets/news_details.dart';
import '../widgets/news_image.dart';

class NewsListScreen extends ConsumerStatefulWidget {
  const NewsListScreen({super.key});

  @override
  ConsumerState<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends ConsumerState<NewsListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(newsNotifierProvider.notifier).fetchMoreNews();
      debugPrint("Fetching more news...");
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizes.init(context);
    final newsState = ref.watch(newsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(TextFiles.latestNews),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            debugPrint("Back button pressed");
          },
        ),
      ),
      body: newsState.isLoading && newsState.articles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: newsState.hasMore
                  ? newsState.articles.length + 1
                  : newsState.articles.length,
              itemBuilder: (context, index) {
                if (index == newsState.articles.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final article = newsState.articles[index];
                return Card(
                  margin: EdgeInsets.symmetric(
                      horizontal: ScreenSizes.width * 0.02,
                      vertical: ScreenSizes.height * 0.01),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      article.imageUrl != null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: NewsImage(imageUrl: article.imageUrl),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: EdgeInsets.all(ScreenSizes.width * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NewsDetails(
                              title: article.title ?? TextFiles.noTitle,
                              description: article.description ??
                                  TextFiles.noDescription,
                              publishedAt: article.publishedAt != null
                                  ? TextFiles.published + article.publishedAt!
                                  : TextFiles.noDate,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // Dispose scroll controller to avoid memory leaks
    super.dispose();
  }
}
