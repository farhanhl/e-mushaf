import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_mushaf/app/data/models/detail_surah_model.dart';
import '../../../core/providers/api.dart';

class DetailSurahRepository {
  Api api;
  DetailSurahRepository(this.api);

  getDetailSurah(int surah) {
    return api.getDetailSurah(surah).then((value) {
      bool isJSON(dynamic str) {
        try {
          json.decode(str);
          return true;
        } catch (e) {
          return false;
        }
      }

      return DetailSurah.fromJson(
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
