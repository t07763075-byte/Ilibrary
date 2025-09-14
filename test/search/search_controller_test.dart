import 'package:flutter_test/flutter_test.dart';
import 'package:ELibrary/Modules/Search/search_controller.dart';
import 'package:ELibrary/Models/search_history_model.dart';
import 'package:ELibrary/Models/generic_pagination_model.dart';
import 'package:dartz/dartz.dart';
import 'package:ELibrary/Modules/Search/search_data_handler.dart';
import 'package:ELibrary/core/error/failures.dart';

class MockSearchDataHandler extends SearchDataHandler {
  static bool shouldFail = false;
  static bool deleteCalled = false;
  static int? lastDeletedId;

  static void reset() {
    shouldFail = false;
    deleteCalled = false;
    lastDeletedId = null;
  }

  static @override
  Future<Either<Failure, bool>> deleteSearchHistory({int? id}) async {
    deleteCalled = true;
    lastDeletedId = id;
    if (shouldFail) {
      return Left(ServerFailure('Delete failed'));
    }
    return const Right(true);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SearchController.deleteSearchHistory', () {
    late SearchController controller;
    late SearchHistoryModel item;

    setUp(() {
      controller = SearchController();
      controller.searchHistory = GenericPaginationModel<SearchHistoryModel>(
        data: [],
      );
      item = SearchHistoryModel(id: 1, searchKeyword: 'test');
      controller.searchHistory.data.add(item);
      MockSearchDataHandler.reset();
    });

    test('removes item from searchHistory.data on success', () async {
      // Patch the static method
      final original = SearchDataHandler.deleteSearchHistory;
      SearchDataHandler.deleteSearchHistory = MockSearchDataHandler.deleteSearchHistory;
      await controller.deleteSearchHistory(item);
      expect(controller.searchHistory.data.contains(item), isFalse);
      expect(MockSearchDataHandler.deleteCalled, isTrue);
      expect(MockSearchDataHandler.lastDeletedId, item.id);
      // Restore
      SearchDataHandler.deleteSearchHistory = original;
    });

    test('does not remove item if delete fails', () async {
      MockSearchDataHandler.shouldFail = true;
      final original = SearchDataHandler.deleteSearchHistory;
      SearchDataHandler.deleteSearchHistory = MockSearchDataHandler.deleteSearchHistory;
      await controller.deleteSearchHistory(item);
      expect(controller.searchHistory.data.contains(item), isTrue);
      expect(MockSearchDataHandler.deleteCalled, isTrue);
      // Restore
      SearchDataHandler.deleteSearchHistory = original;
    });
  });
}

