import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:multithreading/components/shape.dart';
import 'package:screenshot/screenshot.dart';

final GlobalKey globalKey = GlobalKey();

final screenshotController = ScreenshotController();

Future<Uint8List> capture(double pixel) async{
  final bytes = await screenshotController.captureFromWidget(
    Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 500,
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: ShapeDecoration(
          color: CupertinoColors.systemGreen,
          shape: const ResponsiveCustomShapeBorder(horizontalPadding: 16),
          shadows: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    ),
    delay: Duration.zero,
    pixelRatio: pixel,
  );
  return bytes;
}

Widget repaintBoundary(){
  return RepaintBoundary(
    key: globalKey,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 500,
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: ShapeDecoration(
          color: CupertinoColors.systemGreen,
          shape: const ResponsiveCustomShapeBorder(horizontalPadding: 16),
          shadows: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget receipt(){
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Container(
      height: 500,
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: ShapeDecoration(
        color: CupertinoColors.systemGreen,
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