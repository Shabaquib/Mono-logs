class CustomUser {
  final String uid;
  final String? displayName;
  final String? email;
  final bool emailVerified;
  final bool isAnonymous;
  final DateTime? createdOn;
  final DateTime? lastSignTime;
  // final String? photoUrl;

  CustomUser({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.isAnonymous,
    required this.emailVerified,
    required this.createdOn,
    required this.lastSignTime,
  });
}
