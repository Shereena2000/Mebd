import 'package:flutter/material.dart';
import 'package:medb/Features/auth/login/view_model/login_view_model.dart';
import 'package:provider/provider.dart';

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
             Consumer<LoginViewModel>(
                builder: (context, loginViewModel, child) {
                  return IconButton(
                    onPressed: loginViewModel.isLoading ? null : () {
                      _showLogoutConfirmation(context, loginViewModel);
                    },
                    icon: loginViewModel.isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.logout, color: Colors.white),
                  );
                },
              ),
            ]
          : [const SizedBox()],
    );
  }

  void _showLogoutConfirmation(BuildContext context, LoginViewModel loginViewModel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Confirm Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await loginViewModel.performLogout(context);
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: PColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}