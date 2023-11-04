class ProductModel {
  late int productId, productStock;
  late String productName, productImage;
  late double salePrice, purchasePrice;
  String? databaseKey;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.salePrice,
    required this.purchasePrice,
    required this.productStock,
    required this.productImage,
    this.databaseKey,
  });
  ProductModel.fromJson({required Map<String, dynamic> json}) {
    productId = json['productId'];
    productStock = json['productStock'];
    productName = json['productName'];
    productImage = json['productImage'];
    salePrice = json['salePrice'];
    purchasePrice = json['purchasePrice'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'productId': productId,
        'productStock': productStock,
        'productName': productName,
        'productImage': productImage,
        'salePrice': salePrice,
        'purchasePrice': purchasePrice,
      };
}
