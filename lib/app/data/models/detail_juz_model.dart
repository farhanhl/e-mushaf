// ignore_for_file: unnecessary_null_comparison

import '../../utils/audio_status.dart';

class DetailJuz {
  int? code;
  String? status;
  String? message;
  DetailJuzData? data;

  DetailJuz({this.code, this.status, this.message, this.data});

  DetailJuz.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DetailJuzData?.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class DetailJuzData {
  int? juz;
  int? juzStartSurahNumber;
  dynamic juzEndSurahNumber;
  String? juzStartInfo;
  String? juzEndInfo;
  int? totalVerses;
  List<Verses>? verses;

  DetailJuzData(
      {this.juz,
      this.juzStartSurahNumber,
      this.juzEndSurahNumber,
      this.juzStartInfo,
      this.juzEndInfo,
      this.totalVerses,
      this.verses});

  DetailJuzData.fromJson(Map<String, dynamic> json) {
    juz = json['juz'];
    juzStartSurahNumber = json['juzStartSurahNumber'];
    juzEndSurahNumber = json['juzEndSurahNumber'];
    juzStartInfo = json['juzStartInfo'];
    juzEndInfo = json['juzEndInfo'];
    totalVerses = json['totalVerses'];
    if (json['verses'] != null) {
      verses = <Verses>[];
      json['verses'].forEach((v) {
        verses?.add(Verses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['juz'] = juz;
    data['juzStartSurahNumber'] = juzStartSurahNumber;
    data['juzEndSurahNumber'] = juzEndSurahNumber;
    data['juzStartInfo'] = juzStartInfo;
    data['juzEndInfo'] = juzEndInfo;
    data['totalVerses'] = totalVerses;
    if (verses != null) {
      data['verses'] = verses?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Verses {
  Number? number;
  Meta? meta;
  Text? text;
  Translation? translation;
  Audio? audio;
  Tafsir? tafsir;
  String? surahNameLatin;
  String? surahNameArab;
  AudioStatus audioStatus = AudioStatus.stopped;

  Verses(
      {required this.audioStatus,
      this.surahNameLatin,
      this.surahNameArab,
      this.number,
      this.meta,
      this.text,
      this.translation,
      this.audio,
      this.tafsir});

  Verses.fromJson(Map<String, dynamic> json) {
    number = json['number'] != null ? Number?.fromJson(json['number']) : null;
    meta = json['meta'] != null ? Meta?.fromJson(json['meta']) : null;
    text = json['text'] != null ? Text?.fromJson(json['text']) : null;
    translation = json['translation'] != null
        ? Translation?.fromJson(json['translation'])
        : null;
    audio = json['audio'] != null ? Audio?.fromJson(json['audio']) : null;
    tafsir = json['tafsir'] != null ? Tafsir?.fromJson(json['tafsir']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (number != null) {
      data['number'] = number?.toJson();
    }
    if (meta != null) {
      data['meta'] = meta?.toJson();
    }
    if (text != null) {
      data['text'] = text?.toJson();
    }
    if (translation != null) {
      data['translation'] = translation?.toJson();
    }
    if (audio != null) {
      data['audio'] = audio?.toJson();
    }
    if (tafsir != null) {
      data['tafsir'] = tafsir?.toJson();
    }
    return data;
  }
}

class Number {
  int? inQuran;
  int? inSurah;

  Number({this.inQuran, this.inSurah});

  Number.fromJson(Map<String, dynamic> json) {
    inQuran = json['inQuran'];
    inSurah = json['inSurah'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['inQuran'] = inQuran;
    data['inSurah'] = inSurah;
    return data;
  }
}

class Meta {
  int? juz;
  int? page;
  int? manzil;
  int? ruku;
  int? hizbQuarter;
  Sajda? sajda;

  Meta(
      {this.juz,
      this.page,
      this.manzil,
      this.ruku,
      this.hizbQuarter,
      this.sajda});

  Meta.fromJson(Map<String, dynamic> json) {
    juz = json['juz'];
    page = json['page'];
    manzil = json['manzil'];
    ruku = json['ruku'];
    hizbQuarter = json['hizbQuarter'];
    sajda = json['sajda'] != null ? Sajda?.fromJson(json['sajda']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['juz'] = juz;
    data['page'] = page;
    data['manzil'] = manzil;
    data['ruku'] = ruku;
    data['hizbQuarter'] = hizbQuarter;
    if (sajda != null) {
      data['sajda'] = sajda?.toJson();
    }
    return data;
  }
}

class Sajda {
  bool? recommended;
  bool? obligatory;

  Sajda({this.recommended, this.obligatory});

  Sajda.fromJson(Map<String, dynamic> json) {
    recommended = json['recommended'];
    obligatory = json['obligatory'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['recommended'] = recommended;
    data['obligatory'] = obligatory;
    return data;
  }
}

class Text {
  String? arab;
  Transliteration? transliteration;

  Text({this.arab, this.transliteration});

  Text.fromJson(Map<String, dynamic> json) {
    arab = json['arab'];
    transliteration = json['transliteration'] != null
        ? Transliteration?.fromJson(json['transliteration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['arab'] = arab;
    if (transliteration != null) {
      data['transliteration'] = transliteration?.toJson();
    }
    return data;
  }
}

class Transliteration {
  String? en;

  Transliteration({this.en});

  Transliteration.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['en'] = en;
    return data;
  }
}

class Translation {
  String? en;
  String? id;

  Translation({this.en, this.id});

  Translation.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['en'] = en;
    data['id'] = id;
    return data;
  }
}

class Audio {
  String? primary;
  List<String>? secondary;

  Audio({this.primary, this.secondary});

  Audio.fromJson(Map<String, dynamic> json) {
    primary = json['primary'];
    secondary = json['secondary'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['primary'] = primary;
    data['secondary'] = secondary;
    return data;
  }
}

class Tafsir {
  Id? id;

  Tafsir({this.id});

  Tafsir.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? Id?.fromJson(json['id']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id?.toJson();
    }
    return data;
  }
}

class Id {
  String? short;
  String? long;

  Id({this.short, this.long});

  Id.fromJson(Map<String, dynamic> json) {
    short = json['short'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['short'] = short;
    data['long'] = long;
    return data;
  }
}
