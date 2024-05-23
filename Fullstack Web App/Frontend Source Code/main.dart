import 'package:eshopping_v2/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UserNotifier.dart';
import 'itemPage.dart';
import 'cart.dart';
import 'product.dart';
import 'login.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Shop',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'Arial',
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 4.0,
          color: Color.fromARGB(255, 18, 22, 25),
        ),
      ),
      home: Consumer<UserNotifier>(
        builder: (context, userNotifier, child) {
          return userNotifier.isLoggedIn ? MainPage() : LoginPage();
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  int _selectedCategoryId = 0; // Track the selected category

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      _products = await _apiService.fetchProducts();
      setState(() {
        _filteredProducts = _products;
      });
    } catch (e) {
      print('Failed to fetch products: $e');
      // Optionally handle the error by showing an alert or a Snackbar
    }
  }

  void filterProducts(String query) {
    setState(() {
      _filteredProducts = _products
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void filterByCategory(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId; // Update selected category
      _filteredProducts =
          _products.where((p) => p.category_id == categoryId).toList();
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset('logo_wide.png', height: 100),
          ),
          Expanded(
            child: Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                onChanged: filterProducts,
                decoration: InputDecoration(
                  hintText: "Search BuySwift.com",
                  prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          Consumer<UserNotifier>(
            builder: (context, userNotifier, child) {
              return Row(
                children: [
                  IconButton(
                    icon: Icon(
                      userNotifier.isLoggedIn ? Icons.logout : Icons.person,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (userNotifier.isLoggedIn) {
                        userNotifier.logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CartPage(cart: Cart.fromJson(userNotifier.cart)),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Container(
          color: Color.fromARGB(255, 89, 125, 255),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildCategoryButton('Technology', 1),
              buildCategoryButton('Books', 2),
              buildCategoryButton('Clothing', 3),
              buildCategoryButton('Hobbies', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryButton(String title, int categoryId) {
    return MouseRegion(
      onEnter: (_) => setState(() {}), // Trigger rebuild to change style
      onExit: (_) => setState(() {}), // Trigger rebuild to revert style
      child: TextButton(
        onPressed: () {
          filterByCategory(categoryId);
        },
        style: TextButton.styleFrom(
          backgroundColor: _selectedCategoryId == categoryId
              ? Color.fromARGB(181, 0, 0, 0)
              : Colors.transparent,
          primary: Colors.white,
          textStyle: TextStyle(fontSize: 16),
          onSurface: Colors.grey, // Change color when disabled
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // Adjust number of columns
          childAspectRatio: 0.8, // Adjust item width to height ratio
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemPage(
                    product: _filteredProducts[index],
                    userId: Provider.of<UserNotifier>(context, listen: false)
                        .userId, // pass userId
                  ),
                ),
              );
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 250, 250, 250),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      _filteredProducts[index].imagepath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    _filteredProducts[index].name,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '\$${_filteredProducts[index].price.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
