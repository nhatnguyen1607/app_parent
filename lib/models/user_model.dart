class User {
  final String phoneNumber;
  final String name;
  final String? email;
  final String? fatherName;
  final String? motherName;
  final String? fatherPhone;
  final String? motherPhone;

  User({
    required this.phoneNumber,
    required this.name,
    this.email,
    this.fatherName,
    this.motherName,
    this.fatherPhone,
    this.motherPhone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phoneNumber: json['phoneNumber'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      fatherName: json['hotencha'],
      motherName: json['hotenme'],
      fatherPhone: json['sdt_cha'],
      motherPhone: json['sdt_me'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'fatherName': fatherName,
      'motherName': motherName,
      'fatherPhone': fatherPhone,
      'motherPhone': motherPhone,
    };
  }
}
