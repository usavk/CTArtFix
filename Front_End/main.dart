import 'package:artifact/getstarted.dart';
import 'package:artifact/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Set GetStarted as the initial route
      home: const GetStarted(),
      // Define routes for navigation
      routes: {
        '/login': (context) => const Login(),        // Route to login page
      },
    );
  }
}