class Company {
  int id;
  String name;
  String address;
  String city;
  String state;
  String zip;
  String phone;
  String email;
  String website;
  String logo;
  String description;
  String createdAt;
  String updatedAt;
  List<String> accountType = ['admin', 'manager', 'staff'];

  Company({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.phone,
    required this.email,
    required this.website,
    required this.logo,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        zip: json["zip"],
        phone: json["phone"],
        email: json["email"],
        website: json["website"],
        logo: json["logo"],
        description: json["description"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "city": city,
        "state": state,
        "zip": zip,
        "phone": phone,
        "email": email,
        "website": website,
        "logo": logo,
        "description": description,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}