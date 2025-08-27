import 'package:flutter/material.dart';
import 'package:medb/Features/auth/login/view_model/login_view_model.dart';
import 'package:medb/Settings/utils/p_colors.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../../../../Settings/common/custom_outline_button.dart';
import '../../../../Settings/common/custom_text_feild.dart';
import '../../../../Settings/constants/sized_box.dart';
import '../../../../Settings/utils/images.dart';
import '../../../../Settings/utils/p_pages.dart';
import '../../../../Settings/utils/p_text_styles.dart';
import '../../../../Settings/utils/validator.dart';
import '../../../common_widgets/auth_navigation.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Form(
                key: viewModel.formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizeBoxH(100),
                    SizedBox(height: 40, child: Image.asset(Images.logo)),
                    SizeBoxH(10),
                    Text(
                      "Welcome Back!",
                      style: PTextStyles.displaMedium.copyWith(fontSize: 25),
                    ),
                    SizeBoxH(30),
                    CustomTextFeild(
                      controller: viewModel.emailController,
                      validation: Validator.email,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: PColors.lightGrey,
                      ),
                      prefixfn: () {},
                      hintText: "Email",
                    ),
                    SizeBoxH(15),
                    CustomTextFeild(
                      controller: viewModel.passwordController,
                      validation: Validator.password,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: PColors.lightGrey,
                      ),
                      prefixfn: () {},
                      hintText: "Password",
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
                    SizeBoxH(30),
                    CustomOutlineButton(
                      onPressed: () async {
                        
                        final response = await context
                            .read<LoginViewModel>()
                            .loginUser(context);

                        if (response != null) {
                          log("✅ Login successful - navigating to home");
                          
                          Navigator.pushReplacementNamed(
                            context,
                            PPages.mainPageUi,
                          );
                        } else {
                          log("❌ Login failed - staying on login screen");
                        }
                      },
                      text: 'Login',
                    ),
                    SizeBoxH(15),
                    AuthNavigationText(
                      text: "Don't have an account? ",
                      buttonText: "Sign Up",
                      onTap: () {
                        Navigator.pushNamed(context, PPages.registerPageUi);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}