import 'package:flutter/material.dart';
import 'package:frontend_crm/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class ViewLeadsScreen extends StatefulWidget {
  const ViewLeadsScreen({super.key});

  @override
  State<ViewLeadsScreen> createState() => _ViewLeadsScreenState();
}

class _ViewLeadsScreenState extends State<ViewLeadsScreen> {
  List<dynamic> leads = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchLeads();
  }

  Future<void> fetchLeads() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    try {
      final response = await http.get(
        Uri.parse('http://localhost:9090/api/leads'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          leads = json.decode(response.body);
          loading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load leads. Status: ${response.statusCode}';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        loading = false;
      });
    }
  }

  Future<void> deleteLead(int id) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    final response = await http.delete(
      Uri.parse('http://localhost:9090/api/leads/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      fetchLeads();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete lead. Status: ${response.statusCode}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("All Leads"), backgroundColor: Colors.orange),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Assigned To')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: leads.map((lead) {
                      return DataRow(cells: [
                        DataCell(Text(lead['id'].toString())),
                        DataCell(Text(lead['name'] ?? '')),
                        DataCell(Text(lead['email'] ?? '')),
                        DataCell(Text(lead['phone'] ?? '')),
                        DataCell(Text(
                            lead['assignedTo']?['username'] ?? 'unassigned')),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteLead(lead['id']),
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
    );
  }
}
