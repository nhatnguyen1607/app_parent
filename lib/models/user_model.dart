class User {
  final String phoneNumber;
  final String name;
  final String? email;

  User({
    required this.phoneNumber,
    required this.name,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phoneNumber: json['phoneNumber'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
    };
  }
}
