class UsuarioModel {
  dynamic id;
  String email, password, dataLogin;

  UsuarioModel({this.id, this.email, this.password, this.dataLogin});

  factory UsuarioModel.fromMap(Map<String, dynamic> json) => UsuarioModel(id: json["id"], email: json["email"], password: json["password"], dataLogin: json["dataLogin"]);
  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(id: json["id"], email: json["email"], password: json["password"], dataLogin: json["dataLogin"]);
  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'password': password, 'dataLogin': dataLogin};
}