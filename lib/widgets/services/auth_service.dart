
class Hotel {
  final String name;
  final String address;
  final String image;

  Hotel({
    required this.name,
    required this.address,
    required this.image,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'],
      address: json['address'],
      image: json['image'],
    );
  }
}