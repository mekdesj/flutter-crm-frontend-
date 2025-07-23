import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ViewCustomersScreen extends StatefulWidget {
  const ViewCustomersScreen({super.key});

  @override
  State<ViewCustomersScreen> createState() => _ViewCustomersScreenState();
}

class _ViewCustomersScreenState extends State<ViewCustomersScreen> {
  List<dynamic> customers = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:9090/api/customers'), // Replace with your IP
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          customers = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load customers. Status: ${response.statusCode}';
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

  Future<void> deleteCustomer(int id) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    try {
      final response = await http.delete(
        Uri.parse('http://localhost:9090/api/customers/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer deleted')),
        );
        fetchCustomers(); // Refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Customers"),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.orange),
                        title: Text(
                            '${customer['name'] ?? 'N/A'} (ID: ${customer['id'] ?? 'N/A'})'),
                        subtitle: Text("Email: ${customer['email'] ?? 'N/A'}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteCustomer(customer['id']),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
