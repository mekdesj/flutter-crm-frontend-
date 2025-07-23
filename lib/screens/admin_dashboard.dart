import 'package:flutter/material.dart';
import 'package:frontend_crm/widgets/dashboard_bar_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend_crm/screens/ViewCustomerScreen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int usersCount = 0;
  int customersCount = 0;
  int leadsCount = 0;
  int followUpsCount = 0;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDashboardSummary();
  }

  Future<void> fetchDashboardSummary() async {
    const String apiUrl = 'http://localhost:9090/api/dashboard/summary';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          usersCount = data['usersCount'] ?? 0;
          customersCount = data['customersCount'] ?? 0;
          leadsCount = data['leadsCount'] ?? 0;
          followUpsCount = data['followUpsCount'] ?? 0;
          isLoading = false;
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data. Status: ${response.statusCode}';
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
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.orange,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text(
                'Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.orange),
              title: const Text('Add User'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/addUser');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outline, color: Colors.orange),
              title: const Text('View All Users'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/viewUsers');
              },
            ),
            const Divider(),
            ExpansionTile(
              leading: const Icon(Icons.leaderboard, color: Colors.orange),
              title: const Text('Leads'),
              children: [
                ListTile(
                  leading: const Icon(Icons.add, color: Colors.green),
                  title: const Text('Create Lead'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/createLead');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list, color: Colors.blue),
                  title: const Text('View All Leads'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/viewLeads');
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.track_changes),
              title: const Text('Follow-ups'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/followUps');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Customers'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViewCustomersScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacementNamed(
                    context, '/home'); // Go to HomeScreen
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard(
                              'Users', usersCount, Icons.people, Colors.blue),
                          _buildStatCard('Customers', customersCount,
                              Icons.person, Colors.green),
                          _buildStatCard('Leads', leadsCount, Icons.leaderboard,
                              Colors.orange),
                          _buildStatCard('Follow-ups', followUpsCount,
                              Icons.track_changes, Colors.red),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: Colors.orange, width: 1.5),
                          ),
                          child: DashboardBarChart(
                            userCount: usersCount,
                            customerCount: customersCount,
                            leadCount: leadsCount,
                            followUpCount: followUpsCount,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, int count, IconData icon, Color iconColor) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, size: 40, color: iconColor),
              const SizedBox(height: 10),
              Text(
                '$count',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
