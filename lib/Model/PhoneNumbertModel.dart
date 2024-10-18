class PhoneNumberModel {
  String? phone;
  String? name;
  String? amt;
  bool isCheck=true;

  PhoneNumberModel({this.phone, this.name, this.amt,this.isCheck=true});

  PhoneNumberModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    name = json['name'];
    amt = json['amt'];
    isCheck=json['isCheck']??true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['amt'] = this.amt;
    data['isCheck']=this.isCheck;
    return data;
  }
}