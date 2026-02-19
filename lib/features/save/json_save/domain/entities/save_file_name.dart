enum SaveFileName {
  lines,
  settings,
  userData,
}

extension SaveFileNameExt on SaveFileName {
  String get fileName {
    switch (this) {
      case SaveFileName.lines:
        return "lines";
      case SaveFileName.settings:
        return "settings";
      case SaveFileName.userData:
        return "user_data";
    }
  }
}