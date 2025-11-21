import 'package:flutter/material.dart';
import 'package:internetion/main.dart';
import 'package:internetion/models/product_model.dart';
import 'package:internetion/pages/product_detals.dart';
import 'package:internetion/product_card.dart';
import 'package:internetion/pages/cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  List<Map<String, dynamic>> cart = [];
  bool isLoading = false;

  Future<void> getAllProduct() async {
    setState(() => isLoading = true);

    final response = await dio.get('https://fakestoreapi.com/products');

    products.clear();
    for (Map productMap in response.data) {
      products.add(
        Product(
          id: productMap["id"],
          title: productMap["title"],
          price: productMap["price"],
          description: productMap["description"],
          category: productMap["category"],
          image: productMap["image"],
          rate: productMap['rating']["rate"],
        ),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getAllProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("My Fake Store"),
            actions: [
              IconButton(
                icon: Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    if (cart.isNotEmpty)
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            "${cart.length}",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      )
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(cart: cart),
                    ),
                  );
                },
              ),
            ],
          ),

          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
            padding: EdgeInsets.all(12),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              Product product = products[index];
              return GestureDetector(
                onTap: () async {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetals(product: product),
                    ),
                  );

                  if (result != null && result is Map) {
                    setState(() {
                      cart.add(result.cast<String, dynamic>());
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${(result["product"] as Product).title} added to cart"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },


                child: ProductCard(product: product),
              );
            },
          ),
        ),
      ],
    );
  }
}
