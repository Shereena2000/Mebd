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
          builder: (context, viewModel, child) => Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizeBoxH(30),
                      SizedBox(height: 40, child: Image.asset(Images.logo)),
                      SizeBoxH(20),
                      Text(
                        "Create an Account",
                        style: PTextStyles.displaMedium,
                      ),
                      SizeBoxH(20),
                      Form(
                        key: viewModel.fomKey,
                        child: Column(
                          children: [
                            CustomTextFeild(
                              controller: viewModel.firstNameController,
                              hintText: "First Name",
                              validation: Validator.text,
                            ),
                            SizeBoxH(8),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextFeild(
                                    controller: viewModel.middleNameController,
                                    hintText: "Middle Name",
                                  ),
                                ),
                                SizeBoxV(20),
                                Expanded(
                                  child: CustomTextFeild(
                                    controller: viewModel.lastNameController,
                                    hintText: "Last Name",
                                  ),
                                ),
                              ],
                            ),
                            SizeBoxH(8),
                            CustomTextFeild(
                              controller: viewModel.emailController,
                              validation: Validator.email,
                              hintText: "Email",
                            ),
                            SizeBoxH(8),
                            CustomTextFeild(
                              controller: viewModel.numberController,
                              hintText: "Contact Number",
                            ),
                            SizeBoxH(8),
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
                            SizeBoxH(8),
                            CustomTextFeild(
                              controller: viewModel.confirmPasswordController,
                              hintText: "Confirm Password",
                              validation: Validator.password,
                              obscureText: viewModel.isconfirmPasswordVisible,
                              suffixIcon: Icon(
                                viewModel.isconfirmPasswordVisible
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
                      SizeBoxH(8),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomOutlineButton(onPressed: () {


                        if (viewModel.fomKey.currentState!.validate()) {
                            
                            }
                    }, text: 'Register'),
                    SizeBoxH(10),
                    AuthNavigationText(
                      text: "Already have an account? ",
                      buttonText: "Login",
                      onTap: () {
                        Navigator.pushNamed(context, PPages.login);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
