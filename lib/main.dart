import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techrx/features/auth/data/auth_gate.dart';
import 'package:techrx/themes/light_mode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://umgzzpnqujelaourohip.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVtZ3p6cG5xdWplbGFvdXJvaGlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI4NzY4NDAsImV4cCI6MjA0ODQ1Mjg0MH0.7kYTHmhN6xuFhcuuWSQtxoaQ30xQc89malpIoQT9HFU',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      title: 'TechRx',
      home: const AuthGate(),
    );
  }
}
