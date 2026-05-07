import 'package:flutter/material.dart';
import 'package:isango_app/widgets/isango_bottom_navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      bottomNavigationBar: const IsangoBottomNavigation(currentIndex: 3),
      body: const Center(
        child: Text('Settings screen (to be implemented).'),
      ),
    );
  }
}
