class login {
  String? fullName;
  int? mobileNumber;

  login({this.fullName, this.mobileNumber});

  login.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    mobileNumber = json['mobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['mobileNumber'] = this.mobileNumber;
    return data;
  }
}