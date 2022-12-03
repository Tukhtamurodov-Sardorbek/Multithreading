import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:multithreading/components/shape.dart';
import 'package:screenshot/screenshot.dart';

class ReceiptContainer extends StatelessWidget {
  final Widget? child;

  ReceiptContainer({Key? key, this.child}) : super(key: key);

  final screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: const ResponsiveCustomShapeBorder(horizontalPadding: 16),
        shadows: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 6,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget emptyReceipt({required double height, required double width}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: const ResponsiveCustomShapeBorder(horizontalPadding: 16),
          shadows: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> capture(BuildContext context, {required double height, required double width}) async {
    final Uint8List image = await screenshotController.captureFromWidget(
      emptyReceipt(height: height, width: width),
      delay: Duration.zero,
      pixelRatio: MediaQuery.of(context).devicePixelRatio + 2,
    );
    return image;
  }
}