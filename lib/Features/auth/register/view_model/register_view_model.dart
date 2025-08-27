import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../Service/auth_repository.dart';



class RegisterViewModel extends ChangeNotifier {
   final AuthRepository _authRepository = AuthRepository();
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  bool isPasswordVisible = true; 
  bool isConfirmPasswordVisible = true;
  
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  String? _registerErrorText;
  String? get registerErrorText => _registerErrorText;
  set registerErrorText(String? value) {
    _registerErrorText = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Registration method
Future<bool> registerUser() async {
  if (!formKey.currentState!.validate()) return false;

  try {
    EasyLoading.show(status: 'Registering...');
    final response = await _authRepository.register(
      firstName: firstNameController.text.trim(),
      middleName: middleNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      contactNo: numberController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );

    EasyLoading.dismiss();
    registerErrorText = null;
    EasyLoading.showSuccess(response["message"] ?? "User registered successfully");
    clearData();

    return true; // success
  } catch (e) {
    EasyLoading.dismiss();
    registerErrorText = e.toString();
    EasyLoading.showError(registerErrorText ?? "Something went wrong");
    return false;
  }
}




  void clearData() {
    firstNameController.clear();
    middleNameController.clear();
    lastNameController.clear();
    emailController.clear();
    numberController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    registerErrorText = null;
    notifyListeners();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    numberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}