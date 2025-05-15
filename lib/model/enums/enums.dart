enum ItemDrawerType {
  online,
  offline,
  bistro,
  setting;

  bool get isOnline => this == online;
  bool get isOffline => this == offline;
  bool get isBistro => this == bistro;
  bool get isSetting => this == setting;

  String get title {
    switch (this) {
      case ItemDrawerType.online:
        return "Online";
      case ItemDrawerType.offline:
        return "Offline";
      case ItemDrawerType.bistro:
        return "Bistro";
      case ItemDrawerType.setting:
        return "Setting";
    }
  }

  String get key {
    switch (this) {
      case ItemDrawerType.online:
        return "online";
      case ItemDrawerType.offline:
        return "offline";
      case ItemDrawerType.bistro:
        return "bistro";
      case ItemDrawerType.setting:
        return "";
    }
  }
}
