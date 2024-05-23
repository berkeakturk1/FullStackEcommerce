import 'package:flutter/material.dart';
import 'cart.dart';
import 'product.dart';
import 'ApiService.dart';

class ItemPage extends StatefulWidget {
  final Product product;
  final int userId;

  ItemPage({required this.product, required this.userId});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  int _selectedQuantity = 1;

  void addItemToCart() async {
    try {
      // Fetch the cart by user ID
      Map<String, dynamic> cartData =
          await ApiService.getCartByUserId(widget.userId);
      int cartId = cartData['cartId']; // Ensure the correct key is used
      print('Cart ID: $cartId'); // Debug statement

      // Add item to the cart
      await ApiService.addItemToCart(
          cartId, widget.product.productId, _selectedQuantity);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item(s) added to cart')),
      );
    } catch (e) {
      print('Failed to add item to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item to cart')),
      );
    }
  }

  void buyNow() async {
    try {
      // Fetch the cart by user ID
      Map<String, dynamic> cartData =
          await ApiService.getCartByUserId(widget.userId);
      int cartId = cartData['cartId']; // Ensure the correct key is used
      print('Cart ID: $cartId'); // Debug statement

      // Add item to the cart
      await ApiService.addItemToCart(
          cartId, widget.product.productId, _selectedQuantity);

      // Navigate to the CartPage after adding the item
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartPage(cart: Cart.fromJson(cartData)),
        ),
      );
    } catch (e) {
      print('Failed to add item to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item to cart')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.product.price * _selectedQuantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.name,
          style: TextStyle(fontFamily: 'SFPro'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image Section
            Expanded(
              flex: 2,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 1, // 1:1 aspect ratio
                    child: Image.asset(
                      widget.product.imagepath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            // Description Section
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SFPro',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                        fontFamily: 'SFPro',
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(),
                    SizedBox(height: 8),
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SFPro',
                      ),
                    ),
                    Text(
                      widget.product.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontFamily: 'SFPro',
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            // Buttons Section
            Expanded(
              flex: 1,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Select Quantity',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SFPro',
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButton<int>(
                        value: _selectedQuantity,
                        items: List.generate(10, (index) {
                          int value = index + 1;
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value.toString(),
                              style: TextStyle(fontFamily: 'SFPro'),
                            ),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            _selectedQuantity = value!;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Total: \$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'SFPro',
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: addItemToCart,
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 219, 228, 236),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SFPro',
                            color: Colors.black, // Set text color to black
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Add to Cart',
                            style: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: buyNow,
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(100, 89, 124, 255),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SFPro',
                            color: Colors.black, // Set text color to black
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Buy Now',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
