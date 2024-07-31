class GlobalDataHolder {
  GlobalDataHolder._();

  var currentPageIndex = 0;

  static GlobalDataHolder? _instance;
  static GlobalDataHolder get instance {
    _instance ??= GlobalDataHolder._();
    return _instance!;
  }

  // final data = GlobalDataHolder.instance;
}