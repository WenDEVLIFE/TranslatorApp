import 'package:flutter/material.dart';
import 'component/Translator.dart'; // Adjust the import path

class TextTranslatorPage extends StatefulWidget {
  const TextTranslatorPage({super.key});

  @override
  _TextTranslatorPageState createState() => _TextTranslatorPageState();
}

class _TextTranslatorPageState extends State<TextTranslatorPage> {
  String _selectedLanguage = 'English to Mandaya';
  String _sourceLanguage = 'English';
  String _targetLanguage = 'Mandaya';
  final TextEditingController _textController = TextEditingController();
  String _translatedText = '';
  final Translator _translator = Translator();

  Future<void> _translateText() async {
    String translated = await _translator.translateText(
      _textController.text,
      _sourceLanguage,
      _targetLanguage,
    );

    setState(() {
      _translatedText = translated;
    });
  }

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow
        title: const Text(
          'Text Translator',
          style: TextStyle(color: Colors.white), // Clear, professional text color
        ),
        backgroundColor: const Color.fromARGB(255, 0, 64, 255), // Clean blue background
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            const Text(
              'Easily translate text between English and Mandaya.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20), // Adjusted space here

            // Dropdown for Source Language
            const Text(
              'Select Translation Language:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
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
                  if (_selectedLanguage == 'English to Mandaya') {
                    _sourceLanguage = 'English';
                    _targetLanguage = 'Mandaya';
                  } else {
                    _sourceLanguage = 'Mandaya';
                    _targetLanguage = 'English';
                  }
                });
              },
              dropdownColor: Colors.white,
              iconEnabledColor: Colors.black,
            ),

            // Text input for translation
            const Text(
              'Enter Text:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type your text here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20), // Reduced space here

            // Translate Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _translateText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 64, 255),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                icon: const Icon(Icons.translate, color: Colors.white), // Icon color
                label: const Text(
                  'Translate Text', // Button text
                  style: TextStyle(color: Colors.white), // Text color
                ),
              ),
            ),
            const SizedBox(height: 20), // Adjusted space after button

            // Display Translated Text
            const Text(
              'Translated Text:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.all(7),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Text(
                _translatedText.isEmpty ? 'No translation yet' : _translatedText,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        ],
      ),
    );
  }
}