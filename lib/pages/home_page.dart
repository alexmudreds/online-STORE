import 'package:flutter/material.dart';
import 'package:internetion/main.dart';
import 'package:internetion/models/product_model.dart';
import 'package:internetion/pages/product_detals.dart';
import 'package:internetion/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  bool isLoading = false;

  Future<void> getAllProduct() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 0));

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

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("My Store"),
          ),
          body: Column(
            children: [
              TextButton(
                onPressed: getAllProduct,
                child: Text(
                  "Reload Products",
                  style: TextStyle(
                    color: Color(0xFF1A73E8),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final Product product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetals(product: product),
                          ),
                        );
                      },
                      child: ProductCard(product: product),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
