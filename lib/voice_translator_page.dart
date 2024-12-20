import 'package:flutter/material.dart';


class VoiceTranslatorPage extends StatefulWidget {
  const VoiceTranslatorPage({super.key});

  @override
  _VoiceTranslatorPageState createState() => _VoiceTranslatorPageState();
}

class _VoiceTranslatorPageState extends State<VoiceTranslatorPage> {
  String _translatedText = ''; // Placeholder for translated text
  String _selectedLanguage = 'English to Mandaya'; // Default language option

  // Function to handle voice translation (placeholder)
  void _startVoiceTranslation() {
    setState(() {
      // Simulate a translation result for demonstration
      _translatedText = 'Translated voice text goes here!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the back arrow
        title: const Text(
          'Voice Translator',
          style:
              TextStyle(color: Colors.white), // Clear and visible title color
        ),
        backgroundColor: const Color.fromARGB(255, 0, 64, 255), // Brighter blue
      ),
      body: Container(
        color:
            const Color.fromARGB(255, 245, 245, 245), // Light gray background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Select Translation Language:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Professional dark color
                ),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedLanguage,
                items: <String>[
                  'English to Mandaya',
                  'Mandaya to English',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
                dropdownColor: Colors.white,
                iconEnabledColor: Colors.black,
              ),
              const SizedBox(height: 20),
              const Text(
                'Press the button to translate your voice:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _startVoiceTranslation,
                icon: const Icon(Icons.mic), // Voice icon
                label: const Text('Translate Voice'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: const Color.fromARGB(255, 0, 64, 255),
                  foregroundColor: Colors.white, // White text for clarity
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Translated Text:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 146, 146, 146),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 230, 230, 230),
                ),
                child: Text(
                  _translatedText.isEmpty
                      ? 'No translation yet.'
                      : _translatedText,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        selectedItemColor: const Color.fromARGB(255, 0, 64, 255),
        unselectedItemColor: Colors.black87,
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
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/'); // Navigate to Home
          } else if (index == 1) {
            Navigator.pushNamed(
                context, '/textTranslator'); // Navigate to Text Translator
          } else if (index == 2) {
            Navigator.pushNamed(context, '/voiceTranslator'); // Current Page
          }
        },
      ),
    );
  }
}
