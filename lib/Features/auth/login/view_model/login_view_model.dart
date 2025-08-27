import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Service/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = true;
  String? _loginErrorText;
  String? get loginErrorText => _loginErrorText;

  set loginErrorText(String? value) {
    _loginErrorText = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> loginUser() async {
    if (!formkey.currentState!.validate()) return null;

    try {
      EasyLoading.show(status: 'Logging in...');
      final response = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      EasyLoading.dismiss();
      loginErrorText = null;
      clearData();

      return response; // contains accessToken, loginKey, userDetails, menuData
    } catch (e) {
      EasyLoading.dismiss();
      loginErrorText = e.toString();
      EasyLoading.showError(loginErrorText ?? "Something went wrong");
      return null;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void clearData() {
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
