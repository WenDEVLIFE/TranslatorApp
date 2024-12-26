import 'package:flutter/material.dart';
import 'package:mandtrans_app/database/InitSQLite.dart';
import '../component/Translator.dart'; // Adjust the import path

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  aboutState createState() => aboutState();
}

class aboutState extends State<AboutPage> {


  int _currentIndex = 3;

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white), // Clear, professional text color
        ),
        backgroundColor: const Color.fromARGB(255, 0, 64, 255), // Clean blue background
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '"Kamayo Translator" . With this application, you may translate from Mandaya to English and vice versa. The software will promote unity among users while also aiding in the preservation of the Mandaya language and culture.'
                      ' Additionally, the application will support the Mandaya people in preserving their language and cultural identity while promoting cultural awareness among non-Speakers.'
                      'To guarantee correctness, the application entails gathering and evaluating language data with native speakers. Speech recognition, offline capabilities, and real-time text and voice translation will all be included in the program.'
                      ' In order to help users better understand Mandaya culture, it will also provide cultural remarks and contextual information. Community input will guarantee that the app satisfies Mandaya\'s requirements.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'OpenSans',

                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
            SizedBox(height: 20), // Adjusted space here
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        selectedItemColor: const Color.fromARGB(255, 0, 64, 255),
        unselectedItemColor: Colors.black87,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            Navigator.pushNamed(context, '/'); // Navigate to Home
          } else if (index == 1) {
            // Stay on the text translator page
          } else if (index == 2) {
            Navigator.pushNamed(context, '/voiceTranslator'); // Navigate to Voice Translator
          } else if (index == 3) {
            // Stay on the admin page

          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'Text',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Voice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About Us',
          ),
        ],
      ),
    );
  }
}