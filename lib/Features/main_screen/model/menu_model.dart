class MenuItemModel {
  final int menuId;
  final String menuName;
  final int sortOrder;
  final String menuIcon;
  final String actionName;
  final String controllerName;
  final Map<String, dynamic> rights;

  MenuItemModel({
    required this.menuId,
    required this.menuName,
    required this.sortOrder,
    required this.menuIcon,
    required this.actionName,
    required this.controllerName,
    required this.rights,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      menuId: json['menuId'] ?? 0,
      menuName: json['menuName'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
      menuIcon: json['menuIcon'] ?? '',
      actionName: json['actionName'] ?? '',
      controllerName: json['controllerName'] ?? '',
      rights: Map<String, dynamic>.from(json['rights'] ?? {}),
    );
  }

  /// ✅ Add this so you can save into SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'menuId': menuId,
      'menuName': menuName,
      'sortOrder': sortOrder,
      'menuIcon': menuIcon,
      'actionName': actionName,
      'controllerName': controllerName,
      'rights': rights,
    };
  }

  @override
  String toString() {
    return 'MenuItemModel(menuId: $menuId, menuName: $menuName, sortOrder: $sortOrder)';
  }
}
