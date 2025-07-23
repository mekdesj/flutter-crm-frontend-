import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:frontend_crm/providers/auth_provider.dart';

class viewuserscreen extends StatefulWidget {
  const viewuserscreen({super.key});

  @override
  State<viewuserscreen> createState() => _ViewUsersScreenState();
}

class _ViewUsersScreenState extends State<viewuserscreen> {
  List<dynamic> users = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:9090/users'));

      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load users. Status: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("All Users"), backgroundColor: Colors.orange),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.orange),
                        title: Text(user['username'] ?? 'N/A'),
                        subtitle: Text("Role: ${user['role'] ?? 'N/A'}"),
                      ),
                    );
                  },
                ),
    );
  }
}
