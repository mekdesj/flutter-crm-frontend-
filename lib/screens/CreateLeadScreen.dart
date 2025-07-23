import 'package:flutter/material.dart';
import 'package:frontend_crm/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class CreateLeadScreen extends StatefulWidget {
  const CreateLeadScreen({super.key});

  @override
  State<CreateLeadScreen> createState() => _CreateLeadScreenState();
}

class _CreateLeadScreenState extends State<CreateLeadScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final statusController = TextEditingController();
  final assignedToIdController = TextEditingController();

  bool isSubmitting = false;
  String? error;

  Future<void> submitLead() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    setState(() {
      isSubmitting = true;
      error = null;
    });

    final response = await http.post(
      Uri.parse('http://localhost:9090/api/leads'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'status': statusController.text,
        'assignedToId': int.tryParse(assignedToIdController.text),
      }),
    );

    if (response.statusCode == 201) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lead created successfully!')),
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context);
      }
    } else {
      setState(() {
        error = 'Failed to create lead. Status: ${response.statusCode}';
      });
    }

    setState(() {
      isSubmitting = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    statusController.dispose();
    assignedToIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Lead"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v!.isEmpty ? 'Enter an email' : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (v) => v!.isEmpty ? 'Enter a phone number' : null,
              ),
              TextFormField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (v) => v!.isEmpty ? 'Enter a status' : null,
              ),
              TextFormField(
                controller: assignedToIdController,
                decoration:
                    const InputDecoration(labelText: 'Assigned To (User ID)'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? 'Enter an assigned user ID' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSubmitting ? null : submitLead,
                child: isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
