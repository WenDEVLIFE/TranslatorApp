import 'package:flutter/material.dart';
import 'package:mandtrans_app/database/InitSQLite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../component/Translator.dart'; // Adjust the import path

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
  late stt.SpeechToText _speech;
  bool _isAvailable = false;
  bool _isListening = false;

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

  Future<void> _initSpeech() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      setState(() {
        _isAvailable = available;
      });
    } else {
      setState(() {
        _isAvailable = false;
      });
      print('Microphone permission not granted');
    }
  }

  void _startListening() {
    if (_isAvailable && !_isListening) {
      _speech.listen(
        onResult: (val) => setState(() {
          _textController.text = val.recognizedWords;
        }),
      );
      setState(() {
        _isListening = true;
      });
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _translator.RetrieveFromFirebase();
    InitSQLite().printTranslations();
    InitSQLite().printReverseTranslations();
    setState(() {
      _selectedLanguage = 'English to Mandaya';
      _sourceLanguage = 'English';
      _targetLanguage = 'Mandaya';
    });
    _speech = stt.SpeechToText();
    _initSpeech();
  }

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
                icon: const Icon(Icons.text_fields, color: Colors.white), // Icon color
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
            Navigator.pushNamed(context, '/aboutus');
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
          )
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About Us',
          ),
        ],
      ),
    );
  }
}