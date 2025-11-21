import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              "https://assets10.lottiefiles.com/packages/lf20_jbrw3hcz.json",
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              "Successfully Ordered!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Your order is being delivered...",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text("Back to Home"),
            )
          ],
        ),
      ),
    );
  }
}
