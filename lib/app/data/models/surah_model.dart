class Surah {
  String? latin;
  String? arab;

  Surah({this.latin, this.arab});

  Surah.fromJson(Map<String, dynamic> json) {
    latin = json['latin'];
    arab = json['arab'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['latin'] = latin;
    data['arab'] = arab;
    return data;
  }
}
