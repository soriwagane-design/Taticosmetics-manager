import 'package:flutter/material.dart';

void main() {
  runApp(const CosmeticsManagerApp());
}

class CosmeticsManagerApp extends StatelessWidget {
  const CosmeticsManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cosmetics Manager',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosmetics Manager'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'የኮስሜቲክስ አስተዳደር',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
