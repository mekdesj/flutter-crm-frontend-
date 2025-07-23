import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'admin_dashboard.dart';
import 'manager_dashboard.dart';
import 'user_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateState);
    _passwordController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {}); // rebuilds when user types
  }

  void _login(BuildContext context) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Username and password cannot be empty'),
      ));
      return;
    }

    setState(() {
      isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.login(username, password);

    setState(() {
      isLoading = false;
    });

    if (success) {
      final role = authProvider.role;
      print('Logged in as role: $role');

      Widget destination;
      if (role == 'ROLE_ADMIN') {
        destination = AdminDashboard();
      } else if (role == 'ROLE_MANAGER') {
        destination = ManagerDashboard();
      } else if (role == 'ROLE_USER') {
        destination = UserDashboard();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Unknown role: $role'),
        ));
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => destination),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Login failed. Please check your credentials.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFormFilled = _usernameController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: isFormFilled ? () => _login(context) : null,
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.removeListener(_updateState);
    _passwordController.removeListener(_updateState);
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
