import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/constants.dart';
import '../models/article.dart';

class NewsApiService {
  final Dio _dio;

  // Constructor that initializes the NewsApiService with a Dio instance for HTTP requests
  NewsApiService(this._dio);

  // Function to fetch news articles based on the search query and page number
  Future<List<Article>> fetchNews(String query, int page) async {
    const apiKey = Constants.API_KEY;
    const baseUrl = Constants.BASE_URL;

    // Retrieve shared preferences for caching data
    final prefs = await SharedPreferences.getInstance();

    // Dynamically create cache keys based on query and page for caching purposes
    final cacheKey = 'news_$query$page';
    final cacheTimeKey = '${cacheKey}_time';

    try {
      // 1. Check if cached data exists and if it is still fresh (within 1 hour)
      final lastFetchedTime = prefs.getInt(cacheTimeKey);
      if (lastFetchedTime != null &&
          DateTime.now().millisecondsSinceEpoch - lastFetchedTime < 3600000) {
        // If cached data is less than 1 hour old, return cached data
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          print('Returning cached data');
          final cachedArticles =
              List<Map<String, dynamic>>.from(jsonDecode(cachedData));
          return cachedArticles.map((json) => Article.fromJson(json)).toList();
        }
      }

      // 2. If no valid cached data, make an API request to fetch news
      final response = await _dio.get(baseUrl, queryParameters: {
        'q': query,
        'apiKey': apiKey,
        'page': page,
        'pageSize': 20,
      });

      // Check if the response status is successful (200)
      if (response.statusCode == 200) {
        final data = response.data['articles'] as List?;

        // If the 'articles' field is empty or null, do not cache the data
        if (data == null || data.isEmpty) {
          print('No news found in API response, skipping cache');
          throw Exception("No news found");
        }

        // 3. Cache the API response data for future use
        prefs.setString(cacheKey, jsonEncode(data));
        prefs.setInt(cacheTimeKey, DateTime.now().millisecondsSinceEpoch);

        return data.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      if (e is DioException) {
        // If the error is a DioException (network-related issues)
        if (e.type == DioExceptionType.connectionError &&
            e.error != null &&
            e.error.toString().contains('SocketException')) {
          throw Exception('No internet connection');
        } else {
          throw Exception('Failed to load news');
        }
      } else {
        throw Exception("No news found");
      }
    }
  }
}
