class LatestActivity {
  String? id;
  String? nameActivity;
  String? imageUrl;
  int? createdAt;

  LatestActivity({
    this.id,
    this.nameActivity,
    this.imageUrl,
    this.createdAt,
  });

  factory LatestActivity.fromJson(Map<String, dynamic> json) {
    return LatestActivity(
      id: json['id'],
      nameActivity: json['nameActivity'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameActivity': nameActivity,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}
