import 'package:flutter/material.dart';

import 'models.dart';

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
        scaffoldBackgroundColor: const Color(0xFFFFF8FA),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Product> products = [];
  final List<Purchase> purchases = [];
  final List<Sale> sales = [];

  double get todaySales {
    final now = DateTime.now();

    return sales
        .where(
          (s) =>
              s.date.year == now.year &&
              s.date.month == now.month &&
              s.date.day == now.day,
        )
        .fold(0, (sum, s) => sum + s.totalSale);
  }

  double get todayProfit {
    final now = DateTime.now();

    return sales
        .where(
          (s) =>
              s.date.year == now.year &&
              s.date.month == now.month &&
              s.date.day == now.day,
        )
        .fold(0, (sum, s) => sum + s.profit);
  }

  int get totalStock {
    return products.fold(0, (sum, product) => sum + product.quantity);
  }

  void addProduct() {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final purchaseController = TextEditingController();
    final sellingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('አዲስ እቃ ጨምር'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'የእቃው ስም',
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ብዛት',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                ),
                TextField(
                  controller: purchaseController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'የግዢ ዋጋ',
                    prefixIcon: Icon(Icons.money),
                  ),
                ),
                TextField(
                  controller: sellingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'የሽያጭ ዋጋ',
                    prefixIcon: Icon(Icons.sell),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ሰርዝ'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final quantity = int.tryParse(quantityController.text) ?? 0;
                final purchase =
                    double.tryParse(purchaseController.text) ?? 0;
                final selling =
                    double.tryParse(sellingController.text) ?? 0;

                if (name.isEmpty ||
                    quantity <= 0 ||
                    purchase <= 0 ||
                    selling <= 0) {
                  return;
                }

                setState(() {
                  products.add(
                    Product(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      quantity: quantity,
                      purchasePrice: purchase,
                      sellingPrice: selling,
                    ),
                  );

                  purchases.add(
                    Purchase(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      productId: products.last.id,
                      productName: name,
                      quantity: quantity,
                      unitCost: purchase,
                      date: DateTime.now(),
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: const Text('አስቀምጥ'),
            ),
          ],
        );
      },
    );
  }

  void recordSale() {
    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('መጀመሪያ እቃ ይጨምሩ።')),
      );
      return;
    }

    Product selectedProduct = products.first;
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('አዲስ ሽያጭ'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<Product>(
                    value: selectedProduct,
                    decoration: const InputDecoration(
                      labelText: 'እቃ ምረጥ',
                    ),
                    items: products.map((product) {
                      return DropdownMenuItem(
                        value: product,
                        child: Text(
                          '${product.name} (${product.quantity})',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedProduct = value;
                        });
                      }
                    },
                  ),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'የተሸጠ ብዛት',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ሰርዝ'),
                ),
                FilledButton(
                  onPressed: () {
                    final quantity =
                        int.tryParse(quantityController.text) ?? 0;

                    if (quantity <= 0 ||
                        quantity > selectedProduct.quantity) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ያለውን እቃ ብዛት አትበልጥ።'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      final index = products.indexOf(selectedProduct);

                      products[index] = Product(
                        id: selectedProduct.id,
                        name: selectedProduct.name,
                        quantity: selectedProduct.quantity - quantity,
                        purchasePrice: selectedProduct.purchasePrice,
                        sellingPrice: selectedProduct.sellingPrice,
                      );

                      sales.add(
                        Sale(
                          id: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          productId: selectedProduct.id,
                          productName: selectedProduct.name,
                          quantity: quantity,
                          unitPrice: selectedProduct.sellingPrice,
                          unitCost: selectedProduct.purchasePrice,
                          date: DateTime.now(),
                        ),
                      );
                    });

                    Navigator.pop(context);
                  },
                  child: const Text('ሽያጭ መዝግብ'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cosmetics Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'የዛሬ አጠቃላይ መረጃ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    title: 'የዛሬ ሽያጭ',
                    value: '${todaySales.toStringAsFixed(2)} ብር',
                    icon: Icons.payments,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard(
                    title: 'የዛሬ ትርፍ',
                    value: '${todayProfit.toStringAsFixed(2)} ብር',
                    icon: Icons.trending_up,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _summaryCard(
              title: 'የቀረ እቃ',
              value: '$totalStock እቃ',
              icon: Icons.inventory_2,
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: addProduct,
                    icon: const Icon(Icons.add_box),
                    label: const Text('እቃ ጨምር'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: recordSale,
                    icon: const Icon(Icons.point_of_sale),
                    label: const Text('ሽያጭ'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'የእቃ ዝርዝር',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            if (products.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'እስካሁን እቃ አልተመዘገበም።',
                    ),
                  ),
                ),
              )
            else
              ...products.map(
                (product) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${product.quantity}'),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'ግዢ: ${product.purchasePrice} ብር | '
                      'ሽያጭ: ${product.sellingPrice} ብር',
                    ),
                    trailing: Text(
                      '${product.quantity}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
