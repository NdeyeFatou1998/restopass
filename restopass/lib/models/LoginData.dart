class LoginData {
  late String _email;
  late String _password;

  LoginData(this._email, this._password);

  String get email => _email;

  String get password => _password;

  set email(value) => _email = value;
  set password(value) => _password = value;

  @override
  String toString() {
    return "LOGIN DATA: email: $email, password: $password";
  }
}
