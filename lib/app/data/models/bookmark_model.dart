class BookMark {
  int? id;
  String? surah;
  int? surah_number;
  int? ayat;
  int? juz;
  String? via;
  String? short;
  int? indexAyat;
  int? lastRead;

  BookMark(
      {this.id,
      this.surah,
      this.ayat,
      this.juz,
      this.via,
      this.short,
      this.indexAyat,
      this.lastRead});

  BookMark.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    surah = json['surah'];
    surah_number = json['surah_number'];
    ayat = json['ayat'];
    juz = json['juz'];
    via = json['via'];
    short = json['short'];
    indexAyat = json['index_ayat'];
    lastRead = json['last_read'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['surah'] = surah;
    data['surah_number'] = surah_number;
    data['ayat'] = ayat;
    data['juz'] = juz;
    data['via'] = via;
    data['short'] = short;
    data['index_ayat'] = indexAyat;
    data['last_read'] = lastRead;
    return data;
  }
}
