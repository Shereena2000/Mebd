import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RegisterViewModel extends ChangeNotifier {
  final fomKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isconfirmPasswordVisible = false;
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isconfirmPasswordVisible = !isconfirmPasswordVisible;
    notifyListeners();
  }

  String? _registerErrorText;
  String? get registerErrorText => _registerErrorText;
  set registerErrorText(String? value) {
    _registerErrorText = value;
    notifyListeners();
  }

  Future<void> register({required BuildContext context}) async {
    try {
      EasyLoading.show();
      
    } catch (e) {}
  }

  void clearData() {
    firstNameController.clear();
    middleNameController.clear();
    lastNameController.clear();
    emailController.clear();
    numberController.clear();
    passwordController.clear();
    confirmPasswordController.clear;
    notifyListeners();
  }
}
