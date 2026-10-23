import 'package:flutter/material.dart';
import '../widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('DRRM Command Center')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton(
              text: 'Open Login',
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'Open Report Form',
              onPressed: () => Navigator.pushNamed(context, '/report'),
            ),
          ],
        ),
      ),
    ),
  );
}