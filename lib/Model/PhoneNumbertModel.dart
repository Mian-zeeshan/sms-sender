class PhoneNumberModel {
  String? phone;
  String? name;
  String? amt;

  PhoneNumberModel({this.phone, this.name, this.amt});

  PhoneNumberModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    name = json['name'];
    amt = json['amt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['amt'] = this.amt;
    return data;
  }
}