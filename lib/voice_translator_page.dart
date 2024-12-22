import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'component/Translator.dart';

class VoiceTranslatorPage extends StatefulWidget {
  const VoiceTranslatorPage({super.key});

  @override
  _VoiceTranslatorPageState createState() => _VoiceTranslatorPageState();
}

class _VoiceTranslatorPageState extends State<VoiceTranslatorPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  String _translatedText = '';
  String _selectedLanguage = 'English to Mandaya';
  final Translator _translator = Translator();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _startListening() async {
    if (await Permission.microphone.request().isGranted) {
      bool available = await _speech.initialize(
        onStatus: (val) => setState(() => _isListening = val == 'listening'),
        onError: (val) => setState(() => _isListening = false),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print('Recognized words: $_text'); // Debugging statement
          }),
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _translatedText = 'Microphone permission denied';
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _translateVoice() async {
    if (_text.isEmpty) {
      setState(() {
        _translatedText = 'No voice input detected.';
      });
      return;
    } else {
      setState(() {
        _translatedText = 'Translating...';
      });
    }

    String sourceLanguage = _selectedLanguage == 'English to Mandaya' ? 'English' : 'Mandaya';
    String targetLanguage = _selectedLanguage == 'English to Mandaya' ? 'Mandaya' : 'English';

    // Convert the recognized words to lowercase
    String translated = await _translator.translateText(_text.toLowerCase(), sourceLanguage, targetLanguage);
    setState(() {
      _translatedText = translated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Voice Translator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 64, 255),
      ),
      body: Container(
        color: const Color.fromARGB(255, 245, 245, 245),
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
                  color: Colors.black87,
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
                onPressed: _isListening ? _stopListening : _startListening,
                icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                label: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: const Color.fromARGB(255, 0, 64, 255),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Listening: $_isListening',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _translateVoice,
                icon: const Icon(Icons.translate),
                label: const Text('Translate Voice'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: const Color.fromARGB(255, 0, 64, 255),
                  foregroundColor: Colors.white,
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
                  _translatedText.isEmpty ? 'No translation yet.' : _translatedText,
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
          /*
      BottomNavigationBarItem(
            icon: Icon(Icons.language),
            label: 'Language',
          ),

           */

        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/'); // Navigate to Home
          } else if (index == 1) {
            Navigator.pushNamed(context, '/textTranslator'); // Navigate to Text Translator
          } else if (index == 2) {
            Navigator.pushNamed(context, '/voiceTranslator'); // Current Page
          }
          else if (index == 3) {
            Navigator.pushNamed(context, '/admin');
          }
        },
      ),
    );
  }
}