class User {
  final String name;
  final String email;
  final String phone;
  final String company;
  final String website;

  User({required this.name, required this.email, required this.phone, required this.company, required this.website});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      company: json['company']['name'],
      website: json['website'],
    );
  }
}
