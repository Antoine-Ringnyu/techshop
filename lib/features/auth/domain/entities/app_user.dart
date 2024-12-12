class AppUser {
  final String name;
  final String email;
  final String uid;

  AppUser({
    required this.name,
    required this.email,
    required this.uid,
  });

  //convert app user -> json
  Map<String, dynamic> toJason() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }

  //conver json -> app user
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      name: jsonUser['name'],
      email: jsonUser['email'],
      uid: jsonUser['uid'],
    );
  }
}
