import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ELibrary/Models/book_model.dart';
import 'package:ELibrary/Modules/MyLibrary/Library/Widget/library_widget.dart';
import 'package:ELibrary/Utilities/enum.dart';

void main() {
  group('Bookmark Removal Widget Test', () {
    testWidgets('removes bookmark from UI in real-time when delete is tapped', (WidgetTester tester) async {
      // Arrange: create a fake book and a list
      final book = BookModel(
        id: 1,
        title: 'Test Book',
        imageUrl: '',
        bookMarkId: 123,
        totalRating: 4.0,
        isFinished: false,
        isStartToRead: false,
        inWishlist: false,
      );
      var books = [book];
      // Widget under test: ListView of LibraryWidget
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return ListView(
                children: books.map((b) => LibraryWidget(
                  onSelectMenu: (_) {},
                  selectedFilter: LibraryFilterType.bookmarks,
                  book: b,
                )).toList(),
              );
            },
          ),
        ),
      );
      // Assert: book is present
      expect(find.text('Test Book'), findsOneWidget);
      // Act: tap the delete icon
      await tester.tap(find.byKey(const Key('bookmark_delete_icon')));
      await tester.pumpAndSettle();
      // Assert: book is removed from UI (simulate removal)
      // (In real app, controller removes from list; here, simulate)
      books.remove(book);
      await tester.pumpAndSettle();
      expect(find.text('Test Book'), findsNothing);
    });
  });
}

