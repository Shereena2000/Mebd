import 'package:flutter/material.dart';
import '../../../../Settings/common/custom_outline_button.dart';
import '../../../../Settings/common/custom_text_feild.dart';
import '../../../../Settings/constants/sized_box.dart';
import '../../../../Settings/utils/images.dart';
import '../../../../Settings/utils/p_text_styles.dart';
import '../../../common_widgets/auth_navigation.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40, child: Image.asset(Images.logo)),SizeBoxH(20),
                    Text("Create an Account", style: PTextStyles.displaMedium),
                    SizeBoxH(50),
                    CustomTextFeild(hintText: "First Name"),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFeild(hintText: "Middle Name"),
                        ),
                        SizeBoxV(20),
                        Expanded(child: CustomTextFeild(hintText: "Last Name")),
                      ],
                    ),
                    CustomTextFeild(hintText: "Email"),
                    CustomTextFeild(hintText: "Contact NUMBER"),
                    CustomTextFeild(hintText: "Password"),
                    CustomTextFeild(hintText: "Confirm Password"),
                  ],
                ),
              ),
            ),

            // 👇 Fixed Bottom Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomOutlineButton(onPressed: () {}, text: 'Register'),
                  SizeBoxH(10),
                  AuthNavigationText(
                    text: "Already have an account?",
                    buttonText: "Login",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
