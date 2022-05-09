import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = 'route11';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
