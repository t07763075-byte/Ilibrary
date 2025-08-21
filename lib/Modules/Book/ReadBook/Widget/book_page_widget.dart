import 'dart:convert';
import 'package:ELibrary/Models/book_note_model.dart';
import 'package:ELibrary/Models/read_book_style_model.dart';
import 'package:ELibrary/Modules/Book/ReadBook/read_book_controller.dart';
import 'package:ELibrary/Utilities/dialog_helper.dart';
import 'package:ELibrary/Utilities/extensions.dart';
import 'package:ELibrary/core/Caching/cached_images_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/src/common/utils/element_utils/element_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';
import '../../../../Widgets/custom_network_image.dart';
import '../read_book_provider.dart';
import 'package:flutter_html/src/style.dart' as style;

class BookPageWidget extends StatelessWidget {
  final QuillController controller;
  final ScrollController scrollController;
  final ReadBookStyleModel styleModel;
  final Widget Function() contextMenuBuilder;
  final bool disableScroll;
  final String bookUrl;
  final bool disableCustomStyle;
  const BookPageWidget({super.key, required this.controller, required this.styleModel, required this.contextMenuBuilder, required this.scrollController, required this.disableScroll, required this.bookUrl, this.disableCustomStyle = false,});


  @override
  Widget build(BuildContext context) {
    return Container(
      color: styleModel.backgroundColor,
      child: QuillEditor.basic(
        controller: controller,
        scrollController: scrollController,
        configurations: QuillEditorConfigurations(
            showCursor: false,
            customStyles: disableCustomStyle ? null : getUpdatedDefaultStyle(context),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            contextMenuBuilder: (_,QuillRawEditorState q){
              return TextSelectionToolbar(
                anchorAbove: q.contextMenuAnchors.primaryAnchor,
                anchorBelow: q.contextMenuAnchors.secondaryAnchor ?? q.contextMenuAnchors.primaryAnchor,
                children: [contextMenuBuilder(),],
              );
            },
            embedBuilders: [
              CustomImageEmbedBuilder(imageBaseUrl: bookUrl.substring(0,bookUrl.lastIndexOf("/"))),
              const CustomTableEmbedBuilder(),
              const CustomTagIdEmbedBuilder(),
             // if(kIsWeb) ...FlutterQuillEmbeds.editorWebBuilders(
             //   imageEmbedConfigurations: QuillEditorImageEmbedConfigurations(
             //     imageErrorWidgetBuilder: (_,object,stackTrace)=> const SizedBox(),
             //     imageProviderBuilder: (context, imageUrl) => CachedNetworkImageProvider(imageUrl),
             //     onImageClicked: (imageUrl){},
             //   ),
             // ),
             // if(!kIsWeb) ...FlutterQuillEmbeds.editorBuilders(
             //   imageEmbedConfigurations: QuillEditorImageEmbedConfigurations(
             //     imageErrorWidgetBuilder: (_,object,stackTrace)=> const SizedBox(),
             //     imageProviderBuilder: (context, imageUrl) => CachedNetworkImageProvider(imageUrl),
             //     onImageClicked: (imageUrl){},
             //   ),
             // ),
           ],
            onLaunchUrl: (url)async{
              if(url.startsWith("https://note:")){
                ReadBookController().openNoteDialog(BookNoteModel.fromJson(json.decode(url.split("note:")[1])));
              }
              else if(Uri.parse(url).fragment.isNotEmpty) {
                ReadBookController().scrollToElementId(Uri.parse(url).fragment);
              }else if(await canLaunchUrl(Uri.parse(url))){
                 launchUrl(Uri.parse(url));
              }
            },
            scrollPhysics: disableScroll? const NeverScrollableScrollPhysics(): null,
            scrollable: !disableScroll
        ),
      ),
    );
  }

  DefaultTextBlockStyle? getUpdatedStyle(DefaultTextBlockStyle? defaultStyle)=> defaultStyle?.copyWith(style: styleModel.getTextStyle(defaultStyle.style.fontSize));

  DefaultStyles getUpdatedDefaultStyle(BuildContext context){
    DefaultStyles defaultStyles = DefaultStyles.getInstance(context);
   return DefaultStyles(
     h1: getUpdatedStyle(defaultStyles.h1),
     h2: getUpdatedStyle(defaultStyles.h2),
     h3: getUpdatedStyle(defaultStyles.h3),
     h4: getUpdatedStyle(defaultStyles.h4),
     h5: getUpdatedStyle(defaultStyles.h5),
     h6: getUpdatedStyle(defaultStyles.h6),
     lineHeightNormal: getUpdatedStyle(defaultStyles.lineHeightNormal),
     lineHeightTight: getUpdatedStyle(defaultStyles.lineHeightTight),
     lineHeightOneAndHalf: getUpdatedStyle(defaultStyles.lineHeightOneAndHalf),
     lineHeightDouble: getUpdatedStyle(defaultStyles.lineHeightDouble),
     paragraph: getUpdatedStyle(defaultStyles.paragraph),
     placeHolder: getUpdatedStyle(defaultStyles.placeHolder),
     quote: getUpdatedStyle(defaultStyles.quote),
     code: getUpdatedStyle(defaultStyles.code),
     indent: getUpdatedStyle(defaultStyles.indent),
     align: getUpdatedStyle(defaultStyles.align),
     leading: getUpdatedStyle(defaultStyles.leading),
     bold: defaultStyles.bold?.merge(styleModel.getTextStyle(defaultStyles.bold?.fontSize)),
     subscript: defaultStyles.subscript?.merge(styleModel.getTextStyle(defaultStyles.subscript?.fontSize)),
     superscript: defaultStyles.superscript?.merge(styleModel.getTextStyle(defaultStyles.superscript?.fontSize)),
     italic: defaultStyles.italic?.merge(styleModel.getTextStyle(defaultStyles.italic?.fontSize)),
     small: defaultStyles.small?.merge(styleModel.getTextStyle(defaultStyles.small?.fontSize)),
     underline: defaultStyles.underline?.merge(styleModel.getTextStyle(defaultStyles.underline?.fontSize)),
     strikeThrough: defaultStyles.strikeThrough?.merge(styleModel.getTextStyle(defaultStyles.strikeThrough?.fontSize)),
     link: defaultStyles.link?.merge(styleModel.getTextStyle(defaultStyles.link?.fontSize)).merge(const TextStyle(color: Colors.blue,decoration: TextDecoration.none)),
     sizeSmall: defaultStyles.sizeSmall?.merge(styleModel.getTextStyle(defaultStyles.sizeSmall?.fontSize)),
     sizeLarge: defaultStyles.sizeLarge?.merge(styleModel.getTextStyle(defaultStyles.sizeLarge?.fontSize)),
     sizeHuge: defaultStyles.sizeHuge?.merge(styleModel.getTextStyle(defaultStyles.sizeHuge?.fontSize)),


     inlineCode: InlineCodeStyle(
       backgroundColor: Colors.grey.shade100,
       radius: const Radius.circular(3),
       style: defaultStyles.inlineCode!.style.merge(styleModel.getTextStyle(defaultStyles.inlineCode!.style.fontSize)),
       header1: styleModel.getTextStyle(32).copyWith(fontWeight: FontWeight.w500),
       header2: styleModel.getTextStyle(22).copyWith(fontWeight: FontWeight.w500),
       header3: styleModel.getTextStyle(18).copyWith(fontWeight: FontWeight.w500),
     ),
     lists: DefaultListBlockStyle(
       defaultStyles.lists!.style.merge(styleModel.getTextStyle(defaultStyles.lists?.style.fontSize)),
       const HorizontalSpacing(0, 0),
       const VerticalSpacing(6, 0),
       const VerticalSpacing(0, 6),
       null,
       null,
     ),
   );
  }
}

class CustomImageEmbedBuilder extends EmbedBuilder {
  final String imageBaseUrl;
  const CustomImageEmbedBuilder({required this.imageBaseUrl});

  @override
  String get key => BlockEmbed.imageType;
  @override
  bool get expanded => false;
  @override
  Widget build(BuildContext context, QuillController controller, Embed node, bool readOnly, bool inline, TextStyle textStyle) {
   return _BuildImageWidget(node: node,imageBaseUrl: imageBaseUrl,);
  }
}

class _BuildImageWidget extends StatefulWidget {
  final Embed node;
  final String imageBaseUrl;
  const _BuildImageWidget({required this.node, required this.imageBaseUrl});

  @override
  State<_BuildImageWidget> createState() => _BuildImageWidgetState();
}

class _BuildImageWidgetState extends State<_BuildImageWidget> {

  Widget? webImageWidget;
  Uint8List? imageBytes;
  double? width,height;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => init(context));
    super.initState();
  }

  Future init(BuildContext context)async{
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    if(!kIsWeb) imageBytes = await getImageBytes(widget.node.value.data);

    if(!context.mounted) return;
    if(width != null || height != null || imageBytes != null || webImageWidget != null) return;
    final ((imageSize), margin, alignment) = getElementAttributes(widget.node, context,);

    if(imageSize.width != null) width = imageSize.width;
    if(imageSize.height != null) width = imageSize.height;

    if(width == null && height == null && !kIsWeb){
      if(imageBytes == null) return;
      final ui.Image decodedImage = await decodeImageFromList(imageBytes!);
      width = decodedImage.width.toDouble();
      width = decodedImage.width.toDouble();
    }
    if((width??0) > screenWidth) width = screenWidth;
    width = width == null? null: width!* 0.5;

    if((height??0) > screenHeight) height = screenHeight;
    height = height == null? null: height!* 0.5;

    if(kIsWeb){
      width ??= screenWidth/2;
      height ??= screenHeight/2;
    }

    if(kIsWeb) webImageWidget = await getWebImage(widget.node.value.data);
    if (!mounted) return;
    setState(() {});
  }

  Future<Uint8List?> getImageBytes(String imageData)async{
    Uint8List? imageBytes;
    if(imageData.startsWith("http")) imageBytes = await CachedImagesHelper.fetchImageFromCache(imageData);
    if(imageData.startsWith('data:image/')) imageBytes = base64Decode(imageData.split(',').last);
    imageBytes ??= await CachedImagesHelper.fetchImageFromCache("${widget.imageBaseUrl}/$imageData");
    return imageBytes;
  }

  Future<Widget?> getWebImage(String imageData)async{
    if(imageData.startsWith("http")) {
      return CustomNetworkImage(
        url: imageData,
        fit: BoxFit.contain,
        width: width!,
        height: height!,
      );
    }
    if(imageData.startsWith('data:image/')){
      return Image.memory(
        base64Decode(imageData.split(',').last),
        fit: BoxFit.contain,
      );
    }
    return CustomNetworkImage(
      url: "${widget.imageBaseUrl}/$imageData",
      fit: BoxFit.contain,
      width: width!,
      height: height!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ((_), margin, alignment) = getElementAttributes(widget.node, context,);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if(!kIsWeb && imageBytes == null) return;
          if(kIsWeb && webImageWidget == null) return;
          DialogHelper.custom(context: context).customDialogPosition(
            top: 100.h,
            bottom: 100.h,
            dialogWidget: kIsWeb? PhotoView.customChild(child: webImageWidget):
            PhotoView(imageProvider: MemoryImage(imageBytes!),),
          );
        },
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: EdgeInsets.all(margin ?? 0),
            child: kIsWeb? webImageWidget:
            imageBytes == null? const CircularProgressIndicator():
            Image(
              image: MemoryImage(imageBytes!),
              fit: BoxFit.fill,
              width: width,
              height: height,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTableEmbedBuilder extends EmbedBuilder {

  static final Map<String, Widget> tableCache = {};
  static Color _lastFontColor = Colors.transparent;

  const CustomTableEmbedBuilder();

  @override
  String get key => "table";
  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, QuillController controller, Embed node, bool readOnly, bool inline, TextStyle textStyle) {
    return Consumer<ReadBookProvider>(
      builder: (context,rbProvider, _) {
        final String tableId = node.value.data;
        if(_lastFontColor != rbProvider.styleModel.fontColor) {
          _lastFontColor = rbProvider.styleModel.fontColor;
          tableCache.clear();
        }
        if (tableCache[tableId] == null) tableCache[tableId] = CustomTableWidget(tableNode: node, fontColor: _lastFontColor,);
        return tableCache[tableId]!;
      }
    );
  }
}

class CustomTableWidget extends StatefulWidget {
  final Embed tableNode;
  final Color fontColor;
  const CustomTableWidget({super.key, required this.tableNode, required this.fontColor});

  @override
  State<CustomTableWidget> createState() => _CustomTableWidgetState();
}

class _CustomTableWidgetState extends State<CustomTableWidget> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Html(
      data: widget.tableNode.value.data,
      style: {
        "td": style.Style(
          color: widget.fontColor,
        ),
        "tr": style.Style(
          color: widget.fontColor,
        ),
        "a": style.Style(
          color: Colors.blue
        )
      },
      extensions: const [
        TableHtmlExtension(),
      ],
      onLinkTap: (url, attributes, element) async{
        if(url != null && await canLaunchUrl(Uri.parse(url))) launchUrl(Uri.parse(url));
      },
      onAnchorTap: (anchor, attributes, element) {
        if(anchor != null) ReadBookController().scrollToElementId(anchor.replaceAll("#", ""));
      },
    );
  }
}

class CustomTagIdEmbedBuilder extends EmbedBuilder {

  const CustomTagIdEmbedBuilder();

  @override
  String get key => "TagId";
  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, QuillController controller, Embed node, bool readOnly, bool inline, TextStyle textStyle) {
    return const SizedBox();
  }
}