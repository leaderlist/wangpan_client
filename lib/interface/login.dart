class LoginRequestData {
  late final String username;
  late final String password;
  late final String? otp_code;

  LoginRequestData({
    required this.username,
    required this.password,
    this.otp_code,
  });

  Map<String, String> toMap() {
    return {
      'username': username,
      'password': password,
      if (otp_code != null) 'otp_code': otp_code ?? '',
    };
  }
}

class LoginResponseData {
  late final String token;

  LoginResponseData({
    required this.token,
  });

  Map<String, String> toMap() {
    return {
      'token': token,
    };
  }
}