class Product {
  final String id;
  final String name;
  final int quantity;
  final double purchasePrice;
  final double sellingPrice;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    required this.sellingPrice,
  });
}

class Sale {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double unitCost;
  final DateTime date;

  Sale({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.unitCost,
    required this.date,
  });

  double get totalSale => quantity * unitPrice;

  double get totalCost => quantity * unitCost;

  double get profit => totalSale - totalCost;
}

class Purchase {
  final String id;
  final String productId;
