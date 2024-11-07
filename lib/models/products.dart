class Product {
  String productCode;
  String productName;
  double purchasePrice;
  int quantity;
  DateTime? expiryDate;
  double sellingPrice;

  Product({
    required this.productCode,
    required this.productName,
    required this.purchasePrice,
    required this.quantity,
    this.expiryDate,
    required this.sellingPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productCode: json['product_code'],
      productName: json['product_name'],
      purchasePrice: json['purchase_price'],
      quantity: json['quantity'],
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'])
          : null,
      sellingPrice: json['selling_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_code': productCode,
      'product_name': productName,
      'purchase_price': purchasePrice,
      'quantity': quantity,
      'expiry_date': expiryDate?.toIso8601String(),
      'selling_price': sellingPrice,
    };
  }
}
