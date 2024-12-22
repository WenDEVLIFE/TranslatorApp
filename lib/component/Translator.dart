import 'package:http/http.dart' as http;
import 'dart:convert';

class Translator {
  final Map<String, String> _translations = {
    'hello': 'kamusta',
    'goodbye': 'paalam',
    'thank you': 'salamat',
    'lets eat': 'mokaan da kita',
    'what is your name?': 'unan pangan mo?',
    'how old are you?': 'pila yang edad mo?',
    'where did you live?': 'wayn kaw yaga\'uya?',
    'where you came from?': 'wayn kaw yaga-gikan? / wayn kaw maga\'sikon?',
    'what are you doing?': 'yaga-uno kaw?',
    'where is your house?': 'wayn yang bay mau?',
    'how are you?': 'kumusta dakaw?',
    'how are you today?': 'kumusta kaw adon?',
    'who\'s with you?': 'sino yang kaiban mo?',
    'would you like a help?': 'gusto kaw ng tabang?',
    'eat quickly!': 'pagdali kaan.',
    'give me glass water.': 'tagai ako ng is aka baso na tubig',
    'please give me your cellphone number.': 'palihog tagai ako ng kanmo selpon number.',
    'clean your face.': 'hugasi yang bayho mo.',
    'i\'m sick!': 'yamasakit ako.',
    'i\'m mad.': 'yamadaman ako.',
    'i\'m hungry.': 'yamagutom ako.',
    'my stomach is aching.': 'masakit yang tiyan ko.',
    'i have to pee.': 'kinahanglan ko mag-ihi.',
    'i am feeling dizzy.': 'gilipong ako.',
    'the food tastes bad.': 'way lami ng pagkan.',
    'the floor is messy.': 'malipa yang bantaw.',
    'what do you mean?': 'unan pasabot mo?',
    'do you know': 'yatigam kaw?',
    'what do you think?': 'unan pagtuo/pagtanaw mo?',
    'what\'s happening here?': 'unan yamahitabo ngani?',
    'where is the bedroom?': 'wayn yang higdaanan?',
    'where is the bathroom?': 'wayn yang ligoanan?',
    'where is the comfort room?': 'wayn yang kasilyasan?',
    'what is the viand?': 'unan yang utan?',
    'my name is': 'yang kanak pangan kay si...',
    'i am from...': 'gikan ako adto',
    'my age is...': 'yang edad ko kay.....',
    'i was born on': 'yama-otaw ako sangawong',
    'my parents are...': 'yang ginikanan ko kay...',
    'i have to leave': 'kinahanglan da ko mopanaw',
    'it\'s been good talking to you.': 'kadayaw mapag-storya kanmu.',
    'hope to see you again.': 'sikira magkita da isab kita balik.',
    'what are the available viands here?': 'unan yang mga utan mayo ngani?',
    'how much is this viand?': 'tagpila ngini na utan?',
    'we will dine in.': 'adi kme kaan.',
    'where is your sink?': 'hayn/hain yang lababo mayo?',
    'how much is this vegetable?': 'tagpila yani/ngining gulay?',
    'is this still fresh?': 'presko pa ngini/yani?',
    'how much is the kilo of this flue marlin?': 'tagpila yang kilo sining tulingan?',
    'i want to buy some chilli.': 'papalita da sa ako sang katumbaw.',
    'do you want to buy?': 'gusto kaw mupalit?',
    'isn\'t there any discount?': 'way hangyo sini?',
    'let me buy.': 'papalita ako',
    'here is your change.': 'dikaya yang kambyo mo.',
    'have you already been to manay?': 'ya kadto da kamo dato manay?',
    'we\'re eating a banana.': 'ya kaan kami ng saging.',
    'the food they cooked isn\'t tasty.': 'way lami nang luto nilan na pagkaan',
    'that woman is beautiful.': 'pagka gwapa da lamang siyan na bobay',
    'take the clothes hanging there.': 'kuhaa yang bado ngadto sang halayan.',
    'where are you going again?': 'hain da kaw isab mukadto?',
    'what happened to you?': 'yamauno kaw?',
    'good evening!': 'madayaw na dom!',
    'good morning everyone': 'madayaw na adlaw kamayo',
    'where are you now?': 'wain da kaw doon?',
    'we are going to manay.': 'mo kadto kami dato manay.',
    'how are you all there?': 'na kumusta da kamo ngawon?',
    'can i ask you a question?': 'pwedi ako mangutana?',
    'what is this place?': 'unan yani/ngini na lugar?',
    'how can i get there?': 'unan sakayan ko para makaabot ngadto?/unan himuon ko pra makaabot ngadto?',
    'is this place too far?': 'malayoay ngini na lugar?',
    'how can i use this?': 'unuhon paggamit sini?',
    'is it a walking distance?': 'mabaktas lang pasingod adto?',
    'how much is the fare?': 'pila yang pamasahe?',
    'come in!': 'sod adi.',
    'please sit down': 'palihog pag-ingkod.',
    'let\'s go!': 'bayda!',
    'hurry up!': 'pagdali!/pag-apas-apas!',
    'please be quiet': 'palihog katingon.',
    'shut up!': 'pagkatingon!',
    'stop it!': 'hintua yan!',
    'don\'t worry': 'ayaw pagkahawan',
    'don\'t forget': 'ayaw pagkalingawi',
    'help yourself': 'tabangi yang kanmo kaugalingon.',
    'go ahead': 'pag-una da',
    'let me know!': 'patigama ako!',
    'after you!': 'pagkatapos mo!',
    'eat quickly!': 'pagdali kaan.',
    'take it with you.': 'dalila yani adto kanmo',
    'the davao oriental state university is one of the best schools in mati.': 'yang davao oriental state university isa sa pinaka madayaw na skwelahan sang lungsod ng mati.',
    'many students at this university excel academically.': 'isa isab ngini na unibersidad na yaga prudos ng mga adaig na achiever.'
  };

  final Map<String, String> _reverseTranslations = {
    'kamusta': 'hello',
    'paalam': 'goodbye',
    'salamat': 'thank you',
    'mokaan da kita': 'lets eat',
    'unan pangan mo?': 'what is your name?',
    'pila yang edad mo?': 'how old are you?',
    'wayn kaw yaga\'uya?': 'where did you live?',
    'wayn kaw yaga-gikan? / wayn kaw maga\'sikon?': 'where you came from?',
    'yaga-uno kaw?': 'what are you doing?',
    'wayn yang bay mau?': 'where is your house?',
    'kumusta dakaw?': 'how are you?',
    'kumusta kaw adon?': 'how are you today?',
    'sino yang kaiban mo?': 'who\'s with you?',
    'gusto kaw ng tabang?': 'would you like a help?',
    'pagdali kaan.': 'eat quickly!',
    'tagai ako ng is aka baso na tubig': 'give me glass water.',
    'palihog tagai ako ng kanmo selpon number.': 'please give me your cellphone number.',
    'hugasi yang bayho mo.': 'clean your face.',
    'yamasakit ako.': 'i\'m sick!',
    'yamadaman ako.': 'i\'m mad.',
    'yamagutom ako.': 'i\'m hungry.',
    'masakit yang tiyan ko.': 'my stomach is aching.',
    'kinahanglan ko mag-ihi.': 'i have to pee.',
    'gilipong ako.': 'i am feeling dizzy.',
    'way lami ng pagkan.': 'the food tastes bad.',
    'malipa yang bantaw.': 'the floor is messy.',
    'unan pasabot mo?': 'what do you mean?',
    'yatigam kaw?': 'do you know',
    'unan pagtuo/pagtanaw mo?': 'what do you think?',
    'unan yamahitabo ngani?': 'what\'s happening here?',
    'wayn yang higdaanan?': 'where is the bedroom?',
    'wayn yang ligoanan?': 'where is the bathroom?',
    'wayn yang kasilyasan?': 'where is the comfort room?',
    'unan yang utan?': 'what is the viand?',
    'yang kanak pangan kay si...': 'my name is',
    'gikan ako adto': 'i am from...',
    'yang edad ko kay.....': 'my age is...',
    'yama-otaw ako sangawong': 'i was born on',
    'yang ginikanan ko kay...': 'my parents are...',
    'kinahanglan da ko mopanaw': 'i have to leave',
    'kadayaw mapag-storya kanmu.': 'it\'s been good talking to you.',
    'sikira magkita da isab kita balik.': 'hope to see you again.',
    'unan yang mga utan mayo ngani?': 'what are the available viands here?',
    'tagpila ngini na utan?': 'how much is this viand?',
    'adi kme kaan.': 'we will dine in.',
    'hayn/hain yang lababo mayo?': 'where is your sink?',
    'tagpila yani/ngining gulay?': 'how much is this vegetable?',
    'presko pa ngini/yani?': 'is this still fresh?',
    'tagpila yang kilo sining tulingan?': 'how much is the kilo of this flue marlin?',
    'papalita da sa ako sang katumbaw.': 'i want to buy some chilli.',
    'gusto kaw mupalit?': 'do you want to buy?',
    'way hangyo sini?': 'isn\'t there any discount?',
    'papalita ako': 'let me buy.',
    'dikaya yang kambyo mo.': 'here is your change.',
    'ya kadto da kamo dato manay?': 'have you already been to manay?',
    'ya kaan kami ng saging.': 'we\'re eating a banana.',
    'way lami nang luto nilan na pagkaan': 'the food they cooked isn\'t tasty.',
    'pagka gwapa da lamang siyan na bobay': 'that woman is beautiful.',
    'kuhaa yang bado ngadto sang halayan.': 'take the clothes hanging there.',
    'hain da kaw isab mukadto?': 'where are you going again?',
    'yamauno kaw?': 'what happened to you?',
    'madayaw na dom!': 'good evening!',
    'madayaw na adlaw kamayo': 'good morning everyone',
    'wain da kaw doon?': 'where are you now?',
    'mo kadto kami dato manay.': 'we are going to manay.',
    'na kumusta da kamo ngawon?': 'how are you all there?',
    'pwedi ako mangutana?': 'can i ask you a question?',
    'unan yani/ngini na lugar?': 'what is this place?',
    'unan sakayan ko para makaabot ngadto?/unan himuon ko pra makaabot ngadto?': 'how can i get there?',
    'malayoay ngini na lugar?': 'is this place too far?',
    'unuhon paggamit sini?': 'how can i use this?',
    'mabaktas lang pasingod adto?': 'is it a walking distance?',
    'pila yang pamasahe?': 'how much is the fare?',
    'sod adi.': 'come in!',
    'palihog pag-ingkod.': 'please sit down',
    'bayda!': 'let\'s go!',
    'pagdali!/pag-apas-apas!': 'hurry up!',
    'palihog katingon.': 'please be quiet',
    'pagkatingon!': 'shut up!',
    'hintua yan!': 'stop it!',
    'ayaw pagkahawan': 'don\'t worry',
    'ayaw pagkalingawi': 'don\'t forget',
    'tabangi yang kanmo kaugalingon.': 'help yourself',
    'pag-una da': 'go ahead',
    'patigama ako!': 'let me know!',
    'pagkatapos mo!': 'after you!',
    'pagdali kaan.': 'eat quickly!',
    'dalila yani adto kanmo': 'take it with you.',
    'yang davao oriental state university isa sa pinaka madayaw na skwelahan sang lungsod ng mati.': 'the davao oriental state university is one of the best schools in mati.',
    'isa isab ngini na unibersidad na yaga prudos ng mga adaig na achiever.': 'many students at this university excel academically.'
  };

  Future<String> translateText(String text, String sourceLanguage, String targetLanguage) async {
    String translated = '';

    if (sourceLanguage.toLowerCase() == 'english' && targetLanguage.toLowerCase() == 'mandaya') {
      translated = _translations[text.toLowerCase()] ?? 'Translation not found';
    } else if (sourceLanguage.toLowerCase() == 'mandaya' && targetLanguage.toLowerCase() == 'english') {
      translated = _reverseTranslations[text.toLowerCase()] ?? 'Translation not found';
    } else {
      translated = 'Same language selected. No translation needed.';
    }

    if (translated != 'Translation not found') {
      await _saveTranslation(text, translated, sourceLanguage, targetLanguage);
    }

    return translated;
  }

  Future<void> _saveTranslation(String sourceText, String translatedText, String sourceLanguage, String targetLanguage) async {
    final url = Uri.parse('http://localhost:27017/MobileTransApp'); // Adjust to your server URL if needed

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sourceText': sourceText,
          'translatedText': translatedText,
          'sourceLanguage': sourceLanguage,
          'targetLanguage': targetLanguage,
        }),
      );

      if (response.statusCode == 200) {
        print('Translation saved successfully!');
      } else {
        print('Failed to save translation: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}