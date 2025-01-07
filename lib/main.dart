import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mandtrans_app/pages/AboutUS.dart';
import 'package:mandtrans_app/pages/voice_translator_page.dart';
import 'component/NavigationComponent.dart';
import 'database/AdminScreen.dart';
import 'database/Firebase.dart';
import 'pages/text_translator_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Error initializing Firebase: $e");
    return;
  }

   */
  await FirebaseInstance.run();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandaya Translator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 4, 2, 95)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Mandaya Translator'),
        '/textTranslator': (context) => const TextTranslatorPage(),
        '/voiceTranslator': (context) => const VoiceTranslatorPage(),
        '/aboutus': (context) => const AboutPage(),
        '/navigation': (context) => const Navigationcomponent(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Blue background for the upper half
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            color: Colors.blueAccent,
          ),
          // Main content centered
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo Image
                Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10),
                const Text(
                  'KAMAYO MOBILE TRANSLATOR',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 10, 1, 1),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                   Navigator.pushNamed(context, '/navigation');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 20),
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Choose an Option',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading:
                    const Icon(Icons.text_fields, color: Colors.blueAccent),
                title: const Text(
                  'Text Translator',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/textTranslator');
                },
              ),
              ListTile(
                leading: const Icon(Icons.mic, color: Colors.blueAccent),
                title: const Text(
                  'Voice Translator',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/voiceTranslator');
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }
}
