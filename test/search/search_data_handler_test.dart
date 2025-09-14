import 'package:flutter_test/flutter_test.dart';
import 'package:ELibrary/Modules/Search/search_data_handler.dart';
import 'package:ELibrary/core/error/failures.dart';
import 'package:dartz/dartz.dart';

void main() {
  group('SearchDataHandler.deleteSearchHistory', () {
    test('returns Right(true) on success', () async {
      // This test assumes the API call is mocked or will always succeed in test
      final result = await SearchDataHandler.deleteSearchHistory(id: 123);
      expect(result.isRight(), isTrue);
      result.fold((l) => fail('Should not fail'), (r) => expect(r, isTrue));
    });

    // To test failure, you would need to mock GenericRequest or the API layer.
    // This is a placeholder for such a test.
    test('returns Left(Failure) on error', () async {
      // Not implemented: would require dependency injection or a mock API
      // expect(...)
    });
  });
}

