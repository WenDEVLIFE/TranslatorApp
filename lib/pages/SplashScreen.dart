import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    LoadingEnable();
  }

  void LoadingEnable() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;

        Navigator.pushNamed(context, '/navigation');
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color:const Color.fromARGB(255, 0, 64, 255),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 400,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo2.png'),
                    fit: BoxFit.cover, // Adjust this to control how the image fits
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'MANDAYA',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black, // Color for "AID"
                        fontFamily: 'LeagueSpartan',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const TextSpan(
                      text: ' ',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white, // Color for "FOR"
                        fontFamily: 'LeagueSpartan',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: 'TRANSLATOR',
                      style: TextStyle(
                        fontSize: 40,
                        color:  Colors.white, // Color for "ANCHOR"
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10), // Adjusted height
              _isLoading
                  ? const SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
                  : const Text(''),
            ],
          ),
        ),
      ),
    );
  }
}
