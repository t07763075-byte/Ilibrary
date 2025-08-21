import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../Utilities/theme_helper.dart';
import '../generated/assets.dart';
import 'package:image_network/image_network.dart';


class CustomNetworkImage extends StatelessWidget {
  final String? url;
  final double? radius;
  final double width, height;
  final BoxFit fit;
  final bool enableExpandImage;

  BoxFitWeb getBoxFitWebFromFit(BoxFit fit){
    return switch(fit){
      BoxFit.fill => BoxFitWeb.fill,
      BoxFit.contain => BoxFitWeb.contain,
      BoxFit.cover => BoxFitWeb.cover,
      _=> BoxFitWeb.contain,
    };
  }

  const CustomNetworkImage({
    Key? key,
    required this.url,
    required this.width,
    required this.height,
    this.radius,
    this.fit = BoxFit.cover,
    this.enableExpandImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(radius ?? 8.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 8.r),
          child: SvgPicture.asset(
            Assets.imagesLandscapePlaceholder,
            width: width,
            height: height,
            fit: fit,
          ),
        ),
      );
    }

    Widget networkImage = Image(
      image: CachedNetworkImageProvider(
        url!,
      ),
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        if (loadingProgress.expectedTotalBytes == null) {
          return SizedBox(
            height: height,
            width: width,
            child: Center(
              child: CircularProgressIndicator(
                color: ThemeClass.of(context).primaryColor,
              ),
            ),
          );
        }
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: ThemeClass.of(context).backGroundColor,
            borderRadius: BorderRadius.circular(radius ?? 8.r),
          ),
          alignment: Alignment.center,
          child: CircularProgressIndicator(
              color: ThemeClass.of(context).primaryColor,
              value: loadingProgress.expectedTotalBytes == null
                  ? null
                  : loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!),
        );
      },
      errorBuilder: (context, error, _) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: ThemeClass.of(context).backGroundColor,
            borderRadius: BorderRadius.circular(radius ?? 8.r),
            border: radius == null? null : Border.all()
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.broken_image_outlined,
            color: ThemeClass.of(context).primaryColor,
            size: height == double.infinity ? null : height / 3,
          ),
        );
      },
    );
    if(kIsWeb) {
      networkImage = IgnorePointer(
        ignoring: true,
        child: ImageNetwork(
          image: url!,
          width: width,
          height: height,
          fitAndroidIos: fit,
          fitWeb: getBoxFitWebFromFit(fit),
          onLoading: Center(
            child: CircularProgressIndicator(
              color: ThemeClass.of(context).primaryColor,
            ),
          ),
          onError: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: ThemeClass.of(context).backGroundColor,
              borderRadius: BorderRadius.circular(radius ?? 8.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.broken_image_outlined,
              color: ThemeClass.of(context).primaryColor,
              size: height == double.infinity ? null : height / 3,
            ),
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 8.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 8.r),
        child: enableExpandImage
            ? InstaImageViewer(
                child: networkImage,
              )
            : networkImage,
      ),
    );
  }
}
