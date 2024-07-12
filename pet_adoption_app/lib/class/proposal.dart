class Proposal {
  final String username;
  final int pet_id;
  final String description;
  final String status;

  Proposal(
      {required this.username,
      required this.pet_id,
      required this.description,
      required this.status});
  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      username: json['username'] as String,
      pet_id: json['pet_id'] as int,
      description: json['description'] as String,
      status: json['status'] == 0
          ? 'Pending'
          : json['status'] == 1
              ? 'Accepted'
              : 'Rejected',
    );
  }
}
