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

        Navigator.pushReplacementNamed(context, '/splashscreen1');
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 66, 66, 66),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover, // Adjust this to control how the image fits
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'MINANDAYA ',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white, // Color for "AID"
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const TextSpan(
                      text: 'MOBILE ',
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
                        fontFamily: 'OpenSans',
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
