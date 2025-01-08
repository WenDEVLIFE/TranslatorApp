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
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red, width: 4),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.mic,
                        size: 80,
                        color: Colors.red,
                      ),
                    ],
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
            style: TextStyle(color: Colors.white,
                fontFamily: 'OpenSans',
                fontSize: 35,
                fontWeight: FontWeight.w700
            ),
          ),
          backgroundColor: Colors.grey[800],
          centerTitle: true, // Center the title
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
                const SizedBox(height: 10), // Adjusted space here
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/translation.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Select Translation Language:',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.grey[800], // Set dropdown background color to black
                    ),
                    child: DropdownButton<String>(
                      value: _selectedLanguage,
                      items: <String>['English to Mandaya', 'Mandaya to English']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.white), // Change text color here
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLanguage = newValue!;
                        });
                      },
                      dropdownColor: Colors.grey[800], // Set dropdown background color to black
                      iconEnabledColor: Colors.white,
                      style: const TextStyle(color: Colors.white), // Change text color here
                      selectedItemBuilder: (BuildContext context) {
                        return <String>['English to Mandaya', 'Mandaya to English']
                            .map<Widget>((String value) {
                          return Text(
                            value,
                            style: const TextStyle(color: Colors.white), // Change selected item text color to white
                          );
                        }).toList();
                      },
                      isExpanded: true, // Ensure the dropdown button is expanded
                      alignment: Alignment.bottomLeft, // Align the text to the left
                    ),
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
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w600,
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
                    style: const TextStyle(fontSize: 16, color: Colors.black87,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600),
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