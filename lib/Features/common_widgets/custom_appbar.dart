import 'package:flutter/material.dart';

import '../../Settings/utils/p_colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isAction;

  const CustomAppbar({Key? key, required this.title, this.isAction = true})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Text(title),
      backgroundColor: PColors.primaryColor,
      actionsPadding: const EdgeInsets.all(5),
      actions: isAction
          ? [
              const Icon(Icons.search),
              const SizedBox(width: 5),
              const Icon(Icons.notifications_outlined),
              const SizedBox(width: 5),
              const Icon(Icons.logout),
            ]
          : [const SizedBox()],
    );
  }

 
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
