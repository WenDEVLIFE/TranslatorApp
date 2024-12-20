import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import for json encoding

class TextTranslatorPage extends StatefulWidget {
  const TextTranslatorPage({super.key});

  @override
  _TextTranslatorPageState createState() => _TextTranslatorPageState();
}

class _TextTranslatorPageState extends State<TextTranslatorPage> {
  String _sourceLanguage = 'English';
  String _targetLanguage = 'Mandaya';
  final TextEditingController _textController = TextEditingController();
  String _translatedText = '';

  // Manual translation mappings
  final Map<String, String> _translations = {
    'hello': 'kamusta',
    'goodbye': 'paalam',
    'thank you': 'salamat',
    'lets eat': 'mokaan da kita',
  };

  final Map<String, String> _reverseTranslations = {
    'kamusta': 'hello',
    'paalam': 'goodbye',
    'salamat': 'thank you',
    'mokaan da kita': 'lets eat',
  };

  // Simulate translation logic
  Future<void> _translateText() async {
    String translated = '';

    if (_sourceLanguage == 'English' && _targetLanguage == 'Mandaya') {
      translated = _translations[_textController.text.toLowerCase()] ??
          'Translation not found';
    } else if (_sourceLanguage == 'Mandaya' && _targetLanguage == 'English') {
      translated = _reverseTranslations[_textController.text.toLowerCase()] ??
          'Translation not found';
    } else {
      translated = 'Same language selected. No translation needed.';
    }

    setState(() {
      _translatedText = translated;
    });

    // Save the translation to MongoDB
    if (_translatedText != 'Translation not found') {
      await _saveTranslation(
          _textController.text, translated, _sourceLanguage, _targetLanguage);
    }
  }

  Future<void> _saveTranslation(String sourceText, String translatedText,
      String sourceLanguage, String targetLanguage) async {
    final url = Uri.parse(
        'http://localhost:27017/MobileTransApp'); // Adjust to your server URL if needed

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sourceText': sourceText,
          'translatedText': translatedText,
          'sourceLanguage': sourceLanguage,
          'targetLanguage': targetLanguage,
        }),
      );

      if (response.statusCode == 200) {
        print('Translation saved successfully!');
      } else {
        print('Failed to save translation: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow
        title: const Text(
          'Text Translator',
          style:
              TextStyle(color: Colors.white), // Clear, professional text color
        ),
        backgroundColor:
            const Color.fromARGB(255, 0, 64, 255), // Clean blue background
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
              'From:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<String>(
                value: _sourceLanguage,
                isExpanded: true,
                underline: Container(),
                items: <String>['English', 'Mandaya'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _sourceLanguage = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown for Target Language
            const Text(
              'To:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<String>(
                value: _targetLanguage,
                isExpanded: true,
                underline: Container(),
                items: <String>['English', 'Mandaya'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _targetLanguage = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20), // Reduced space here

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                icon: const Icon(Icons.translate,
                    color: Colors.white), // Icon color
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
                _translatedText.isEmpty
                    ? 'No translation yet'
                    : _translatedText,
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
            Navigator.pushNamed(
                context, '/voiceTranslator'); // Navigate to Voice Translator
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
