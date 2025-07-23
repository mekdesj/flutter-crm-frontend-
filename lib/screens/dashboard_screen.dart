import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              auth.logout();
            },
          )
        ],
      ),
      backgroundColor: Colors.orange.shade50,
      body: const Center(
        child: Text(
          'Welcome to the CRM Dashboard',
          style: TextStyle(
            fontSize: 20,
            color: Colors.deepOrange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
