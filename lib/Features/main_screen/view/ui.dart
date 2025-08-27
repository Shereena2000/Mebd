import 'package:flutter/material.dart';
import 'package:medb/Features/accounts/view/ui.dart';
import 'package:medb/Features/health_records/view/ui.dart';
import 'package:medb/Features/main_screen/view_model/menu_navigation_provider.dart';
import 'package:provider/provider.dart';

import '../../appointments/view/ui.dart';
import '../../common_widgets/customNavigation_bar.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<Widget> _pages = [
    AppointmentScreen(),
HealthRecordScreen(),
    AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MenuNavigationProvider>(
        builder: (context, navigationProvider, child) {
          return IndexedStack(
            index: navigationProvider.selectedIndex,
            children: _pages,
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
