import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_mushaf/app/data/models/list_surah_model.dart';
import '../../../core/providers/api.dart';

class HomeRepository {
  Api api;
  HomeRepository(this.api);

  Future<ListSurah> getListSurah() {
    return api.getListSurah().then((value) {
      bool isJSON(dynamic str) {
        try {
          json.decode(str);
          return true;
        } catch (e) {
          return false;
        }
      }

      return ListSurah.fromJson(
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
