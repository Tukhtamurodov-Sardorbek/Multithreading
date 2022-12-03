import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:multithreading/app.dart';
import 'components/app_bar.dart';
import 'package:multithreading/components/receipt.dart';

class Compute extends StatefulWidget {
  const Compute({Key? key}) : super(key: key);

  @override
  State<Compute> createState() => _ComputeState();
}

class _ComputeState extends State<Compute> {
  Uint8List? widgetImage;
  bool isLoading = false;

  Future<void> captureWidget() async {
    isLoading = true;
    setState(() {});

    update().then((value) {
      Future.delayed(const Duration(milliseconds: 900), () {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  Future update() async {
    if (widgetImage == null) {
      // widgetImage = await compute(capture, 10.0);
      widgetImage = await capture(10.0);
    } else {
      widgetImage = null;
    }
    setState(() {});
  }

  void _captureWidget() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 10);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      Uint8List bytes = byteData.buffer.asUint8List();

      setState(() {
        widgetImage = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, kToolbarHeight),
        child: CustomAppBar(title: 'Compute'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // widgetImage == null ? repaintBoundary() : Container(
                  //   height: 500,
                  //   width: 300,
                  //   alignment: Alignment.center,
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xFF2AA65C),
                  //     borderRadius: BorderRadius.circular(30.0),
                  //     border: Border.all(color: Colors.red, width: 6),
                  //   ),
                  //   child: Image.memory(widgetImage!),
                  // ),
                  Container(
                    height: 500,
                    width: 300,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widgetImage == null
                          ? const Color(0xFF2AA65C)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.red, width: 6),
                    ),
                    child: widgetImage == null
                        ? const Text(
                            'Image',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Image.memory(widgetImage!),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      captureWidget();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEAF6EF),
                      fixedSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Capture',
                      style: TextStyle(
                        color: Color(0xFF2AA65C),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 6,
              ),
            ),
        ],
      ),
    );
  }
}
