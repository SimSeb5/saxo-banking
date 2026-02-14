class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String clientId;
  final String segment;
  final String relationshipManager;
  final String bookingCenter;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.clientId,
    required this.segment,
    required this.relationshipManager,
    required this.bookingCenter,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}';
}
