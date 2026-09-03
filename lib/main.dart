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
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosmetics Manager'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'የኮስሜቲክስ አስተዳደር',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            Card(
              child: ListTile(
                leading: const Icon(Icons.inventory_2),
                title: const Text('የእቃ ክምችት'),
                subtitle: const Text('ያሉትን እቃዎች ይመልከቱ'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('ሽያጭ'),
                subtitle: const Text('አዲስ ሽያጭ ይመዝግቡ'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('ሪፖርት'),
                subtitle: const Text('ዕለታዊ፣ ሳምንታዊ እና ወርሃዊ'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
