class ProductModel {
  final String productID;
  final String productName;
  final String categoryId;
  final String productImages;
  final String categoryName;
  final String productDescription;
  final String price;
  final String discount;
  final dynamic createdAt;
  final dynamic updatedAt;

  ProductModel({
    required this.categoryId,
    required this.productID,
    required this.categoryName,
    required this.price,
    required this.discount,
    required this.productDescription,
    required this.productImages,
    required this.productName,
    required this.createdAt,
    required this.updatedAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'productImages': productImages,
      'categoryName': categoryName,
      'productID': productID,
      'productDescription':productDescription,
      'productName':productName,
      'price':price,
      'discount':discount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
  factory ProductModel.fromMap(Map<String, dynamic> json){
    return ProductModel(
      categoryId: json['categoryId'],
      productImages: json['productImages'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      price: json['price'],
      discount: json['discount'],
      productID: json['productID'],
      categoryName: json['categoryName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}