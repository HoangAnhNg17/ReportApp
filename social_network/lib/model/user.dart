class User {
  User({
      this.id, 
      this.createdAt, 
      this.createdBy, 
      this.modifiedAt, 
      this.modifiedBy, 
      this.name, 
      this.dateOfBirth, 
      this.address, 
      this.gender, 
      this.phoneNumber, 
      this.email, 
      this.avatar, 
      this.token,});

  User.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    modifiedAt = json['modifiedAt'];
    modifiedBy = json['modifiedBy'];
    name = json['name'];
    dateOfBirth = json['dateOfBirth'];
    address = json['address'];
    gender = json['gender'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    avatar = json['avatar'];
    token = json['token'];
  }
  num? id;
  String? createdAt;
  String? createdBy;
  String? modifiedAt;
  String? modifiedBy;
  String? name;
  String? dateOfBirth;
  String? address;
  bool? gender;
  String? phoneNumber;
  String? email;
  String? avatar;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['createdBy'] = createdBy;
    map['modifiedAt'] = modifiedAt;
    map['modifiedBy'] = modifiedBy;
    map['name'] = name;
    map['dateOfBirth'] = dateOfBirth;
    map['address'] = address;
    map['gender'] = gender;
    map['phoneNumber'] = phoneNumber;
    map['email'] = email;
    map['avatar'] = avatar;
    map['token'] = token;
    return map;
  }

}