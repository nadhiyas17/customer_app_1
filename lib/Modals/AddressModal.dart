class AddressModel {
  String? houseNo;
  String? street;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  String? apartment;
  String? direction;
  double? latitude;
  double? longitude;
  String? area;
  String? saveAs;
  String? receiverName;
  String? receiverMobileNumber;

  AddressModel(
      {this.houseNo,
      this.street,
      this.city,
      this.state,
      this.postalCode,
      this.country,
      this.apartment,
      this.direction,
      this.latitude,
      this.longitude,
      this.area,
      this.saveAs,
      this.receiverName,
      this.receiverMobileNumber});

  AddressModel.fromJson(Map<String, dynamic> json) {
    houseNo = json['houseNo'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
    country = json['country'];
    apartment = json['apartment'];
    direction = json['direction'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    area = json['area'];
    saveAs = json['saveAs'];
    receiverName = json['receiverName'];
    receiverMobileNumber = json['receiverMobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['houseNo'] = houseNo;
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['postalCode'] = postalCode;
    data['country'] = country;
    data['apartment'] = apartment;
    data['direction'] = direction;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['area'] = area;
    data['saveAs'] = saveAs;
    data['receiverName'] = receiverName;
    data['receiverMobileNumber'] = receiverMobileNumber;
    return data;
  }
}
