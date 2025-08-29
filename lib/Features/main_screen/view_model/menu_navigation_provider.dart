import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/menu_model.dart';

class MenuNavigationProvider with ChangeNotifier {
  int _selectedIndex = 0;
  List<MenuItemModel> _menus = [];
  bool _isLoadingMenus = false;

  int get selectedIndex => _selectedIndex;
  List<MenuItemModel> get menus => _menus;
  bool get isLoadingMenus => _isLoadingMenus;

  void setSelectedIndex(int index) {
    if (index >= 0 && index < _menus.length) {
      _selectedIndex = index;
      notifyListeners();
      log("📱 Navigation index changed to: $index");
    } else {
      log("❌ Invalid navigation index: $index");
    }
  }

  // Set menus + persist in SharedPreferences
  Future<void> setMenus(List<MenuItemModel> menus) async {
    try {
      _isLoadingMenus = true;
      notifyListeners();

      _menus = menus..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      _selectedIndex = 0;

      // Save in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final menuJson = jsonEncode(_menus.map((m) => m.toJson()).toList());
      await prefs.setString("menus", menuJson);

      _isLoadingMenus = false;
      notifyListeners();
      
      log("✅ Menus set and persisted: ${_menus.length} items");
      for (var menu in _menus) {
        log("   📋 Menu: ${menu.menuName} (Order: ${menu.sortOrder})");
      }
    } catch (e) {
      _isLoadingMenus = false;
      notifyListeners();
      log("❌ Error setting menus: $e");
      throw Exception("Failed to set menus: $e");
    }
  }

  // Load menus from SharedPreferences
  Future<void> loadMenus() async {
    try {
      _isLoadingMenus = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final menuString = prefs.getString("menus");

      if (menuString != null && menuString.isNotEmpty) {
        final List decoded = jsonDecode(menuString);
        _menus = decoded.map((m) => MenuItemModel.fromJson(m)).toList();
        _selectedIndex = 0;
        
        log("✅ Menus loaded from storage: ${_menus.length} items");
      } else {
        log("⚠️ No saved menus found");
        _menus = [];
        _selectedIndex = 0;
      }

      _isLoadingMenus = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMenus = false;
      _menus = [];
      _selectedIndex = 0;
      notifyListeners();
      log("❌ Error loading menus: $e");
    }
  }

  // Clear menus (logout case)
  Future<void> clearMenus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("menus");
      
      _menus = [];
      _selectedIndex = 0;
      _isLoadingMenus = false;
      
      notifyListeners();
      log("🗑️ Menus cleared from storage and memory");
    } catch (e) {
      log("❌ Error clearing menus: $e");
      // Still clear memory even if SharedPreferences fails
      _menus = [];
      _selectedIndex = 0;
      _isLoadingMenus = false;
      notifyListeners();
    }
  }

  // Check if menus are available
  bool hasMenus() {
    return _menus.isNotEmpty;
  }

  // Get menu by index safely
  MenuItemModel? getMenuByIndex(int index) {
    if (index >= 0 && index < _menus.length) {
      return _menus[index];
    }
    return null;
  }

  // Get current selected menu
  MenuItemModel? getCurrentMenu() {
    return getMenuByIndex(_selectedIndex);
  }

  // Debug method to log all menus
  void debugMenus() {
    log("🔍 Current menus state:");
    log("   Total menus: ${_menus.length}");
    log("   Selected index: $_selectedIndex");
    log("   Is loading: $_isLoadingMenus");
    
    for (int i = 0; i < _menus.length; i++) {
      final menu = _menus[i];
      log("   [$i] ${menu.menuName} (ID: ${menu.menuId}, Order: ${menu.sortOrder})");
    }
  }
}