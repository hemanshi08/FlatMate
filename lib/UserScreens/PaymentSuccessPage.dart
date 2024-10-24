import 'package:flatmate/UserScreens/user_dashboard.dart';
import 'package:flatmate/services/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'dart:io';

class PaymentSuccessPage extends StatelessWidget {
  final String paymentId;
  final String transactionId;
  final String userId;
  final String requestId;
  final String ownerName; // Add these
  final String flatNo;
  final double amount; // Add these
  final String paymentStatus; // Add paymentStatus

  //final String paymentStatus; // Add these

  const PaymentSuccessPage({
    Key? key,
    required this.paymentId,
    required this.transactionId,
    required this.userId,
    required this.requestId,
    required this.ownerName, // Accept ownerName
    required this.flatNo,
    required this.amount, // Pass amount     // Accept flatNo
    required this.paymentStatus, // Accept paymentStatus
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Call the upload receipt function with all required parameters
    uploadReceiptAndGenerateURL(
      paymentId,
      transactionId,
      ownerName,
      flatNo,
      userId, // Pass userId
      requestId, // Pass requestId
      amount, // Pass amount
      paymentStatus, // Pass paymentStatus
      context,
    );
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

  Future<void> uploadReceiptAndGenerateURL(
      String paymentId,
      String transactionId,
      String ownerName,
      String flatNo,
      String userId, // New parameter
      String requestId, // New parameter
      double amount, // Changed from String to double
      String paymentStatus, // New parameter
      BuildContext context) async {
    try {
      // Generate the PDF receipt with the updated method
      final pdfService = PdfService();

      // Format current timestamp for receipt
      String currentTimestamp =
          DateFormat('dd MMM yyyy HH:mm').format(DateTime.now());

      final pdfFile = await pdfService.generatePdfReceipt(
        title: "Maintenance Receipt",
        amount: amount.toString(), // Convert amount to String
        date: currentTimestamp,
        paymentMethod: "Razorpay",
        ownerName: ownerName,
        flatNo: flatNo,
        paymentStatus: paymentStatus, // Pass the status if available
      );

      // Check if the PDF file exists and is valid
      if (!await pdfFile.exists() || await pdfFile.length() == 0) {
        print('PDF file does not exist or is empty: ${pdfFile.path}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF file generation failed.')),
        );
        return; // Exit if the PDF is not valid
      }

      // Log the PDF file path
      print('PDF File path: ${pdfFile.path}');

      // Request storage permission
      await requestStoragePermission(context);

      if (await Permission.storage.isGranted) {
        // Define Firebase Storage reference
        final storageRef =
            FirebaseStorage.instance.ref().child('receipts/$paymentId.pdf');
        print('Uploading PDF to: receipts/$paymentId.pdf');

        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Uploading receipt...')),
        );

        // Upload the PDF to Firebase Storage
        await storageRef.putFile(pdfFile).then((taskSnapshot) async {
          print('Upload task state: ${taskSnapshot.state}');

          // Get the download URL of the uploaded file
          final receiptUrl = await storageRef.getDownloadURL();
          if (receiptUrl.isNotEmpty) {
            // Update the payment record in the database with the receipt URL
            await FirebaseDatabase.instance
                .ref()
                .child(
                    'maintenance_requests/$requestId/payments/$userId') // Use requestId and userId
                .update({
              'receipt_url': receiptUrl,
              'payment_status':
                  paymentStatus, // Update with the passed paymentStatus
              'payment_timestamp': DateTime.now().toIso8601String(),
            });

            print('Receipt uploaded and URL generated: $receiptUrl');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Receipt uploaded successfully!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to retrieve receipt URL.')),
            );
          }
        }).catchError((error) {
          // Handle upload error
          print('Upload failed: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload receipt: $error')),
          );
        });
      } else {
        print("Storage permission denied");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Storage permission denied. Cannot upload receipt.')),
        );
      }
    } catch (e) {
      print('Error uploading receipt: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading receipt: $e')),
      );
    }
  }

  // Function to request storage permission
  Future<void> requestStoragePermission(BuildContext context) async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      // Request permission
      final result = await Permission.storage.request();
      if (result.isGranted) {
        print("Storage permission granted");
      } else {
        print("Storage permission denied");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Storage permission denied. Cannot upload receipt.')),
        );
      }
    } else if (status.isGranted) {
      print("Storage permission already granted");
    }
  }
}
