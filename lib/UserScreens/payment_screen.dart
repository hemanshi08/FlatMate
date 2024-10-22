import 'package:flatmate/UserScreens/PaymentSuccessPage.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_database/firebase_database.dart'; // For Firebase Realtime Database
import 'package:intl/intl.dart'; // For date formatting
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences

class PaymentScreen extends StatefulWidget {
  // Change from StatelessWidget to StatefulWidget
  final String requestId;
  final String title;
  final double amount;
  final String flatNo;
  final String ownerName;

  const PaymentScreen({
    Key? key,
    required this.requestId,
    required this.title,
    required this.amount,
    required this.flatNo,
    required this.ownerName,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? userId; // To store user ID fetched from SharedPreferences
  late Razorpay _razorpay;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref(); // Firebase reference

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    // Fetch the user_id from SharedPreferences
    _getUserId();

    // Listen to successful payments
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // Fetch the user_id from SharedPreferences
  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id'); // Get user_id from SharedPreferences
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Clear the instance when the widget is disposed
  }

  // Handle successful payment and update Firebase
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Successful: ${response.paymentId}");

    // Update payment details in Firebase
    _updatePaymentDetails(
      paymentId: response.paymentId ?? '',
      transactionId: response.paymentId ??
          '', // Can also be response.signature if using signature validation
      paymentTimestamp: DateFormat('dd MMM yyyy HH:mm').format(DateTime.now()),
    );

    // Navigate to success page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessPage(
          paymentId: response.paymentId ?? '',
          transactionId: response.paymentId ?? '',
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.code} - ${response.message}");

    // Optionally, show an error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed! Try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  // Update payment details in Firebase after successful payment
  void _updatePaymentDetails({
    required String paymentId,
    required String transactionId,
    required String paymentTimestamp,
  }) async {
    if (userId == null) {
      print("User ID not found. Cannot update payment.");
      return;
    }

    // Path to the specific maintenance request
    DatabaseReference requestRef =
        _database.child('maintenance_requests').child(widget.requestId);

    // Get the existing data from Firebase
    final snapshot = await requestRef.get();

    if (snapshot.exists) {
      print("Snapshot exists: ${snapshot.value}");

      // Now access the 'payments' node under the specific request ID
      final paymentsSnapshot = snapshot.child('payments');
      bool paymentForUserFound = false;

      if (paymentsSnapshot.exists) {
        // Check if the user already has a payment entry
        paymentsSnapshot.children.forEach((child) {
          if (child.key == userId) {
            print("Found payment for user ID: $userId");

            // Update the payment for the specific user
            requestRef.child('payments/$userId').update({
              'payment_id': paymentId,
              'transaction_id': transactionId,
              'payment_timestamp': paymentTimestamp,
              'payment_status': 'Paid', // Mark as paid
            }).then((_) {
              print("Updated payment for user with ID: $userId");
            }).catchError((error) {
              print("Failed to update payment: $error");
            });

            paymentForUserFound = true;
          }
        });
      }

      // If no payment found for the user, create a new entry
      if (!paymentForUserFound) {
        print("No payment found for user ID: $userId. Creating a new entry.");

        requestRef.child('payments/$userId').set({
          'payment_id': paymentId,
          'transaction_id': transactionId,
          'payment_timestamp': paymentTimestamp,
          'payment_method': 'Razorpay',
          'payment_status': 'Paid',
        }).then((_) {
          print("Created new payment entry for user with ID: $userId");
        }).catchError((error) {
          print("Failed to create payment entry: $error");
        });
      }
    } else {
      print("Maintenance request not found in the database.");
    }

    print("Payment details update attempt completed.");
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_kcmiTjeyCQhbpI', // Replace with your Razorpay Key ID
      'amount': (widget.amount * 100).toInt(), // Amount in paise
      'currency': 'INR',
      'name': 'Maintenance Fee',
      'description': 'Payment for Maintenance Services',
      'prefill': {
        'contact': 'YOUR_CONTACT_NUMBER',
        'email': 'YOUR_EMAIL_ID',
      },
      'theme': {
        'color': '#528FF0',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Get the width of the device
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth =
        screenWidth * 0.9; // Card width to be 90% of screen width
    double buttonWidth =
        screenWidth * 0.6; // Set button width to 60% of screen width

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 1),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: 60.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: cardWidth, // Set card width
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Amount: ₹${widget.amount.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Date: $formattedDate",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Flat No: ${widget.flatNo}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Owner: ${widget.ownerName}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: buttonWidth, // Set button width to 60% of screen width
              child: ElevatedButton(
                onPressed: openCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button background color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                        color: const Color(0xFF66123A)), // Button border color
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "PAY", // Changed button text to PAY
                  style: TextStyle(
                    color: const Color(0xFF66123A), // Text color
                    fontSize: screenWidth * 0.054,
                    fontWeight: FontWeight.bold,
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
