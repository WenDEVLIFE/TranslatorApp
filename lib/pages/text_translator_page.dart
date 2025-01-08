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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Text Translator',
          style: TextStyle(color: Colors.white,
              fontFamily: 'OpenSans',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10), // Adjusted space here
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/language.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Adjusted space here
                  // Dropdown for Source Language
                  const Text(
                    'Select Translation Language:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                            if (_selectedLanguage == 'English to Mandaya') {
                              _sourceLanguage = 'English';
                              _targetLanguage = 'Mandaya';
                            } else {
                              _sourceLanguage = 'Mandaya';
                              _targetLanguage = 'English';
                            }
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
                        backgroundColor: Colors.grey[800], // Light gray background
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
                  const SizedBox(height: 20), // Adjusted space after translated text
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}