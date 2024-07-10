class Pets {
  final int id;
  final String nama;
  final String jenis;
  final String lokasi;
  final String age;
  final String gender;
  final String coat_length;
  final List? karakter;
  final List? health;
  final String description;
  final String keterangan;
  final String username_reviewee;

  Pets(
      {required this.id,
      required this.nama,
      required this.jenis,
      required this.lokasi,
      required this.age,
      required this.gender,
      required this.coat_length,
      required this.karakter,
      required this.health,
      required this.keterangan,
      required this.description,
      required this.username_reviewee});
  factory Pets.fromJson(Map<String, dynamic> json) {
    return Pets(
        id: json['id'] as int,
        nama: json['nama'] as String,
        jenis: json['jenis'] as String,
        lokasi: json['lokasi'] as String,
        age: json['age'] == 0 ? 'Young' : 'Old',
        gender: json['gender'] == 0 ? 'Male' : 'Female',
        coat_length: json['coat_length'] == 0
            ? 'Short'
            : json['coat_length'] == 1
                ? 'Long'
                : 'Hairless',
        karakter: json['karakter'],
        health: json['health'],
        keterangan: json['keterangan'] == 0 ? 'Available' : 'Adopted',
        description: json['description'] as String,
        username_reviewee: json['username_reviewee'] as String);
  }
}
