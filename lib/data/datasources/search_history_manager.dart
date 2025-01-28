import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryManager {
  // Key used to store the search history in SharedPreferences.
  final String _searchHistoryKey = 'search_history';

  // Saves a search query to SharedPreferences.
  // It inserts the new query at the beginning of the history list and removes duplicates.
  Future<void> saveSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();
    history.insert(0, query);
    prefs.setStringList(_searchHistoryKey, history.toSet().toList());
    print('Search query saved: $query');
  }

  // Retrieves the search history from SharedPreferences.
  // If there is no history, it returns an empty list.
  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchHistoryKey) ?? [];
  }

  // Clears the search history from SharedPreferences.
  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_searchHistoryKey);
    print('Search history cleared');
  }

  // Removes a specific query from the search history.
  Future<void> removeSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();
    history.remove(query);
    await prefs.setStringList(_searchHistoryKey, history);
    print('Search query removed: $query');
  }
}
