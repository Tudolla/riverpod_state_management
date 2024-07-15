import 'package:get_it/get_it.dart';
import 'package:riverpod_management_app/services/database_service.dart';
import 'package:riverpod_management_app/services/http_service.dart';

import '../screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await _setupServices();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _setupServices() async {
  GetIt.instance.registerSingleton<HttpService>(
    HttpService(),
  );

  GetIt.instance.registerSingleton<DatabaseService>(
    DatabaseService(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RiverPod',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
        useMaterial3: true,
        textTheme: GoogleFonts.quattrocentoTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}
