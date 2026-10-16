import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/crm_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CrmProvider()),
      ],
      child: const CodialCrmApp(),
    ),
  );
}

class CodialCrmApp extends StatelessWidget {
  const CodialCrmApp({super.key});

  @override
  Widget build(BuildContext context) {
    final crm = context.watch<CrmProvider>();

    return MaterialApp(
      title: 'Codial CRM Tizimi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: crm.isLoggedIn ? const MainShell() : const LoginScreen(),
    );
  }
}
