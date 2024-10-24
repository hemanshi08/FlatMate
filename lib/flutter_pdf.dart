import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> _downloadReceipt({
  required BuildContext context, // Add BuildContext as a required parameter
  required String requestId,
  required String flatNo,
  required String ownerName,
  required double amount,
  required String paymentMethod,
  required String paymentId,
  required String transactionId,
  required String paymentDate,
  required String title,
}) async {
  try {
    // Create a PDF document
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Payment Receipt", style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text("Owner Name: $ownerName"),
                pw.Text("Flat No: $flatNo"),
                pw.Text("Title: $title"),
                pw.Text("Amount Paid: ₹$amount"),
                pw.Text("Payment Method: $paymentMethod"),
                pw.Text("Payment ID: $paymentId"),
                pw.Text("Transaction ID: $transactionId"),
                pw.Text("Payment Date: $paymentDate"),
                pw.Text("Request ID: $requestId"),
              ],
            ),
          );
        },
      ),
    );

    // Save the PDF file
    if (await Permission.storage.request().isGranted) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/receipt_$requestId.pdf');
      await file.writeAsBytes(await pdf.save());

      // Upload PDF to Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('receipts/$requestId.pdf');
      await storageRef.putFile(file);

      // Get the download URL
      final receiptUrl = await storageRef.getDownloadURL();

      // Save receipt URL to Firebase Database
      await FirebaseDatabase.instance
          .ref()
          .child('maintenance_requests/$requestId/payments/$paymentId')
          .update({
        'receipt_url': receiptUrl,
      });

      // Notify user that the receipt has been saved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receipt saved and available for download!')),
      );
    } else {
      print('Storage permission denied');
    }
  } catch (e) {
    print('Error downloading receipt: $e');
  }
}
