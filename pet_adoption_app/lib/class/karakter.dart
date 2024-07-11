// ignore_for_file: non_constant_identifier_names

class Karakter {
  int karakter_id;
  String karakter_name;
  Karakter({required this.karakter_id, required this.karakter_name});
  factory Karakter.fromJSON(Map<String, dynamic> json) {
    return Karakter(
      karakter_id: json["karakter_id"],
      karakter_name: json["karakter_name"],
    );
  }
}
