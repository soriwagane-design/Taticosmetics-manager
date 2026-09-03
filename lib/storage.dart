import 'dart:convert';

import 'models.dart';

class AppStorage {
  static String productsKey = 'cosmetics_products';
  static String purchasesKey = 'cosmetics_purchases';
  static String salesKey = 'cosmetics_sales';

  static String encodeProducts(List<Product> products) {
    return jsonEncode(
      products
          .map(
            (p) => {
              'id': p.id,
              'name': p.name,
              'quantity': p.quantity,
              'purchasePrice': p.purchasePrice,
              'sellingPrice': p.sellingPrice,
            },
          )
          .toList(),
    );
  }

  static String encodePurchases(List<Purchase> purchases) {
    return jsonEncode(
      purchases
          .map(
            (p) => {
              'id': p.id,
              'productId': p.productId,
              'productName': p.productName,
              'quantity': p.quantity,
              'unitCost': p.unitCost,
              'date': p.date.toIso8601String(),
            },
          )
          .toList(),
    );
  }

  static String encodeSales(List<Sale> sales) {
    return jsonEncode(
      sales
          .map(
            (s) => {
              'id': s.id,
              'productId': s.productId,
              'productName': s.productName,
              'quantity': s.quantity,
              'unitPrice': s.unitPrice,
              'unitCost': s.unitCost,
              'date': s.date.toIso8601String(),
            },
          )
          .toList(),
    );
  }

  static List<Product> decodeProducts(String data) {
    final List<dynamic> list = jsonDecode(data);

    return list.map((item) {
      return Product(
        id: item['id'],
        name: item['name'],
        quantity: item['quantity'],
        purchasePrice: (item['purchasePrice'] as
