class RegisterRequest {
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String contactNo;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.contactNo,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'contactNo': contactNo,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}

class RegisterResponse {
  final String message;
  final bool success;

  RegisterResponse({
    required this.message,
    required this.success,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] ?? 'Registration completed',
      success: true,
    );
  }
}