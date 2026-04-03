import 'package:client/data/repository/auth_repository.dart';
import 'package:client/domain/model/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repository/news_repository.dart';
import 'domain/model/news/news_bloc.dart';
import 'module/auth/screens/auth_gate.dart';
import 'utils/firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/dependencies.dart';
import 'network/http_client.dart';
import 'package:dio/dio.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Dio dio = createAppHttpClient();

  final newsRepository = NewsRepository(dio);
  final Dependencies dependencies = Dependencies(dio: createAppHttpClient(), newsRepository: newsRepository,);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRepository = AuthRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppBloc(authRepository: authRepository, dependencies: dependencies)),
        BlocProvider(create: (_) => NewsBloc(newsRepository)),
      ],
      child: MyApp(),
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
      home: const AuthGate(),
    );
  }
}