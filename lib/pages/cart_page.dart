import 'package:flutter/material.dart';
import 'package:internetion/pages/successorder.dart';
class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  const CartPage({super.key, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double total = widget.cart.fold(
        0, (sum, item) => sum + item["product"].price * item["count"]);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                var item = widget.cart[index];

                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.network(item["product"].image, height: 50),
                    title: Text(item["product"].title, maxLines: 1),
                    subtitle: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (item["count"] > 1) item["count"]--;
                            });
                          },
                        ),
                        Text("${item["count"]}"),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              item["count"]++;
                            });
                          },
                        ),SizedBox(width: 20,)
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [ Flexible(child:Text("\$${(item["product"].price * item["count"]).toStringAsFixed(2)}"),
                      ),
                        IconButton( iconSize: 30,
                          icon: Icon(Icons.dangerous_rounded, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              widget.cart.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(
              children: [
                Text(
                  "Total: \$${total.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),

                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: "Address"),
                ),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: "City"),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: "Phone Number"),
                  keyboardType: TextInputType.number,
                ),

                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (addressController.text.isEmpty ||
                        cityController.text.isEmpty ||
                        phoneController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill all fields!")),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SuccessOrder(),
                      ),
                    );
                  },
                  child: Text("Confirm Order"),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
