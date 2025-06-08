class City {
  final int id;
  final int countryId;
  final String countryTitle;
  final String title;
  final String slug;
  final String image;
  final String activeImage;

  City({
    required this.id,
    required this.countryId,
    required this.countryTitle,
    required this.title,
    required this.slug,
    required this.image,
    required this.activeImage,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['Id'],
      countryId: json['CountryId'],
      countryTitle: json['CountryTitle'],
      title: json['Title'],
      slug: json['Slug'],
      image: json['Image'],
      activeImage: json['ActiveImage'],
    );
  }
}