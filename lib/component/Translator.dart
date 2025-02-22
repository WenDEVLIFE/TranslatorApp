import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mandtrans_app/database/InitSQLite.dart';

class Translator {

  // The purpose of this is for testing purposes only
  // Madaya to English translations
  late Map<String, String> _translations = {};

  // English to Mandaya translations
  late Map<String, String> _reverseTranslations = {};
  Future<void> loadTranslationsFromSQLite() async {
    _translations = await InitSQLite().getTranslationsFromSQLite();
    _reverseTranslations = await InitSQLite().getReverseTranslationsFromSQLite();
  }

  Future<String> translateText(String inputText, String sourceLanguage, String targetLanguage) async {
  await loadTranslationsFromSQLite(); // Ensure data is loaded before translation

  Map<String, String> dictionary = (sourceLanguage == 'English' && targetLanguage == 'Mandaya') 
      ? _translations 
      : (sourceLanguage == 'Mandaya' && targetLanguage == 'English') 
        ? _reverseTranslations 
        : {};

  if (dictionary.isEmpty) {
    return 'Unsupported translation';
  }

  String translatedText = inputText.toLowerCase(); 

  // First, check if there are phrase translations
  dictionary.keys
      .where((key) => key.contains(' ')) // Only look for phrases first
      .forEach((phrase) {
        if (translatedText.contains(phrase)) {
          translatedText = translatedText.replaceAll(phrase, dictionary[phrase]!);
        }
      });

  // Then, translate remaining words
  translatedText = translatedText
      .split(' ')
      .map((word) => dictionary.containsKey(word) ? dictionary[word]! : word)
      .join(' ');

  return translatedText;
}

  Future <void> RetrieveFromFirebase () async{

    Map<String, String> translations = await getTranslations1();
    Map<String, String> reverseTranslations = await getTranslations2();

    print('Translations: $translations');
    print('Reverse Translations: $reverseTranslations');
    insertToSQLite(translations, reverseTranslations);
  }
  Future<void> insertToSQLite(Map<String, String> translations, Map<String, String> reverseTranslations) async {
    try {
      // Insert _translations
      //await FirebaseFirestore.instance.collection('EnglishCollection').doc().set(_translations);

      // Insert _reverseTranslations
      //await FirebaseFirestore.instance.collection('MandayaCollection').doc().set(_reverseTranslations);

      // Store translations in SQLite
      await InitSQLite().storeTranslationsInSQLite(translations);
      await InitSQLite().storeReverseTranslationsInSQLite(reverseTranslations);

      print('Translations inserted successfully!');
    } catch (error) {
      print('Error inserting translations: $error');
    }
  }

  Future<Map<String, String>> getTranslations1() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    const int maxRetries = 5;
    int retryCount = 0;
    Duration delay = Duration(seconds: 1);

    while (retryCount < maxRetries) {
      try {
        DocumentSnapshot snapshot = await _firestore.collection("EnglishCollection").doc('dljOVeQs8xdpcybZuQxo').get();
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          print('Translations found');
          return data.map((key, value) => MapEntry(key, value.toString()));
        } else {
          print('No translations found');
          return {};
        }
      } catch (e) {
        if (e is FirebaseException && e.code == 'unavailable') {
          retryCount++;
          print('Retry $retryCount: Firestore service unavailable, retrying in $delay...');
          await Future.delayed(delay);
          delay *= 2; // Exponential backoff
        } else {
          print('Error retrieving translations: $e');
          return {};
        }
      }
    }
    print('Failed to fetch translations after $maxRetries retries.');
    return {};
  }

  Future<Map<String, String>> getTranslations2() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    const int maxRetries = 5;
    int retryCount = 0;
    Duration delay = Duration(seconds: 1);

    while (retryCount < maxRetries) {
      try {
        DocumentSnapshot snapshot = await _firestore.collection("MandayaCollection").doc('57UXvyBqAGiNR6Z6yVY8').get();
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          print('Reverse Translations found');
          return data.map((key, value) => MapEntry(key, value.toString()));
        } else {
          print('No translations found');
          return {};
        }
      } catch (e) {
        if (e is FirebaseException && e.code == 'unavailable') {
          retryCount++;
          print('Retry $retryCount: Firestore service unavailable, retrying in $delay...');
          await Future.delayed(delay);
          delay *= 2; // Exponential backoff
        } else {
          print('Error retrieving translations: $e');
          return {};
        }
      }
    }
    print('Failed to fetch translations after $maxRetries retries.');
    return {};
  }
}
