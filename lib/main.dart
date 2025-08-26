import 'package:flutter/material.dart';
import 'Settings/utils/p_colors.dart';
import 'Settings/utils/p_pages.dart';
import 'Settings/utils/p_routes.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medb',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
           theme: ThemeData(
        brightness: Brightness.light,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        scaffoldBackgroundColor: PColors.colorFFFFFF,
        colorScheme: ColorScheme.fromSeed(seedColor: PColors.primaryColor),
        iconTheme: IconThemeData(color: PColors.colorFFFFFF),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: PColors.colorFFFFFF,
          surfaceTintColor: PColors.primaryColor,
          foregroundColor: PColors.colorFFFFFF,
          centerTitle: true,
        ),
      ),
        initialRoute: PPages.splash,
      onGenerateRoute: Routes.genericRoute,
    );
  }
}
