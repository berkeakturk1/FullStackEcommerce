class Product {
  final int product_id;
  final String name;
  final String description;
  final double price;
  final int category_id;
  final String imagepath;

  Product({
    required this.product_id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagepath,
    required this.category_id,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    print('imagepath: ${json['imagepath']}'); // Add this line

    return Product(
      product_id: json['product_id'] != null ? json['product_id'] : 0,
      name: json['name'] != null ? json['name'] : '',
      description: json['description'] != null ? json['description'] : '',
      price: json['price'] != null ? json['price'].toDouble() : 0.0,
      category_id: json['category_id'] != null ? json['category_id'] : 0,
      imagepath: json['imagepath'] != null ? json['imagepath'] : '',
    );
  }

  int get productId => product_id;
}
