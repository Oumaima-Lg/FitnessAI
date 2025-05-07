class Photo {
  int? id;
  String? path;
  String? date;

  Photo({
    this.id,
    this.path,
    this.date,
  });

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['path'] = path;
    data['date'] = date;
    return data;
  }
  

}