import 'package:flatmate/UserScreens/user_dashboard.dart';
import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String paymentId;
  final String transactionId;

  const PaymentSuccessPage({
    Key? key,
    required this.paymentId,
    required this.transactionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment Successful",
          style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 1),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: 60.0,
        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Attractive icon
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[100], // Light green background
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(20), // Add padding around the icon
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80, // Increased size for better visibility
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Payment Successful!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Thank you for your payment.",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              // Display Payment ID and Transaction ID
              Text(
                "Payment ID: $paymentId",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                "Transaction ID: $transactionId",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 30),
              // "FlatMate" branding text
              Text(
                "FlatMate",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30),
              // Elevated Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HomePage(), // Replace with your actual dashboard widget
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button background color
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                        color: const Color(0xFF66123A)), // Button border color
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "Go to Home",
                  style: TextStyle(
                    color: const Color(0xFF66123A), // Text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
