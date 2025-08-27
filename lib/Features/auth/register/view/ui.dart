import 'package:flutter/material.dart';
import 'package:medb/Features/auth/register/view_model/register_view_model.dart';
import 'package:medb/Settings/utils/p_pages.dart';
import 'package:provider/provider.dart';
import '../../../../Settings/common/custom_outline_button.dart';
import '../../../../Settings/common/custom_text_feild.dart';
import '../../../../Settings/constants/sized_box.dart';
import '../../../../Settings/utils/images.dart';
import '../../../../Settings/utils/p_text_styles.dart';
import '../../../../Settings/utils/validator.dart';
import '../../../common_widgets/auth_navigation.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<RegisterViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizeBoxH(30),
                        SizedBox(height: 40, child: Image.asset(Images.logo)),
                        const SizeBoxH(20),
                        Text(
                          "Create an Account",
                          style: PTextStyles.displaMedium,
                        ),
                        const SizeBoxH(20),

                        // Show error message if any
                        if (viewModel.registerErrorText != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.red.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              viewModel.registerErrorText!,
                              style: TextStyle(color: Colors.red.shade700),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        Form(
                          key: viewModel.formKey,
                          child: Column(
                            children: [
                              CustomTextFeild(
                                controller: viewModel.firstNameController,
                                hintText: "First Name",
                                validation: Validator.text,
                              ),
                              const SizeBoxH(8),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFeild(
                                      controller: viewModel.middleNameController,
                                      hintText: "Middle Name",
                                    ),
                                  ),
                                  const SizeBoxV(20),
                                  Expanded(
                                    child: CustomTextFeild(
                                      controller: viewModel.lastNameController,
                                      hintText: "Last Name",
                                      validation: Validator.text,
                                    ),
                                  ),
                                ],
                              ),
                              const SizeBoxH(8),
                              CustomTextFeild(
                                controller: viewModel.emailController,
                                validation: Validator.email,
                                hintText: "Email",
                              ),
                              const SizeBoxH(8),
                              CustomTextFeild(
                                controller: viewModel.numberController,
                                hintText: "Contact Number",
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter contact number';
                                  }
                                  if (value.length < 10) {
                                    return 'Please enter a valid contact number';
                                  }
                                  return null;
                                },
                              ),
                              const SizeBoxH(8),
                              CustomTextFeild(
                                controller: viewModel.passwordController,
                                hintText: "Password",
                                validation: Validator.password,
                                obscureText: viewModel.isPasswordVisible,
                                suffixIcon: Icon(
                                  viewModel.isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                sufixfn: () {
                                  viewModel.togglePasswordVisibility();
                                },
                              ),
                              const SizeBoxH(8),
                              CustomTextFeild(
                                controller: viewModel.confirmPasswordController,
                                hintText: "Confirm Password",
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != viewModel.passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                obscureText: viewModel.isConfirmPasswordVisible,
                                suffixIcon: Icon(
                                  viewModel.isConfirmPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                sufixfn: () {
                                  viewModel.toggleConfirmPasswordVisibility();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizeBoxH(8),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                     CustomOutlineButton(
  onPressed: () {
    context.read<RegisterViewModel>().registerUser();
  },
  text: 'Register',
),
                      const SizeBoxH(10),
                      AuthNavigationText(
                        text: "Already have an account? ",
                        buttonText: "Login",
                        onTap: () {
                          if (!viewModel.isLoading) {
                            Navigator.pushNamed(context, PPages.login);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}