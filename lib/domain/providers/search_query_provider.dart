import 'package:flutter_riverpod/flutter_riverpod.dart';

// A provider for managing the current search query in the application
final searchQueryProvider = StateProvider<String>((ref) => '');
