class AppUser {
  final String name;
  final String email;
  final String uid;

  AppUser({
    required this.name,
    required this.email,
    required this.uid,
  });

  //map to appuser
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
        name: map['name'] as String,
        email: map['email'] as String,
        uid: map['uid'] as String);
  }

  //appuser to map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
    };
  }
}
