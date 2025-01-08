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
    super.initState();
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
        backgroundColor: Colors.grey[800], // Light gray background
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/map.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 320,
            height: 550,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo2.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
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
                    //textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20), // Adjusted space here
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}