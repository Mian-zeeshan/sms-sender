class LoginModel {
  String? soft;
  String? code;
  String? login;
  String? pass;
  String? type;
  String? msg;
  String? sim;

  LoginModel(
      {this.soft, this.code, this.login, this.pass, this.type, this.msg,this.sim});

  LoginModel.fromJson(Map<String, dynamic> json) {
    soft = json['soft'];
    code = json['code'];
    login = json['login'];
    pass = json['pass'];
    type = json['type'];
    msg = json['msg'];
    sim=json['sim'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['soft'] = this.soft;
    data['code'] = this.code;
    data['login'] = this.login;
    data['pass'] = this.pass;
    data['type'] = this.type;
    data['msg'] = this.msg;
    data['sim']=this.sim;
    return data;
  }
}
