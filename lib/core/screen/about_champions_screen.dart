
import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:flutter/material.dart';


class AboutChampionsScreen extends StatefulWidget {
  const AboutChampionsScreen({super.key});

  @override
  State<AboutChampionsScreen> createState() => _AboutChampionsScreenState();
}

class _AboutChampionsScreenState extends State<AboutChampionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'About Champions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'This app is designed to help manage and track achievements in extracurricular activities.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the floating action button
        },
        child: const Icon(Icons.info),
        tooltip: 'More Info',
      ),
    );
  }
}