import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/screen_sizes.dart';
import '../../Utils/text_files.dart';
import '../../data/datasources/search_history_manager.dart';
import '../../domain/providers/news_provider.dart';
import '../../domain/providers/search_query_provider.dart';
import 'news_list_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final SearchHistoryManager _searchHistoryManager = SearchHistoryManager();
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  // Load search history from shared preferences
  Future<void> _loadSearchHistory() async {
    final history = await _searchHistoryManager.getSearchHistory();
    setState(() {
      _searchHistory = history;
    });
  }

  // Remove a specific query from the search history
  Future<void> _removeSearchHistory(String query) async {
    await _searchHistoryManager.removeSearchQuery(query);
    await _loadSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizes.init(context);
    final newsState = ref.watch(newsNotifierProvider);
    final newsNotifier = ref.read(newsNotifierProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(TextFiles.searchAppBarTitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(ScreenSizes.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: TextFiles.searchLabelText,
                labelStyle: TextStyle(
                  color: newsState.errorMessage == ""
                      ? AppColors.labelColor
                      : AppColors.errorColor,
                ),
                floatingLabelStyle: TextStyle(
                  color: newsState.errorMessage == ""
                      ? AppColors.labelColor
                      : AppColors.errorColor,
                ),
                border: const OutlineInputBorder(),
                errorText: newsState.errorMessage,
                errorBorder:
                    _buildBorder(newsState.errorMessage?.isNotEmpty ?? false),
                focusedBorder:
                    _buildBorder(newsState.errorMessage?.isEmpty ?? false),
                focusedErrorBorder:
                    _buildBorder(newsState.errorMessage?.isNotEmpty ?? false),
              ),
              onChanged: (query) {
                if (query.isEmpty) {
                  newsNotifier.validateQuery(query);
                } else {
                  ref.read(searchQueryProvider.notifier).state = query;
                }
                debugPrint("Search query changed: $query");
              },
              onSubmitted: (query) async {
                if (query.isNotEmpty) {
                  final isValid = newsNotifier.validateQuery(query);
                  if (isValid) {
                    await _searchHistoryManager.saveSearchQuery(query);
                    await _loadSearchHistory();
                    debugPrint("Search submitted: $query");

                    try {
                      await newsNotifier.fetchNews(query);
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const NewsListScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 600),
                        ),
                      );
                    } catch (e) {
                      debugPrint("Error during search fetch: $e");
                    }
                  }
                }
              },
            ),
            SizedBox(height: ScreenSizes.height * 0.025),
            // Display recent search history
            _searchHistory.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        TextFiles.recentSearches,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: ScreenSizes.height * 0.01),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _searchHistory.length > 5
                            ? 5
                            : _searchHistory.length,
                        itemBuilder: (context, index) {
                          final query = _searchHistory[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: ScreenSizes.height * 0.009),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.greyColor.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: ScreenSizes.width * 0.04,
                                  vertical: ScreenSizes.height * 0.005),
                              title: Text(
                                query,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.close,
                                    color: AppColors.errorColor),
                                onPressed: () async {
                                  await _removeSearchHistory(query);
                                },
                              ),
                              onTap: () async {
                                ref.read(searchQueryProvider.notifier).state =
                                    query;
                                await _searchHistoryManager
                                    .saveSearchQuery(query);
                                await _loadSearchHistory();
                                debugPrint(
                                    "Search history item tapped: $query");
                                try {
                                  await newsNotifier.fetchNews(query);
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const NewsListScreen(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(0.0,
                                            1.0); // Sayfa aşağıdan yukarıya kayar
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          ),
                                        );
                                      },
                                      transitionDuration: const Duration(
                                          milliseconds: 600), // Geçişin süresi
                                    ),
                                  );
                                } catch (e) {
                                  debugPrint("Error during history fetch: $e");
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: ScreenSizes.height * 0.015),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: ScreenSizes.height * 0.02),
                ),
                onPressed: () async {
                  final query = ref.read(searchQueryProvider);
                  if (query.isNotEmpty) {
                    if (newsNotifier.validateQuery(query)) {
                      await _searchHistoryManager.saveSearchQuery(query);
                      await _loadSearchHistory();
                      debugPrint("Search button pressed: $query");

                      try {
                        newsNotifier.fetchNews(query);
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const NewsListScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 600),
                          ),
                        );
                      } catch (e) {
                        debugPrint("Error during history fetch: $e");
                      }
                    }
                  }
                },
                child: Text(
                  TextFiles.searchButton,
                  style: TextStyle(
                    fontSize: ScreenSizes.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(bool hasError) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: hasError ? AppColors.errorColor : AppColors.labelColor,
        width: 2,
      ),
    );
  }
}
