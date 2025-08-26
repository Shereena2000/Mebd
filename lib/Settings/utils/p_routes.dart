import 'package:flutter/material.dart';
import 'package:medb/Features/auth/login/view/ui.dart';
import 'package:medb/Features/auth/register/view/ui.dart';
import 'package:medb/Features/home/view/ui.dart';
import 'package:medb/Settings/utils/p_pages.dart';

import '../../Features/splash/view/ui.dart';

class Routes {
  static Route<dynamic>? genericRoute(RouteSettings settings) {
    switch (settings.name) {
      case PPages.splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());

      case PPages.registerPageUi:
        return MaterialPageRoute(builder: (context) => RegisterScreen());


                      case PPages.login:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case PPages.homePageUi:
        return MaterialPageRoute(builder: (context) => HomeScreen());
        
      // case PPages.noInternet:
      //   return MaterialPageRoute(builder: (context) => NoInternetWidget());

      default:
        return null;
    }
  }
}
