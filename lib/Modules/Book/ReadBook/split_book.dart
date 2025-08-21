import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'ReadBookDataHandler/manager_data_handler.dart';
import 'html_manipulation_helper.dart';

class SplitBookHelper{

  static Future<List<QuillController>> getBookPages({required String bookUrl,}) async {
    String? htmlBool = await ReadBookDataHandlerManage.getHtmlFromUrl(url: bookUrl);
    if(htmlBool == null) return [];

    QuillController originalController = QuillController(
      document: Document.fromDelta(
        HtmlToDelta(
            replaceNormalNewLinesToBr: true,
            customBlocks: [TableCustomHtmlPart(),CustomTagIdHtmlPart()]
        ).convert(HtmlManipulationHelper.applyPageConfiguration(0, htmlBool)),
      ),
      readOnly: true,
      selection: const TextSelection.collapsed(offset: 0),
    );
    return _splitQuillControllerByWords(
      originalController: originalController,
      wordLimit: 150,
      nOfWordForEmptyLine: 6
    );
  }

  static List<QuillController> _splitQuillControllerByWords({
    required QuillController originalController,
    required int wordLimit,
    required int nOfWordForEmptyLine,
  }) {
    final originalDocument = originalController.document;
    final delta = originalDocument.toDelta();

    // Store controllers to return
    final List<QuillController> controllers = [];

    Delta chunkDelta = Delta(); // Delta for the current chunk
    int chunkWordCount = 0; // Words in the current chunk
    String currentWordBuffer = ""; // Buffer to collect words across operations

    // Iterate through the operations in the delta
    for (final operation in delta.operations) {
      if (operation.key == 'insert' && operation.value is String) {
        final text = operation.value as String;

        for (int i = 0; i < text.length; i++) {
          final char = text[i];

          if (char == '\n') {
            // Treat empty lines as equivalent to six words
            if (currentWordBuffer.isNotEmpty) {
              chunkWordCount++;
              chunkDelta.push(Operation.insert(currentWordBuffer, operation.attributes));
              currentWordBuffer = ""; // Reset the buffer
            }

            chunkWordCount += nOfWordForEmptyLine; // Count empty line as six words
            chunkDelta.push(Operation.insert(char, operation.attributes));

            // Check if the word limit is reached
            if (chunkWordCount >= wordLimit) {
              // Save the chunk as a new controller
              controllers.add(QuillController(
                document: Document.fromDelta(chunkDelta..push(Operation.insert('\n'))),
                readOnly: true,
                selection: const TextSelection.collapsed(offset: 0),
              ));

              // Reset for the next chunk
              chunkDelta = Delta();
              chunkWordCount = 0;
            }
          } else if (char == " ") {
            // Word boundary detected
            if (currentWordBuffer.isNotEmpty) {
              chunkWordCount++;
              chunkDelta.push(Operation.insert(currentWordBuffer, operation.attributes));
              currentWordBuffer = ""; // Reset the buffer

              // Check if the word limit is reached
              if (chunkWordCount >= wordLimit) {
                // Save the chunk as a new controller
                controllers.add(QuillController(
                  document: Document.fromDelta(chunkDelta..push(Operation.insert('\n'))),
                  readOnly: true,
                  selection: const TextSelection.collapsed(offset: 0),
                ));

                // Reset for the next chunk
                chunkDelta = Delta();
                chunkWordCount = 0;
              }
            }

            // Insert the whitespace
            chunkDelta.push(Operation.insert(char, operation.attributes));
          } else {
            // Add character to the current word buffer
            currentWordBuffer += char;
          }
        }
      } else {
        // Handle non-text operations (images, videos, etc.)
        chunkDelta.push(operation);
      }
    }

    // Handle any remaining buffered word
    if (currentWordBuffer.isNotEmpty) {
      chunkDelta.push(Operation.insert(currentWordBuffer));
      chunkWordCount++;
    }

    // Ensure the last chunk is saved if not empty
    if (chunkWordCount > 0) {
      if (!(chunkDelta.last.value as String).endsWith('\n')) {
        chunkDelta.push(Operation.insert('\n'));
      }
      controllers.add(QuillController(
        document: Document.fromDelta(chunkDelta..push(Operation.insert('\n'))),
        readOnly: true,
        selection: const TextSelection.collapsed(offset: 0),
      ));
    }

    return controllers;
  }

// static List<QuillController> _splitQuillControllerByWords({
  //   required QuillController originalController,
  //   required int wordLimit,
  // }) {
  //   final originalDocument = originalController.document;
  //   final delta = originalDocument.toDelta();
  //
  //   // Store controllers to return
  //   final List<QuillController> controllers = [];
  //
  //   Delta chunkDelta = Delta(); // Delta for the current chunk
  //   int chunkWordCount = 0; // Words in the current chunk
  //   String currentWordBuffer = ""; // Buffer to collect words across operations
  //
  //   // Iterate through the operations in the delta
  //   for (final operation in delta.operations) {
  //     if (operation.key == 'insert' && operation.value is String) {
  //       final text = operation.value as String;
  //
  //       // Process the text in the operation
  //       for (int i = 0; i < text.length; i++) {
  //         final char = text[i];
  //
  //         if (char == ' ') {
  //           // Word boundary detected
  //           if (currentWordBuffer.isNotEmpty) {
  //             chunkWordCount++;
  //             chunkDelta.push(Operation.insert(currentWordBuffer, operation.attributes));
  //             currentWordBuffer = ""; // Reset the buffer
  //
  //             // Check if the word limit is reached
  //             if (chunkWordCount >= wordLimit) {
  //               // Save the chunk as a new controller
  //               controllers.add(QuillController(
  //                 document: Document.fromDelta(chunkDelta..push(Operation.insert('\n'))),
  //                 readOnly: true,
  //                 selection: const TextSelection.collapsed(offset: 0),
  //               ));
  //
  //               // Reset for the next chunk
  //               chunkDelta = Delta();
  //               chunkWordCount = 0;
  //             }
  //           }
  //
  //           // Insert the whitespace
  //           chunkDelta.push(Operation.insert(char, operation.attributes));
  //         } else {
  //           // Add character to the current word buffer
  //           currentWordBuffer += char;
  //         }
  //       }
  //     } else {
  //       // Handle non-text operations (images, videos, etc.)
  //       chunkDelta.push(operation);
  //     }
  //   }
  //
  //   // Handle any remaining buffered word
  //   if (currentWordBuffer.isNotEmpty) {
  //     chunkDelta.push(Operation.insert(currentWordBuffer));
  //     chunkWordCount++;
  //   }
  //
  //   // Ensure the last chunk is saved if not empty
  //   if (chunkWordCount > 0) {
  //     if (!(chunkDelta.last.value as String).endsWith('\n')) {
  //       chunkDelta.push(Operation.insert('\n'));
  //     }
  //     controllers.add(QuillController(
  //       document: Document.fromDelta(chunkDelta..push(Operation.insert('\n'))),
  //       readOnly: true,
  //       selection: const TextSelection.collapsed(offset: 0),
  //     ));
  //   }
  //
  //   return controllers;
  // }
}