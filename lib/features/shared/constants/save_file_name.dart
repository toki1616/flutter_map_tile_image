/// 保存するファイルの種類
enum SaveFileName {
  points,
}

/// 保存先を区別するEnum
enum SaveLocation {
  appBase, // アプリ固有の保存場所
  dataset, // ユーザーが指定したデータセット領域
}

extension SaveFileNameExt on SaveFileName {
  String get fileName {
    switch (this) {
      case SaveFileName.points:
        return "points";
    }
  }

  // このファイルがどの保存領域に属するか
  SaveLocation get location {
    switch (this) {
      case SaveFileName.points:
        return SaveLocation.dataset;
    }
  }

  // データセットの場合のサブディレクトリ名
  String get subDirectory {
    switch (this) {
      case SaveFileName.points:
        return "map_data";
    }
  }
}