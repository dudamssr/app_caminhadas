import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/provider.dart';
import 'screens/splash.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WalkProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WalkProvider>(context);

    return MaterialApp(
      title: 'App de Caminhadas',
      debugShowCheckedModeBanner: false,
      themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}