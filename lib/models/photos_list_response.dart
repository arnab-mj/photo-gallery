import 'dart:convert';

List<Photo> photoListFromJson(String str) => List<Photo>.from(json.decode(str).map((x) => Photo.fromJson(x)));

class Photo {
  String? id;
  String? author;
  int? width;
  int? height;
  String? url;
  String? downloadUrl;

  Photo({
    this.id,
    this.author,
    this.width,
    this.height,
    this.url,
    this.downloadUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String?,
      author: json['author'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      url: json['url'] as String?,
      downloadUrl: json['download_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'width': width,
        'height': height,
        'url': url,
        'download_url': downloadUrl,
      };

  Photo copyWith({
    String? id,
    String? author,
    int? width,
    int? height,
    String? url,
    String? downloadUrl,
  }) {
    return Photo(
      id: id ?? this.id,
      author: author ?? this.author,
      width: width ?? this.width,
      height: height ?? this.height,
      url: url ?? this.url,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }
}
