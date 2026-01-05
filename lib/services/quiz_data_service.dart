import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/countries_model.dart';

class QuizDataService {
  static Future<List<Country>> loadCountries() async {
    final data = await rootBundle.loadString('assets/data/countries.json');
    final decoded = json.decode(data);
    return (decoded['items'] as List)
        .map((e) => Country.fromJson(e))
        .toList();
  }
}
