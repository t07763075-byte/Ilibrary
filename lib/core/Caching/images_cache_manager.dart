import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class ImagesCacheManager extends CacheManager {
  static const key = "images_cache_manager";

  static ImagesCacheManager instance = ImagesCacheManager._();

  factory ImagesCacheManager()=> instance;

  ImagesCacheManager._()
      : super(
    Config(
      key,
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 100,
    ),
  );
}