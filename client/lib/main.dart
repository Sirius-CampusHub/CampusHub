import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/dependencies.dart';
import 'module/app_shell.dart';
import 'network/http_client.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final Dependencies dependencies = Dependencies(
    dio: createAppHttpClient(),
  );

  runApp(
    DependenciesScope(
      dependencies: dependencies,
      child: const MyApp(),
    ),
  );

  FlutterNativeSplash.remove();

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
