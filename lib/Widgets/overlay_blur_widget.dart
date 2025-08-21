import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Utilities/bottom_sheet_helper.dart';

class OverlayBlurWidget extends StatelessWidget {
  final Widget child;
  const OverlayBlurWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomSheetVisibilityProvider>(
      builder: (context, bsvProvider, _) {
        return Stack(
          children: [
            child,
            if (bsvProvider.isOpen)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.r, sigmaY: 4.r),
                child: Container(
                  color: Colors.transparent, // Optional dimming
                ),
              ),
          ],
        );
      }
    );
  }
}
