// user_model.dart
 
class RegisterModel {
  String? fullName;
  int? mobileNumber;
  String? gender;
  String? bloodGroup;
  int? age;
  String? emailId;
  String? dob;
  List<Addresses>? addresses;

  RegisterModel(
      {this.fullName,
      this.mobileNumber,
      this.gender,
      this.bloodGroup,
      this.age,
      this.emailId,
      this.dob,
      this.addresses});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    mobileNumber = json['mobileNumber'];
    gender = json['gender'];
    bloodGroup = json['bloodGroup'];
    age = json['age'];
    emailId = json['emailId'];
    dob = json['dob'];
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] =  fullName;
    data['mobileNumber'] =  mobileNumber;
    data['gender'] =  gender;
    data['bloodGroup'] =  bloodGroup;
    data['age'] =  age;
    data['emailId'] =  emailId;
    data['dob'] =  dob;
    if ( addresses != null) {
      data['addresses'] =  addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  String? houseNo;
  String? area;
  String? directions;
  String? saveAs;
  String? receiverName;
  int? receiverMobileNumber;

  Addresses(
      {this.houseNo,
      this.area,
      this.directions,
      this.saveAs,
      this.receiverName,
      this.receiverMobileNumber});

  Addresses.fromJson(Map<String, dynamic> json) {
    houseNo = json['houseNo'];
    area = json['area'];
    directions = json['directions'];
    saveAs = json['saveAs'];
    receiverName = json['receiverName'];
    receiverMobileNumber = json['receiverMobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['houseNo'] =  houseNo;
    data['area'] =  area;
    data['directions'] =  directions;
    data['saveAs'] =  saveAs;
    data['receiverName'] =  receiverName;
    data['receiverMobileNumber'] =  receiverMobileNumber;
    return data;
  }
}