import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditCardPaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.06, // Responsive font size
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: screenHeight * 0.08, // Responsive toolbar height
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Go back to previous page
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.08), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02), // Responsive space
            Center(
              child: Text(
                'Fill Details',
                style: TextStyle(
                  fontSize: screenWidth * 0.065, // Responsive title size
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03), // Responsive space

            // Name on card field
            TextField(
              decoration: InputDecoration(
                labelText: 'Name on card',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive space

            // Card number field
            TextField(
              decoration: InputDecoration(
                labelText: 'Card number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive space

            // Expiration date and security code in a row
            Row(
              children: [
                // Expiration date field
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Expiration date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                SizedBox(
                    width:
                        screenWidth * 0.05), // Responsive space between fields

                // Security code field
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Security code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04), // Responsive space

            // Pay Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Show success dialog after clicking Pay
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.transparent,
                        contentPadding: EdgeInsets.zero,
                        content: PaymentSuccessDialog(),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.25, // Responsive button width
                    vertical: screenHeight * 0.013, // Responsive button height
                  ),
                  backgroundColor: const Color(0xFFD8AFCC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Pay',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF66123A),
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

class PaymentSuccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.7, // Responsive dialog width
      height: screenHeight * 0.4, // Responsive dialog height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular icon with checkmark
          Container(
            width: screenWidth * 0.2,
            height: screenHeight * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.1),
            ),
            child: Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: screenWidth * 0.15, // Responsive icon size
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03), // Space below icon
          // Payment success message
          Text(
            'Payment Successful',
            style: TextStyle(
              fontSize: screenWidth * 0.06, // Responsive font size
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class OnlinePaymentScreen extends StatelessWidget {
  final String googlePayUrl =
      "https://pay.google.com"; // URL to open Google Pay

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Online Payment',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.06,
          ),
        ),
        backgroundColor: const Color(0xFF06001A),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Proceed to Pay with Google Pay',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await canLaunch(googlePayUrl)) {
                  await launch(googlePayUrl);
                } else {
                  throw 'Could not launch $googlePayUrl';
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD8AFCC), // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.2,
                  vertical: MediaQuery.of(context).size.height * 0.015,
                ),
              ),
              child: Text(
                'Open Google Pay',
                style: TextStyle(
                  color: const Color(0xFF66123A),
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentMethod = 1; // Default selection is Credit Card

  @override
  Widget build(BuildContext context) {
    // Fetch screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.065, // Responsive font size
            letterSpacing: 1,
          ),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: screenHeight * 0.08, // Responsive toolbar height
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Go back to MaintenancePage
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.08), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02), // Responsive space
            Text(
              'Choose Method Of Payment',
              style: TextStyle(
                fontSize: screenWidth * 0.045, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive space

            // Credit Card Option
            Row(
              children: [
                Radio(
                  value: 1,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value as int;
                    });
                  },
                ),
                Text(
                  'Credit card',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Responsive font size
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Spacer(),
                Image.asset(
                  'assets/visa_mastercard.jpg', // Add the asset image here for VISA and Mastercard
                  width: screenWidth * 0.1, // Responsive image width
                  height: screenHeight * 0.05, // Responsive image height
                ),
              ],
            ),

            // Online Payment Option
            Row(
              children: [
                Radio(
                  value: 2,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value as int;
                    });
                  },
                ),
                Text(
                  'Online Payment',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Responsive font size
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Spacer(),
                Image.asset(
                  'assets/online_payment.jpg', // Add the asset image here for Online Payment
                  width: screenWidth * 0.1, // Responsive image width
                  height: screenHeight * 0.05, // Responsive image height
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.04), // Responsive space

            // Next Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedPaymentMethod == 1) {
                    // Navigate to Credit Card Payment Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreditCardPaymentScreen(),
                      ),
                    );
                  } else if (_selectedPaymentMethod == 2) {
                    // Navigate to Online Payment Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnlinePaymentScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.2, // Responsive button width
                    vertical: screenHeight * 0.013, // Responsive button height
                  ),
                  backgroundColor: const Color(0xFFD8AFCC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'NEXT',
                  style: TextStyle(
                    fontSize: screenWidth * 0.040, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF66123A),
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
