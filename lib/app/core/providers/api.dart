import 'package:dio/dio.dart';

const baseUrl = 'https://api.quran.gading.dev';

class Api {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10 * 10000,
      receiveTimeout: 10 * 10000,
    ),
  );

  Future<Response> getListSurah() {
    return dio.get("/surah");
  }

  Future<Response> getDetailSurah(int surah) {
    return dio.get("/surah/$surah");
  }

  Future<Response> getDetailJuz(int juz) {
    return dio.get("/juz/$juz");
  }
}
