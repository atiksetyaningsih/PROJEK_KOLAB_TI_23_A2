import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';
import 'dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fkiazjimaawpdnjafytx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZraWF6amltYWF3cGRuamFmeXR4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk5NTgxOTAsImV4cCI6MjA2NTUzNDE5MH0.H0Ixd0XxgxaZdNTURDbDicc_q0QgrZmeRpGzD6jp0kA',
  );

  final session = Supabase.instance.client.auth.currentSession;

  runApp(MyApp(isLoggedIn: session != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makan Apa Hari Ini',
      theme: ThemeData(primarySwatch: Colors.brown),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const DashboardPage() : const LoginPage(),
    );
  }
}
