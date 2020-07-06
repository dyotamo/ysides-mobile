import 'dart:convert';

import 'package:device_id/device_id.dart';
import 'package:http/http.dart' as http;
import 'package:sides/models/question.dart';

final host = 'https://ysides.herokuapp.com';

Future<List<Question>> getQuestions() async {
  final resp = await http.get('$host/api/questions');
  return (jsonDecode(resp.body) as List)
      .map((question) => Question.fromJson(question))
      .toList();
}

Future<Question> getQuestion(questionId) async {
  final resp = await http.get('$host/api/questions/$questionId');
  return Question.fromJson(jsonDecode(resp.body));
}

Future<Question> vote(optionId) async {
  final imei = await DeviceId.getID;

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  final resp = await http.post('$host/api/vote',
      body: jsonEncode({'imei': imei, 'option': optionId}), headers: headers);

  return Question.fromJson(jsonDecode(resp.body));
}
