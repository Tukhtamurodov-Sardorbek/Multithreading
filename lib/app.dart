import 'package:flutter/material.dart';
import 'package:multithreading/spawn.dart';
import 'package:multithreading/compute.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const BouncingScrollPhysics(),
      children: const [
        Compute(),
        Spawn(),
      ],
    );
  }
}
