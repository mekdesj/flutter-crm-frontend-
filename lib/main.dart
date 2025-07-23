import 'package:flutter/material.dart';
import 'package:frontend_crm/screens/UsersScreen.dart';
import 'package:frontend_crm/screens/viewuserscreen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/manager_dashboard.dart';
import 'screens/user_dashboard.dart';
import 'package:frontend_crm/screens/CreateLeadScreen.dart';
import 'package:frontend_crm/screens/ViewLeadScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'CRM Frontend',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        home: const RootScreen(),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const HomeScreen(),
          '/admin_dashboard': (_) => const AdminDashboard(),
          '/manager_dashboard': (_) => const ManagerDashboard(),
          '/user_dashboard': (_) => const UserDashboard(),
          '/admin/users': (context) => const UsersScreen(),
          '/addUser': (context) => const RegisterScreen(),
          '/viewUsers': (context) => const viewuserscreen(),
          '/createLead': (context) => const CreateLeadScreen(),
          '/viewLeads': (context) => const ViewLeadsScreen(),
        },
      ),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AuthProvider>(context, listen: false).checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          final auth = context.watch<AuthProvider>();
          if (!auth.isLoggedIn) return const HomeScreen();

          switch (auth.role) {
            case 'ROLE_ADMIN':
              return const AdminDashboard();
            case 'ROLE_MANAGER':
              return const ManagerDashboard();
            case 'ROLE_USER':
              return const UserDashboard();
            default:
              return const HomeScreen();
          }
        }
      },
    );
  }
}
