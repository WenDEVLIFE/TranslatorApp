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
    loadTranslationsFromSQLite();
    if (sourceLanguage == 'English' && targetLanguage == 'Mandaya') {
      // Split the input text into words
      List<String> words = inputText.toLowerCase().split(' ');

      // Translate each word
      List<String> translatedWords = words.map((word) {
        return _translations.containsKey(word) ? _translations[word]! : word;
      }).toList();

      // Return the translated text
      return translatedWords.join(' ');
    } else if (sourceLanguage == 'Mandaya' && targetLanguage == 'English') {
      List<String> words = inputText.toLowerCase().split(' ');

      List<String> translatedWords = words.map((word) {
        return _reverseTranslations.containsKey(word) ? _reverseTranslations[word]! : word;
      }).toList();

      return translatedWords.join(' ');
    } else {
      return 'Unsupported translation';
    }


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
      print('Error retrieving translations: $e');
      return {};
    }
  }

  Future<Map<String, String>> getTranslations2() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
      print('Error retrieving translations: $e');
      return {};
    }
  }


}