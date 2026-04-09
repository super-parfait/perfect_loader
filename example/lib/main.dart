import 'package:flutter/material.dart';
import 'package:perfect_loader/perfect_loader.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'perfect_loader',
      home: Scaffold(
        appBar: AppBar(title: const Text('Play Store–style loader')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PerfectLoader(size: 72),
              SizedBox(height: 48),
              PerfectLoader(
                size: 56,
                activeColor: Color(0xFFB66B34),
                trackColor: Color(0xFFE8C4A8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
