import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medb/Settings/utils/p_colors.dart';
import 'package:provider/provider.dart';
import '../main_screen/model/menu_model.dart';
import '../main_screen/view_model/menu_navigation_provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuNavigationProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: PColors.white,
           
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(provider.menus.length, (index) {
                  final menu = provider.menus[index];
                  return _buildNavItem(
                    index: index,
                    menu: menu,
                    provider: provider,
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required int index,
    required MenuItemModel menu,
    required MenuNavigationProvider provider,
  }) {
    final isSelected = provider.selectedIndex == index;

    return GestureDetector(
      onTap: () {
        provider.setSelectedIndex(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color:  Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color:isSelected ? PColors.black : Colors.transparent, width: 1)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
           CachedNetworkImage(
            imageUrl: menu.menuIcon,
            height: 28,
            width: 28,
            placeholder: (context, url) => const Icon(Icons.image, size: 28, color: Colors.grey),
            errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 28, color: Colors.grey),
          ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1.0 : 0.0,
                child: Container(
                  margin: EdgeInsets.only(left: isSelected ? 8 : 0),
                  child: isSelected
                      ? Text(
                          menu.menuName, 
                          style: TextStyle(
                            color: PColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
