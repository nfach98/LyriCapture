class ImageModel {
  final String url;
  final int? height;
  final int? width;

  ImageModel({
    required this.url,
    this.height,
    this.width,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['url'],
      height: json['height'],
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'height': height,
      'width': width,
    };
  }
}
