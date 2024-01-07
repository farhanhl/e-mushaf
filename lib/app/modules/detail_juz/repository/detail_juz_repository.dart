import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../core/providers/api.dart';
import '../../../data/models/detail_juz_model.dart';

class DetailJuzRepository {
  Api api;
  DetailJuzRepository(this.api);

  Future<DetailJuz> getDetailJuz(int juz) {
    return api.getDetailJuz(juz).then((value) {
      bool isJSON(dynamic str) {
        try {
          json.decode(str);
          return true;
        } catch (e) {
          return false;
        }
      }

      return DetailJuz.fromJson(
          isJSON(value.data) ? json.decode("${value.data}") : value.data);
    }).catchError(
      (e) {
        throw Exception(e.runtimeType == DioError
            ? e.error.toString()
            : "Something went wrong");
      },
    );
  }
}
