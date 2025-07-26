import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:interview_task/constants/api.dart';
import 'package:interview_task/model/sound_model.dart';

class ApiService {
  static Future<SoundModel> fetchAudioUrls() async {
    final headers = {
      'unique-key': 'dev123',
      'Authorization': 'Bearer ${Api.authToken}', // Replace this
    };

    try {
      final apiUrl = Uri.parse(Api.baseUrl);
      final res = await http.get(apiUrl, headers: headers);
      if (res.statusCode == 200) {
        final data = SoundModel.fromJson(jsonDecode(res.body));
        return data;
      } else if (res.statusCode == 401) {
        throw Exception('UnAuthorized');
      }
      throw Exception('Something went wrong!');
    } catch (e) {
      throw Exception('Something went wrong!');
    }
  }
}
