import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/menu_model.dart';

class MenuNavigationProvider with ChangeNotifier {
  int _selectedIndex = 0;
  List<MenuItemModel> _menus = [];

  int get selectedIndex => _selectedIndex;
  List<MenuItemModel> get menus => _menus;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  /// ✅ Set menus + persist in SharedPreferences
  Future<void> setMenus(List<MenuItemModel> menus) async {
    _menus = menus..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    _selectedIndex = 0;

    // Save in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final menuJson = jsonEncode(_menus.map((m) => m.toJson()).toList());
    await prefs.setString("menus", menuJson);

    notifyListeners();
  }

  /// ✅ Load menus from SharedPreferences
  Future<void> loadMenus() async {
    final prefs = await SharedPreferences.getInstance();
    final menuString = prefs.getString("menus");

    if (menuString != null) {
      final List decoded = jsonDecode(menuString);
      _menus = decoded.map((m) => MenuItemModel.fromJson(m)).toList();
      _selectedIndex = 0;
      notifyListeners();
    }
  }

  /// Optional: clear menus (logout case)
  Future<void> clearMenus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("menus");
    _menus = [];
    _selectedIndex = 0;
    notifyListeners();
  }
}
