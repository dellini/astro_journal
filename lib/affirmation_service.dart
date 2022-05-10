import 'package:dio/dio.dart';

// ignore: body_might_complete_normally_nullable
Future<String?> getRandomAffirmation() async {
  try {
    final url = Uri.parse(
      'https://daily-affirmation-dellini.herokuapp.com/randomAffirmation',
    );
    final response = (await Dio().get<dynamic>(url.toString())).data as String;
    return response;
  } on Exception catch (e) {
    // ignore: avoid_print
    print(e);
  }
}
