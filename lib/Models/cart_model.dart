class CartModel {
  late int productId, productStock, quantity;
  late String productName, productImage;
  late double salePrice, purchasePrice;
  String? databaseKey;
  late bool isFev;

  CartModel({
    required this.productId,
    required this.productName,
    required this.salePrice,
    required this.purchasePrice,
    required this.productStock,
    required this.productImage,
    this.databaseKey,
    required this.isFev,
    required this.quantity,
  });
}
