import 'package:servicestack/servicestack.dart';
import 'dart:convert';

class XMLJSON implements IConvertible {
  String? question;
  String? answer;
  String? time_taken;

  XMLJSON({
    required this.question,
    required this.answer,
    required this.time_taken,
  });

  XMLJSON.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }

  @override
  fromMap(Map<String, dynamic> json, [TypeContext? context]) {
    question = json['question'];
    answer = json['answer'];
    time_taken = json['time_taken'];
    return this;
  }

  Map<String, dynamic> toJson() =>
      {'question': question, 'answer': answer, 'time_taken': time_taken};

  @override
  TypeContext? context;
}
