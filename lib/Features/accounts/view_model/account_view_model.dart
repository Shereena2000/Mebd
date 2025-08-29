import 'package:flutter/material.dart';

class AccountViewModel extends ChangeNotifier {
  Map<String, dynamic>? _userDetails;

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Controllers for fields
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();

  Map<String, dynamic>? get userDetails => _userDetails;

  void setUserDetails(Map<String, dynamic> details) {
    _userDetails = details;

    // Populate controllers safely
    firstNameController.text = details['firstName'] ?? '';
    middleNameController.text = details['middleName'] ?? '';
    lastNameController.text = details['lastName'] ?? '';
    emailController.text = details['email'] ?? '';
    contactController.text = details['contactNo'] ?? '';

    notifyListeners();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    contactController.dispose();
    super.dispose();
  }
}
