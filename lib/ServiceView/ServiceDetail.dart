

class ServiceDetails {
  final String title;
  final String description;
  final String imageUrl;
  final String includes;
  final String readyPeriod;
  final String preparation;

  ServiceDetails({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.includes,
    required this.readyPeriod,
    required this.preparation,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      includes: json['includes'] ?? '',
      readyPeriod: json['readyPeriod'] ?? '',
      preparation: json['preparation'] ?? '',
    );
  }
}
