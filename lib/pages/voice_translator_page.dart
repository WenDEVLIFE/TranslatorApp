import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:permission_handler/permission_handler.dart';
import '../component/Translator.dart';

class VoiceTranslatorPage extends StatefulWidget {
  const VoiceTranslatorPage({super.key});

  @override
  _VoiceTranslatorPageState createState() => _VoiceTranslatorPageState();
}

class _VoiceTranslatorPageState extends State<VoiceTranslatorPage> with SingleTickerProviderStateMixin {
  late SpeechRecognition _speech;
  late AnimationController _animationController;
  bool _isListening = false;
  String _text = '';
  String _translatedText = '';
  String _selectedLanguage = 'English to Mandaya';
  final Translator _translator = Translator();

  @override
  void initState() {
    super.initState();

    // Initialize the speech recognition
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler((bool result) => setState(() => _isListening = result));
    _speech.setRecognitionStartedHandler(() => setState(() => _isListening = true));
    _speech.setRecognitionResultHandler((String text) => setState(() => _text = _postProcessText(text)));
    _speech.setRecognitionCompleteHandler((String result) => setState(() => _isListening = false));
    _translator.RetrieveFromFirebase();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _speech.stop();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _requestMicrophonePermission() async {
    if (await Permission.microphone.isDenied) {
      await Permission.microphone.request();
    }
  }

  Future<void> _startListening() async {
    await _requestMicrophonePermission();
    if (!(await Permission.microphone.isGranted)) {
      print('Microphone permission not granted.');
      return;
    }

    try {
      setState(() {
        _isListening = true;
      });

      _animationController.repeat(); // Start animation
      await _speech.listen();
      print('Listening...');
    } catch (e) {
      print('Error while starting listening: $e');
      setState(() {
        _isListening = false;
      });
      _animationController.stop(); // Stop animation on error
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
    _animationController.stop(); // Stop animation
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

    String translated = await _translator.translateText(_text.toLowerCase(), sourceLanguage, targetLanguage);
    setState(() {
      _translatedText = translated;
    });
  }

  void _showListeningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  double scale = 1 + _animationController.value * 0.5;
                  return Transform.scale(
                    scale: scale,
                    child: const Icon(
                      Icons.mic,
                      size: 100,
                      color: Colors.red,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text('Listening...'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _stopListening();
                Navigator.of(context).pop();
              },
              child: const Text('Stop'),
            ),
          ],
        );
      },
    );
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
        backgroundColor: Colors.grey[800],
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo with pulsating effect
                const Image(image: AssetImage('assets/images/logo2.png'), width: 150, height: 150),
                const SizedBox(height: 10),
                const Text(
                  'VOICE TRANSLATOR',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    items: <String>['English to Mandaya', 'Mandaya to English']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage = newValue!;
                      });
                    },
                    dropdownColor: Colors.white,
                    iconEnabledColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    _startListening();
                    _showListeningDialog();
                  },
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                  label: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _translateVoice,
                  icon: const Icon(Icons.text_fields),
                  label: const Text('Translate Voice'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
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
                  width: 300,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 146, 146, 146)),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 230, 230, 230),
                  ),
                  child: Text(
                    _translatedText.isEmpty ? 'No translation yet.' : _translatedText,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}