class SliderItem {
  final int id;
  final String title;
  final String url;
  final String image;

  SliderItem({
    required this.id,
    required this.title,
    required this.url,
    required this.image,
  });

  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      id: json['Id'],
      title: json['Title'],
      url: json['Url'],
      image: json['Image'],
    );
  }
}