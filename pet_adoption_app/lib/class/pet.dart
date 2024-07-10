class Pets{
  final int id;
  final String nama;
  final String jenis;
  final String description;
  final String keterangan;
  final String username_reviewe;

  Pets(
    {required this.id,
    required this.nama,
    required this.jenis,
    required this.keterangan,
    required this.description,
    required this.username_reviewe});
  factory Pets.fromJson(Map<String, dynamic>json){
    return Pets(
      id: json['id'] as int, 
      nama: json['nama'] as String, 
      jenis: json['jenis'] as String, 
      keterangan: json['keterangan'] == 0 ? 'Available' : 'Adopted', 
      description: json['description'] as String, 
      username_reviewe: json['username_reviewee'] as String
    );
  }
}