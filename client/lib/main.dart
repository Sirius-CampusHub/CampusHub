import 'package:flutter/material.dart';

import 'core/dependencies.dart';
import 'module/app_shell.dart';
import 'network/http_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final Dependencies dependencies = Dependencies(
    dio: createAppHttpClient(),
  );

  runApp(
    DependenciesScope(
      dependencies: dependencies,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const AppShell(),
    );
  }
}
