// user_model.dart

class RegisterModel {
  String? gender;
  String? bloodGroup;
  int? age;
  String? emailId;

  List<Addresses>? addresses;

  RegisterModel(
      {this.gender, this.bloodGroup, this.age, this.emailId, this.addresses});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    bloodGroup = json['bloodGroup'];
    age = json['age'];
    emailId = json['emailId'];

    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['gender'] = gender;
    data['bloodGroup'] = bloodGroup;
    data['age'] = age;
    data['emailId'] = emailId;

    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
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
    data['houseNo'] = houseNo;
    data['area'] = area;
    data['directions'] = directions;
    data['saveAs'] = saveAs;
    data['receiverName'] = receiverName;
    data['receiverMobileNumber'] = receiverMobileNumber;
    return data;
  }
}
