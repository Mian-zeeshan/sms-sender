class PhoneNumberModel {
  String? phone;

  PhoneNumberModel({this.phone});

  PhoneNumberModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    return data;
  }
}
