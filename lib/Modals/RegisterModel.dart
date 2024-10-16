class RegisterModel {
  String? fullName;
  int? mobileNumber;
  String? gender;
  String? bloodGroup;
  int? age;
  String? emailId;

  RegisterModel(
      {this.fullName,
      this.mobileNumber,
      this.gender,
      this.bloodGroup,
      this.age,
      this.emailId});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    mobileNumber = json['mobileNumber'];
    gender = json['gender'];
    bloodGroup = json['bloodGroup'];
    age = json['age'];
    emailId = json['emailId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['mobileNumber'] = this.mobileNumber;
    data['gender'] = this.gender;
    data['bloodGroup'] = this.bloodGroup;
    data['age'] = this.age;
    data['emailId'] = this.emailId;
    return data;
  }
}
