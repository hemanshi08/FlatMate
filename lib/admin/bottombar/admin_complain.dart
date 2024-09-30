import 'package:flutter/material.dart';

class AdminComplain extends StatefulWidget {
  @override
  _AdminComplainState createState() => _AdminComplainState();
}

class _AdminComplainState extends State<AdminComplain> {
  List<Map<String, String>> complaints = [
    {
      "title": "Water Leakage",
      "date": "07/26/2024",
      "details":
          "There is a water leakage in the basement. Please fix it as soon as possible.",
      "wingFlatNo": "A-101",
      "ownerName": "John Doe",
    },
    {
      "title": "Broken Elevator",
      "date": "08/26/2024",
      "details":
          "The elevator in Building B is not working. Residents are having difficulties.",
      "wingFlatNo": "B-305",
      "ownerName": "Jane Smith",
    },
  ];

  void _solveComplaint(int index) {
    setState(() {
      complaints.removeAt(index); // Remove the complaint from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    double paddingValue = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complaints',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: screenHeight * 0.08,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: screenHeight * 0.02, // Reduced bottom space
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(paddingValue * 0.7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8AFCC),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                complaints[index]["title"]!,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF66123A),
                                  letterSpacing: 0.6,
                                ),
                              ),
                              Text(
                                complaints[index]["date"]!,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF66123A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(paddingValue),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                complaints[index]["details"]!,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.black,
                                  letterSpacing:
                                      0.3, // Increased letter spacing
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                  height:
                                      screenHeight * 0.008), // Reduced space
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _solveComplaint(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 60, 206, 235),
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight *
                                            0.004, // Smaller padding
                                        horizontal: screenWidth * 0.04,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      'SOLVE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 0.8,
                                        fontWeight: FontWeight.w800,
                                        fontSize: screenWidth * 0.034,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        complaints[index]["wingFlatNo"]!,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 35, 141, 183),
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      Text(
                                        complaints[index]["ownerName"]!,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color:
                                              Color.fromARGB(255, 35, 141, 183),
                                          letterSpacing: 0.3,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
