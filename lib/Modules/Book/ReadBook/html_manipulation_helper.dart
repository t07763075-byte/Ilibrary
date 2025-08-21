import 'dart:developer';
import 'dart:isolate';
import 'package:collection/collection.dart';
import 'package:dart_quill_delta/src/operation/operation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill_delta_from_html/parser/custom_html_part.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:provider/provider.dart';

import '../../../Utilities/router_config.dart';

class BookProcessingProvider extends ChangeNotifier{
  int? totalPages, processingPage;

  void updateTotalPages({required int? totalPages,}){
    this.totalPages = totalPages;
    notifyListeners();
  }

  void updateProcessingPage({required int? processingPage,}){
    this.processingPage = processingPage;
    _checkIfLast();
    notifyListeners();
  }

  Future _checkIfLast() async{
    if(processingPage == totalPages && totalPages != null){
      Future.delayed(const Duration(seconds: 1));
      updateProcessingPage(processingPage: null);
      updateTotalPages(totalPages: null);
    }
  }

}

class HtmlManipulationHelper{
  static const String? separateIdName = null; // "pg-start-separator";
  static const _namedColors = {
    'aliceblue': '#F0F8FF',
    'antiquewhite': '#FAEBD7',
    'aqua': '#00FFFF',
    'aquamarine': '#7FFFD4',
    'azure': '#F0FFFF',
    'beige': '#F5F5DC',
    'bisque': '#FFE4C4',
    'black': '#000000',
    'blanchedalmond': '#FFEBCD',
    'blue': '#0000FF',
    'blueviolet': '#8A2BE2',
    'brown': '#A52A2A',
    'burlywood': '#DEB887',
    'cadetblue': '#5F9EA0',
    'chartreuse': '#7FFF00',
    'chocolate': '#D2691E',
    'coral': '#FF7F50',
    'cornflowerblue': '#6495ED',
    'cornsilk': '#FFF8DC',
    'crimson': '#DC143C',
    'cyan': '#00FFFF',
    'darkblue': '#00008B',
    'darkcyan': '#008B8B',
    'darkgoldenrod': '#B8860B',
    'darkgray': '#A9A9A9',
    'darkgreen': '#006400',
    'darkkhaki': '#BDB76B',
    'darkmagenta': '#8B008B',
    'darkolivegreen': '#556B2F',
    'darkorange': '#FF8C00',
    'darkorchid': '#9932CC',
    'darkred': '#8B0000',
    'darksalmon': '#E9967A',
    'darkseagreen': '#8FBC8F',
    'darkslateblue': '#483D8B',
    'darkslategray': '#2F4F4F',
    'darkturquoise': '#00CED1',
    'darkviolet': '#9400D3',
    'deeppink': '#FF1493',
    'deepskyblue': '#00BFFF',
    'dimgray': '#696969',
    'dodgerblue': '#1E90FF',
    'firebrick': '#B22222',
    'floralwhite': '#FFFAF0',
    'forestgreen': '#228B22',
    'fuchsia': '#FF00FF',
    'gainsboro': '#DCDCDC',
    'ghostwhite': '#F8F8FF',
    'gold': '#FFD700',
    'goldenrod': '#DAA520',
    'gray': '#808080',
    'green': '#008000',
    'greenyellow': '#ADFF2F',
    'honeydew': '#F0FFF0',
    'hotpink': '#FF69B4',
    'indianred': '#CD5C5C',
    'indigo': '#4B0082',
    'ivory': '#FFFFF0',
    'khaki': '#F0E68C',
    'lavender': '#E6E6FA',
    'lavenderblush': '#FFF0F5',
    'lawngreen': '#7CFC00',
    'lemonchiffon': '#FFFACD',
    'lightblue': '#ADD8E6',
    'lightcoral': '#F08080',
    'lightcyan': '#E0FFFF',
    'lightgoldenrodyellow': '#FAFAD2',
    'lightgray': '#D3D3D3',
    'lightgreen': '#90EE90',
    'lightpink': '#FFB6C1',
    'lightsalmon': '#FFA07A',
    'lightseagreen': '#20B2AA',
    'lightskyblue': '#87CEFA',
    'lightslategray': '#778899',
    'lightsteelblue': '#B0C4DE',
    'lightyellow': '#FFFFE0',
    'lime': '#00FF00',
    'limegreen': '#32CD32',
    'linen': '#FAF0E6',
    'magenta': '#FF00FF',
    'maroon': '#800000',
    'mediumaquamarine': '#66CDAA',
    'mediumblue': '#0000CD',
    'mediumorchid': '#BA55D3',
    'mediumpurple': '#9370DB',
    'mediumseagreen': '#3CB371',
    'mediumslateblue': '#7B68EE',
    'mediumspringgreen': '#00FA9A',
    'mediumturquoise': '#48D1CC',
    'mediumvioletred': '#C71585',
    'midnightblue': '#191970',
    'mintcream': '#F5FFFA',
    'mistyrose': '#FFE4E1',
    'moccasin': '#FFE4B5',
    'navajowhite': '#FFDEAD',
    'navy': '#000080',
    'oldlace': '#FDF5E6',
    'olive': '#808000',
    'olivedrab': '#6B8E23',
    'orange': '#FFA500',
    'orangered': '#FF4500',
    'orchid': '#DA70D6',
    'palegoldenrod': '#EEE8AA',
    'palegreen': '#98FB98',
    'paleturquoise': '#AFEEEE',
    'palevioletred': '#DB7093',
    'papayawhip': '#FFEFD5',
    'peachpuff': '#FFDAB9',
    'peru': '#CD853F',
    'pink': '#FFC0CB',
    'plum': '#DDA0DD',
    'powderblue': '#B0E0E6',
    'purple': '#800080',
    'rebeccapurple': '#663399',
    'red': '#FF0000',
    'rosybrown': '#BC8F8F',
    'royalblue': '#4169E1',
    'saddlebrown': '#8B4513',
    'salmon': '#FA8072',
    'sandybrown': '#F4A460',
    'seagreen': '#2E8B57',
    'seashell': '#FFF5EE',
    'sienna': '#A0522D',
    'silver': '#C0C0C0',
    'skyblue': '#87CEEB',
    'slateblue': '#6A5ACD',
    'slategray': '#708090',
    'snow': '#FFFAFA',
    'springgreen': '#00FF7F',
    'steelblue': '#4682B4',
    'tan': '#D2B48C',
    'teal': '#008080',
    'thistle': '#D8BFD8',
    'tomato': '#FF6347',
    'turquoise': '#40E0D0',
    'violet': '#EE82EE',
    'wheat': '#F5DEB3',
    'white': '#FFFFFF',
    'whitesmoke': '#F5F5F5',
    'yellow': '#FFFF00',
    'yellowgreen': '#9ACD32',
  };

  static String _convertNamedColorsToHex(String style) {
    final regex = RegExp(r'(color\s*:\s*)([a-zA-Z]+)(;|$)');
    return style.replaceAllMapped(regex, (match) {
      final property = match.group(1) ?? '';
      final colorName = match.group(2)?.toLowerCase() ?? '';
      final suffix = match.group(3) ?? '';

      if (_namedColors[colorName] != null) return '$property${_namedColors[colorName]}$suffix';
      return match.group(0)!; // Return the original match if no conversion is found
    });
  }

  static String _removeWebsiteInfo(String html, {required String separateIdName}) {
    Document document = html_parser.parse(html);
    Element? body = document.body;
    if (body == null) return html;

    bool findAndRemove(Node node) {
      if (node is Element && node.id == separateIdName) {
        node.children.clear();
        node.remove();
        return true;
      }

      if (node is Element) {
        for (var child in node.nodes.toList()) {
          if (findAndRemove(child)) {
            return true;
          }
        }
      }
      node.children.clear();
      node.remove();
      return false;
    }

    findAndRemove(body);
    return document.outerHtml;
  }

  static String _extractTableFromHtml(String htmlContent) {
    // Parse the HTML
    var document = html_parser.parse(htmlContent);

    // Find the table and remove it from the parent
    var table = document.querySelector('table');
    if (table != null && table.parent != null) {
      // Remove the table from its parent
      table.remove();
      // Optionally, append the table outside the parent
      document.body?.append(table); // This will move the table outside the div
    }

    // Return the modified HTML as a string
    return document.outerHtml;
  }

  static String _applyHtmlIdsStyle(String html) {
    // Parse the HTML
    final document = html_parser.parse(html);

    // Collect all <style> contents
    final styleElements = document.getElementsByTagName('style');
    final idStyles = <String, Map<String, String>>{};

    // Parse CSS rules for IDs from all <style> blocks
    final regex = RegExp(r'\#([\w\-]+)\s*\{([^}]*)\}', dotAll: true);
    for (final styleElement in styleElements) {
      final styleContent = styleElement.innerHtml;

      for (final match in regex.allMatches(styleContent)) {
        final id = match.group(1)?.trim() ?? '';
        var declarations = match.group(2)?.trim() ?? '';

        // Convert named colors to hex (if needed)
        declarations = _convertNamedColorsToHex(declarations);

        // Parse individual CSS declarations
        final declarationMap = <String, String>{};
        for (final declaration in declarations.split(';')) {
          final parts = declaration.split(':');
          if (parts.length == 2) {
            declarationMap[parts[0].trim()] = parts[1].trim();
          }
        }

        // Store styles for the ID
        idStyles[id] = declarationMap;
      }
    }

    // Remove all <style> blocks
    for (var style in styleElements) {
      style.remove();
    }

    // Apply the ID styles inline to matching elements
    for (final id in idStyles.keys) {
      final element = document.getElementById(id);
      if (element != null) {
        // Existing inline styles
        final currentStyle = element.attributes['style'] ?? '';

        // Merge new styles with existing ones
        final mergedStyle = <String, String>{};

        // Parse current styles
        for (final declaration in currentStyle.split(';')) {
          final parts = declaration.split(':');
          if (parts.length == 2) {
            mergedStyle[parts[0].trim()] = parts[1].trim();
          }
        }

        // Add/overwrite with new styles
        for (final key in idStyles[id]!.keys) {
          mergedStyle[key] = idStyles[id]![key]!;
        }

        // Set merged style
        element.attributes['style'] = mergedStyle.entries.map((e) => '${e.key}:${e.value}').join('; ').trim();
      }
    }

    return document.body?.innerHtml ?? html;
  }

  static String _applyHtmlClassesStyle(String html) {
    // Parse the HTML
    final document = html_parser.parse(html);

    // Collect all <style> contents
    final styleElements = document.getElementsByTagName('style');
    final classStyles = <String, Map<String, String>>{};

    // Parse CSS rules for classes from all <style> blocks
    final classRegex = RegExp(r'\.([\w\-]+)\s*\{([^}]*)\}', dotAll: true);
    for (final styleElement in styleElements) {
      final styleContent = styleElement.innerHtml;

      for (final match in classRegex.allMatches(styleContent)) {
        final className = match.group(1)?.trim() ?? '';
        var declarations = match.group(2)?.trim() ?? '';

        // Convert named colors to hex (if needed)
        declarations = _convertNamedColorsToHex(declarations);

        // Parse individual CSS declarations
        final declarationMap = <String, String>{};
        for (final declaration in declarations.split(';')) {
          final parts = declaration.split(':');
          if (parts.length == 2) {
            declarationMap[parts[0].trim()] = parts[1].trim();
          }
        }

        // Store styles for the class
        classStyles[className] = declarationMap;
      }
    }

    // Remove all <style> blocks
    for (var style in styleElements) {
      style.remove();
    }

    // Apply the class styles inline to matching elements
    for (final className in classStyles.keys) {
      final elements = document.getElementsByClassName(className);
      for (final element in elements) {
        // Existing inline styles
        final currentStyle = element.attributes['style'] ?? '';

        // Merge new styles with existing ones
        final mergedStyle = <String, String>{};

        // Parse current styles
        for (final declaration in currentStyle.split(';')) {
          final parts = declaration.split(':');
          if (parts.length == 2) {
            mergedStyle[parts[0].trim()] = parts[1].trim();
          }
        }

        // Add/overwrite with new styles
        for (final key in classStyles[className]!.keys) {
          mergedStyle[key] = classStyles[className]![key]!;
        }

        // Set merged style
        element.attributes['style'] = mergedStyle.entries.map((e) => '${e.key}:${e.value}').join('; ').trim();
      }
    }

    return document.body?.innerHtml ?? html;
  }

  static String _applyStylesToTags(String html) {
    // Parse the HTML
    final document = html_parser.parse(html);

    // Collect all <style> contents
    final styleElements = document.getElementsByTagName('style');
    final styles = <String, Map<String, String>>{};

    // Parse CSS rules from all <style> blocks
    final regex = RegExp(r'([\w\.\#\-,\s]+)\s*\{([^}]*)\}', dotAll: true);
    for (final styleElement in styleElements) {
      final styleContent = styleElement.innerHtml;

      for (final match in regex.allMatches(styleContent)) {
        final selectorGroup = match.group(1)?.trim() ?? '';
        var declarations = match.group(2)?.trim() ?? '';

        // Remove "all: initial;" if present
        declarations = declarations.replaceAll(RegExp(r'\ball\s*:\s*initial\s*;?'), '');

        // Convert named colors to hex
        declarations = _convertNamedColorsToHex(declarations);

        // Parse individual CSS declarations
        final declarationMap = <String, String>{};
        for (final declaration in declarations.split(';')) {
          final parts = declaration.split(':');
          if (parts.length == 2) {
            declarationMap[parts[0].trim()] = parts[1].trim();
          }
        }

        // Handle grouped selectors (e.g., "h1, h2, h3")
        final selectors = selectorGroup.split(',').map((s) => s.trim());
        for (final selector in selectors) {
          // Merge styles for the same selector
          if (styles.containsKey(selector)) {
            styles[selector]!.addAll(declarationMap);
          } else {
            styles[selector] = declarationMap;
          }
        }
      }
    }

    // Remove all <style> blocks
    for (var style in styleElements) {
      style.remove();
    }

    // Apply the styles inline to matching elements
    for (final selector in styles.keys) {
      if(selector.isEmpty) continue;
      final elements = document.querySelectorAll(selector);
      for (final element in elements) {
        // Existing inline styles
        final currentStyle = element.attributes['style'] ?? '';

        // Merge new styles with existing ones
        final mergedStyle = <String, String>{};

        // Parse current styles
        for (final declaration in currentStyle.split(';')) {
          final parts = declaration.split(':');
          if (parts.length == 2) {
            mergedStyle[parts[0].trim()] = parts[1].trim();
          }
        }

        // Add/overwrite with new styles
        for (final key in styles[selector]!.keys) {
          mergedStyle[key] = styles[selector]![key]!;
        }

        // Set merged style
        element.attributes['style'] = mergedStyle.entries.map((e) => '${e.key}:${e.value}').join('; ').trim();
      }
    }

    return document.body?.innerHtml ?? html;
  }

  static String _ensureHtmlCompatible(String htmlContent) {
    // remove duplicated <br> tags
    htmlContent = htmlContent.replaceAll(RegExp(r'(<\s*br\s*/?>\s*){2,}', caseSensitive: false), '<br>');
    // remove duplicated <hr> tags
    htmlContent = htmlContent.replaceAll(RegExp(r'(<\s*br\s*/?>\s*){2,}', caseSensitive: false), '<hr>');
    //replace pre tag witch is not editable with editable tag div
    htmlContent = _replacePreTags(htmlContent,"p");
    // replace section tag with div
    htmlContent = htmlContent.replaceAll(RegExp(r'<\s*section\b[^>]*>'), '<div>');
    htmlContent = htmlContent.replaceAll(RegExp(r'</\s*section\s*>'), '</div>');
    // replace figure tag with div
    htmlContent = htmlContent.replaceAll(RegExp(r'<\s*figure\b[^>]*>'), '<div>');
    htmlContent = htmlContent.replaceAll(RegExp(r'</\s*figure\s*>'), '</div>');
    // remove line spaces
    htmlContent = htmlContent.replaceAll(RegExp(r'\s{2,}'), ' ');
    // solve center of the text if there is a br tag onside
    htmlContent = htmlContent.replaceAllMapped(RegExp(r'<p([^>]*)>(.*?)<br>(.*?)<\/p>', dotAll: true), (match) => '<p${match.group(1)}>${match.group(2)}${match.group(3)}</p><br>');
    // add newline to end for div,p tags
    htmlContent = htmlContent.replaceAll('</div>', '</div><br>');
    htmlContent = htmlContent.replaceAll('</p>', '</p><br>');
    // remove duplicated <br> tags
    htmlContent = htmlContent.replaceAll(RegExp(r'(<\s*br\s*/?>\s*){2,}', caseSensitive: false), '<br>');

    // remove last <br> tags
    for(int _ in [1,2]){
      int lastBrIndex = htmlContent.lastIndexOf("<br>");
      if(lastBrIndex != -1) htmlContent = htmlContent.replaceRange(lastBrIndex,lastBrIndex+4, '');
    }
    return htmlContent.trim();
  }

  static String _replacePreTags(String html, String replacementTag) {
    // Parse the HTML
    final document = html_parser.parse(html);

    // Recursive function to traverse and replace <pre> tags
    void traverseAndReplace(Element element) {
      // Replace <pre> tags
      for (final child in element.children.toList()) {
        if (child.localName == 'pre') {
          // Create a new element with the replacement tag
          final newElement = Element.tag(replacementTag);
          // Copy the content of the <pre> tag
          newElement.text = child.text;
          // Replace the <pre> tag with the new element
          child.replaceWith(newElement);
        } else {
          // Recursively process child elements
          traverseAndReplace(child);
        }
      }
    }

    // Start the traversal from the root element
    final body = document.body;
    if (body != null) {
      traverseAndReplace(body);
    }

    // Return the modified HTML
    return document.body?.innerHtml ?? html;
  }

  static List<String> _replaceAnchorTagWithPageNumber(List<String> pages) {
    // Step 1: Build an index of all IDs -> page index
    final Map<String, int> elementIdToPageIndex = {};

    final parsedDocuments = <int, Document>{};

    for (int i = 0; i < pages.length; i++) {
      final document = html_parser.parse(pages[i]);
      parsedDocuments[i] = document;

      final allElementsWithId = document.querySelectorAll('[id]');
      for (final element in allElementsWithId) {
        final id = element.id;
        if (id.isNotEmpty) {
          elementIdToPageIndex[id] = i;
        }
      }
    }

    // Step 2: Replace anchor hrefs using the index
    List<String> updatedPages = [];

    for (int i = 0; i < pages.length; i++) {
      final document = parsedDocuments[i];
      if(document == null) continue;
      final anchors = document.getElementsByTagName('a');
      for (final anchor in anchors) {
        final href = anchor.attributes['href'];
        if (href != null && href.startsWith('#')) {
          final targetId = href.substring(1);
          final targetPageIndex = elementIdToPageIndex[targetId];
          if (targetPageIndex != null) {
            anchor.attributes['href'] = '#toPage:$targetPageIndex';
          }
        }
      }

      updatedPages.add(document.outerHtml);
    }

    return updatedPages;
  }

  @pragma('vm:entry-point')
  static Future<void> getPagesFromHtmlBook(Map<String,dynamic> data)async{
    String htmlBook = data['htmlBook'];
    SendPort port = data["port"];
    log("<><><> INIT call getPagesFromHtmlBook <><><>");
    // List<String> result = [];
    String pageHtmlStart = htmlBook.split("<body>")[0];
    String pageHtmlEnd = htmlBook.split("</body>")[1];

    htmlBook = htmlBook.split("<body>")[1].split("</body>")[0];

    final pageRegex = RegExp(r"<div[^>]*class='page-break'[^>]*>.*?</div>", multiLine: true, dotAll: true,);

    List<String> sections = htmlBook.split(pageRegex);
    if(sections.first.trim().isEmpty) sections.removeAt(0);
    if(sections.last.trim().isEmpty) sections.removeLast();

    if(currentContext_ != null){
      final bookProcessingProvider = Provider.of<BookProcessingProvider>(currentContext_!, listen: false);
      bookProcessingProvider.updateTotalPages(totalPages: sections.length);
    }

    sections = _replaceAnchorTagWithPageNumber(sections);
    List<String> pages = sections.map((page)=> "$pageHtmlStart<body>$page</body>$pageHtmlEnd").toList();
    List<String> result =  pages.mapIndexed((int index,String page){
      port.send({"progress": {
        "totalPages": sections.length,
        "processingPage": index + 1,
      }});
      return applyPageConfiguration(index,page);
    }).toList();
    port.send({"result": result});
  }




  static String applyPageConfiguration(int index, String htmlPage){
    if(currentContext_ != null){
      final bookProcessingProvider = Provider.of<BookProcessingProvider>(currentContext_!, listen: false);
      bookProcessingProvider.updateProcessingPage(processingPage: index+1);
    }

    String resultHtml = htmlPage;
    if(separateIdName != null) resultHtml = _removeWebsiteInfo(resultHtml,separateIdName: separateIdName!);
    resultHtml = _extractTableFromHtml(resultHtml);
    resultHtml = _applyStylesToTags(resultHtml);
    resultHtml = _applyHtmlIdsStyle(resultHtml);
    resultHtml = _applyHtmlClassesStyle(resultHtml);
    resultHtml = _ensureHtmlCompatible(resultHtml);
    return resultHtml;
  }
}

class TableCustomHtmlPart extends CustomHtmlPart{

  @override
  List<Operation> convert(Element element, {Map<String, dynamic>? currentAttributes}) {
    return [Operation.insert({"table": element.outerHtml})];
  }

  @override
  bool matches(Element element) => element.localName == 'table';
}

class CustomTagIdHtmlPart extends CustomHtmlPart{

  @override
  List<Operation> convert(Element element, {Map<String, dynamic>? currentAttributes}) {
    Element? result = searchForId(element);
    return [Operation.insert({"TagId": result}),];
  }

  @override
  bool matches(Element element) {
    if(element.id.isNotEmpty) return true;
    if(element.children.isEmpty) return false;

    return element.children.any((e)=> matches(e));
  }

  Element? searchForId(Element element) {
    // Check the current element for a non-empty ID
    if (element.id.isNotEmpty) {
      return element;
    }

    // Recursively search in children
    for (Element child in element.children) {
      Element? result = searchForId(child);
      if (result != null) {
        return result;
      }
    }

    // If no element with an ID is found, return null
    return null;
  }
}