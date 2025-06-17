import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';
import 'register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fkiazjimaawpdnjafytx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZraWF6amltYWF3cGRuamFmeXR4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk5NTgxOTAsImV4cCI6MjA2NTUzNDE5MH0.H0Ixd0XxgxaZdNTURDbDicc_q0QgrZmeRpGzD6jp0kA',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makan Apa Hari Ini?',
      theme: ThemeData(primarySwatch: Colors.brown),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
