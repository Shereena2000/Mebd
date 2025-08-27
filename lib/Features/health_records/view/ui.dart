import 'package:flutter/material.dart';
import 'package:medb/Features/common_widgets/custom_appbar.dart';
import 'package:medb/Features/health_records/view/widgets/health_file_tab.dart';
import 'package:medb/Features/health_records/view/widgets/prescription_tab.dart';
import 'package:medb/Settings/utils/p_colors.dart';

class HealthRecordScreen extends StatelessWidget {
  const HealthRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "My Records", isAction: false),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: PColors.scaffoldColor2,
              child: TabBar(
                automaticIndicatorColorAdjustment: false,
                dividerColor: PColors.scaffoldColor2,
                labelColor: PColors.primaryColor,
                unselectedLabelColor: PColors.lightGrey,
                indicatorColor: PColors.primaryColor,
                tabs: [
                  Tab(
                    child: Text(
                      "Prescriptions",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Health Files",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [PrescriptionsTab(), HealthFilesTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

