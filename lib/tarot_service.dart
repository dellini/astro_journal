import 'package:astro_journal/data/tarot_card.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<TarotCard?> getRandomTarotCard() async {
  try {
    final url = Uri.parse(
      'https://daily-tarot-dellini.herokuapp.com/api/v1/cards/random',
    ).replace(
      queryParameters: <String, String>{
        'n': 1.toString(),
      },
    );
    final response =
        (await Dio().get<dynamic>(url.toString())).data as Map<String, dynamic>;
    final data = response['cards'] as List<dynamic>;
    final result = TarotCard.fromJson(data.first as Map<String, dynamic>);
    return result;
  } on Exception catch (e) {
    // ignore: avoid_print
    print(e);
  }
}

Future<String> getTarotImage({
  required FirebaseStorage storage,
  required String tarotImageKey,
}) async {
  try {
    final ref = storage.ref().child('tarot/$tarotImageKey.jpg');
    final url = ref.getDownloadURL();
    return url;
  } catch (_) {
    return '';
  }
}
