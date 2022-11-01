class Photo {
  Photo({
      this.contentType, 
      this.extension, 
      this.name, 
      this.size, 
      this.path,});

  Photo.fromJson(dynamic json) {
    contentType = json['contentType'];
    extension = json['extension'];
    name = json['name'];
    size = json['size'];
    path = json['path'];
  }
  String? contentType;
  String? extension;
  String? name;
  String? size;
  String? path;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['contentType'] = contentType;
    map['extension'] = extension;
    map['name'] = name;
    map['size'] = size;
    map['path'] = path;
    return map;
  }

}