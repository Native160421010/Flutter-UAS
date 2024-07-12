// ignore_for_file: non_constant_identifier_names

class Health {
  int health_id;
  String health_name;
  Health({required this.health_id, required this.health_name});
  factory Health.fromJSON(Map<String, dynamic> json) {
    return Health(
      health_id: json["health_id"],
      health_name: json["health_name"],
    );
  }
}