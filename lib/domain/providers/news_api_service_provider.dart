import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/news_api_service.dart';

// Provider for the NewsApiService, which handles the network requests for fetching news
final newsApiServiceProvider = Provider<NewsApiService>((ref) {
  return NewsApiService(Dio());
});
