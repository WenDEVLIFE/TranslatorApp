import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:permission_handler/permission_handler.dart';
import '../component/Translator.dart';

class VoiceTranslatorPage extends StatefulWidget {
  const VoiceTranslatorPage({super.key});

  @override
  _VoiceTranslatorPageState createState() => _VoiceTranslatorPageState();
}

class _VoiceTranslatorPageState extends State<VoiceTranslatorPage> {
  late SpeechRecognition _speech;
  bool _isListening = false;
  String _text = '';
  String _translatedText = '';
  String _selectedLanguage = 'English to Mandaya';
  final Translator _translator = Translator();
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler((bool result) => setState(() => _isListening = result));
    _speech.setRecognitionStartedHandler(() => setState(() => _isListening = true));
    _speech.setRecognitionResultHandler((String text) => setState(() => _text = _postProcessText(text)));
    _speech.setRecognitionCompleteHandler((String result) => setState(() => _isListening = false));
    _translator.RetrieveFromFirebase();
  }

  Future<void> _requestMicrophonePermission() async {
    if (await Permission.microphone.isDenied) {
      await Permission.microphone.request();
    }
  }

  Future<void> _startListening() async {
    // Request microphone permission
    await _requestMicrophonePermission();
    if (!(await Permission.microphone.isGranted)) {
      print('Microphone permission not granted.');
      return;
    }

    // Start listening if permission is granted
    try {
      setState(() {
        _isListening = true; // Update the listening status
      });

      // Start the listening process
      await _speech.listen(); // No named parameters
      print('Listening...');
    } catch (e) {
      print('Error while starting listening: $e');
      setState(() {
        _isListening = false; // Reset listening status in case of an error
      });
    }
  }


  String _postProcessText(String recognizedWords) {
    final corrections = {
      'nissan': 'disan',
      'design': 'disan',
      'duty': 'dyutay',
      'new thai': 'dyutay',
      'basel': 'baso',
    };
    return corrections[recognizedWords.toLowerCase()] ?? recognizedWords;
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
                icon: const Icon(Icons.text_fields),
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
    );
  }
}