import 'package:sides/models/entity.dart';
import 'package:sides/models/option.dart';

class Question {
  int id;
  String name;
  String description;
  String category;
  Entity entity;
  List<Option> options = [];

  Question();

  get votes =>
      options.fold<int>(0, (prev, currentOption) => prev + currentOption.votes);

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    entity = json['entity'] != null ? Entity.fromJson(json['entity']) : null;
    if (json['options'] != null) {
      options = List<Option>();
      json['options'].forEach((v) {
        options.add(Option.fromJson(v));
      });
    }
  }
}
