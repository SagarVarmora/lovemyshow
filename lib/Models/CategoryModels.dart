class Category {
  final int id;
  final String title;
  final String slug;
  final String content;
  final String image;
  final String hidImage;
  final String icon;
  final String hidIcon;
  final int status;
  final String entDt;

  Category({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    required this.image,
    required this.hidImage,
    required this.icon,
    required this.hidIcon,
    required this.status,
    required this.entDt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['Id'],
      title: json['Title'],
      slug: json['Slug'],
      content: json['Content'],
      image: json['Image'],
      hidImage: json['Hid_Image'],
      icon: json['Icon'],
      hidIcon: json['Hid_Icon'],
      status: json['Status'],
      entDt: json['EntDt'],
    );
  }
}