class Country {
  final int id;
  final String title;
  final String slug;
  final String image;

  Country({
    required this.id,
    required this.title,
    required this.slug,
    required this.image,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['Id'],
      title: json['Title'],
      slug: json['Slug'],
      image: json['Image'],
    );
  }
}