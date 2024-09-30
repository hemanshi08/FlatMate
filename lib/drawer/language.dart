import 'package:flutter/material.dart';

class LanguageSelectionPage extends StatefulWidget {
  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String _selectedLanguage = 'English'; // Default selected language

  final List<String> _languages = [
    'English',
    'Hindi',
    'Gujarati',
    'Bengali',
    'Punjabi',
    'Malayalam',
    'Kannada',
    'Marathi',
    'Telugu',
    'Tamil'
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen height to set responsive spacings
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   'Language',
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 26,
        //     letterSpacing: 1,
        //   ),
        // ),
        backgroundColor: const Color(0xFF06001A),
        toolbarHeight: 60.0,
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
        padding: EdgeInsets.symmetric(
          vertical:
              screenHeight * 0.05, // Increase space between AppBar and list
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title 'Select Language'
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Add some spacing below the title
            Expanded(
              child: ListView.builder(
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenHeight * 0.02,
                      vertical: 0.1, // Decrease space between languages to 0
                    ),
                    child: RadioListTile<String>(
                      value: _languages[index],
                      groupValue: _selectedLanguage,
                      title: Text(
                        _languages[index],
                        style: TextStyle(
                          fontSize: 17, // Increased font size for the languages
                        ),
                      ),
                      activeColor: Colors.blue,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16, // Adjust padding
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
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
