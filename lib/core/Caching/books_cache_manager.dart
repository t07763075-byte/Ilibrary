import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class BooksCacheManager extends CacheManager {
  static const key = "books_cache_manager";

  static BooksCacheManager instance = BooksCacheManager._();

  factory BooksCacheManager()=> instance;

  BooksCacheManager._()
      : super(
    Config(
      key,
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 20,
    ),
  );
}