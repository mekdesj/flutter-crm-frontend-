import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard_screen.dart'; // <-- added this import

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final roleController = TextEditingController();
  bool loading = false;
  String message = '';

  Future<void> register() async {
    setState(() {
      loading = true;
      message = '';
    });

    final url =
        Uri.parse('http://localhost:9090/auth/register'); // 👈 change if needed
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
        'role': roleController.text,
      }),
    );

    setState(() {
      loading = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        message = 'Registration successful!';
        // Navigate to dashboard screen after success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        message = 'Registration failed: ${response.body}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(
                    labelText: 'Role (use capital letters)'),
              ),
              const SizedBox(height: 24),
              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: register,
                      child: const Text('Register'),
                    ),
              if (message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: message.contains('success')
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
