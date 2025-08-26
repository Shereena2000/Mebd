import 'package:flutter/material.dart';
import 'package:medb/Settings/utils/images.dart';

// import '../../../Data/LocaStorage/loggedin_user.dart';
// import '../../../Settings/utils/p_colors.dart';
import '../../../Settings/utils/p_colors.dart';
import '../../../Settings/utils/p_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  checkLogin() async {
   // await LoggedInUser.getUserDetails();
    await Future.delayed(const Duration(seconds: 3));
    // if (LoggedInUser.accessToken != null) {
    //   // Navigator.pushNamedAndRemoveUntil(
    //   //     context, PPages.wrapperView, (route) => false);
    // } 
    
    
    // else {
      Navigator.pushNamedAndRemoveUntil(
          context, PPages.homePageUi, (route) => false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors. colorFFFFFF,
      body: Center(child:Image.asset(Images.logo)),
    );
  }
}
