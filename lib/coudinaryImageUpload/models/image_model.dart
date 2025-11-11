class ImageModel {
  final String id;
  final String url;
  final String referenceName;
  final DateTime timestamp;

  ImageModel({
    required this.id,
    required this.url,
    required this.referenceName,
    required this.timestamp,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json, String id) {
    return ImageModel(
      id: id,
      url: json['url'] as String,
      referenceName: json['referenceName'] as String,
      timestamp: (json['timestamp'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'referenceName': referenceName,
      'timestamp': timestamp,
    };
  }
}
