class ProfileModel {
  String? name;
  String? address;
  String? phoneNumber;
  String? landMark;
  String? id;
  bool? isAdmin;

  ProfileModel({this.name, this.address, this.phoneNumber, this.landMark, this.id, this.isAdmin});

  ProfileModel.fromJson({required Map<String, dynamic> json}) {
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phone'];
    landMark = json['land_mark'];
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'address': address,
        'phone': phoneNumber,
        'land_mark': landMark,
        'isAdmin': isAdmin,
      };
}
