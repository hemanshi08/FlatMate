import 'package:flatmate/UserScreens/PaymentSuccessPage.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_database/firebase_database.dart'; // For Firebase Realtime Database
import 'package:intl/intl.dart'; // For date formatting
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences

class PaymentScreen extends StatefulWidget {
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
    _getUserId();

    // Listen to successful payments
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Successful: ${response.paymentId}");

    _updatePaymentDetails(
      paymentId: response.paymentId ?? '',
      transactionId: response.paymentId ?? '',
      paymentTimestamp: DateFormat('dd MMM yyyy HH:mm').format(DateTime.now()),
    );

    // Update total expense and store it in SharedPreferences
    _updateTotalExpense(widget.amount);

    // Navigate to success page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessPage(
          paymentId: response.paymentId ?? '',
          transactionId: response.paymentId ?? '',
          userId: userId ?? '', // Pass the userId
          requestId: widget.requestId, // Pass the requestId
          ownerName: widget.ownerName, // Pass the ownerName
          flatNo: widget.flatNo, // Pass the flatNo
          amount: widget.amount, // Pass the amount
          paymentStatus: 'Paid', // Pass the payment status
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.code} - ${response.message}");
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

    DatabaseReference requestRef =
        _database.child('maintenance_requests').child(widget.requestId);
    final snapshot = await requestRef.get();

    if (snapshot.exists) {
      final paymentsSnapshot = snapshot.child('payments');
      bool paymentForUserFound = false;

      if (paymentsSnapshot.exists) {
        paymentsSnapshot.children.forEach((child) {
          if (child.key == userId) {
            requestRef.child('payments/$userId').update({
              'payment_id': paymentId,
              'transaction_id': transactionId,
              'payment_timestamp': paymentTimestamp,
              'payment_status': 'Paid',
            });
            paymentForUserFound = true;
          }
        });
      }

      if (!paymentForUserFound) {
        requestRef.child('payments/$userId').set({
          'payment_id': paymentId,
          'transaction_id': transactionId,
          'payment_timestamp': paymentTimestamp,
          'payment_method': 'Razorpay',
          'payment_status': 'Paid',
        });
      }
    } else {
      print("Maintenance request not found in the database.");
    }
  }

  // Update total expense in SharedPreferences
  Future<void> _updateTotalExpense(double amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the current total expense
    double previousTotal = prefs.getDouble('total_expense') ?? 0.0;

    // Add the new payment amount to the total expense
    double newTotal = previousTotal + amount;

    // Store the updated total expense in SharedPreferences
    await prefs.setDouble('total_expense', newTotal);

    print("Updated total expense to: $newTotal");
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_kcmiTjeyCQhbpI',
      'amount': (widget.amount * 100).toInt(),
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
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.9;
    double buttonWidth = screenWidth * 0.6;

    return Scaffold(
      backgroundColor: Colors.white,
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
              width: cardWidth,
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
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Flat No: ${widget.flatNo}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Owner Name: ${widget.ownerName}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Date: $formattedDate",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: openCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06001A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Proceed to Pay",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
