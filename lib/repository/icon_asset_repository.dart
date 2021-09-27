import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:homo_habitus/model/icon_asset.dart';

class IconAssetRepository {
  static const String _assetManifest = "AssetManifest.json";
  bool _isLoaded = false;
  List<IconAsset> _icons = List.empty();

  Future<List<IconAsset>> findAllIcons() async {
    if (!_isLoaded) {
      await _loadIconAssets();
      _isLoaded = true;
    }

    return _icons;
  }

  Future _loadIconAssets() async {
    final manifestContent = await _readManifest();
    final Map<String, dynamic> jsonManifest = json.decode(manifestContent);

    final Iterable<String> paths = jsonManifest.keys
        .where((key) => key.startsWith("assets/icons"))
        .where((key) => key.endsWith('.svg'));

    _icons = paths
        .map((path) =>
            IconAsset(name: _decodeIconNameFromPath(path), path: path))
        .toList(growable: false);
  }

  String _decodeIconNameFromPath(String path) {
    return path.split(".").first.split("/").last;
  }

  Future<String> _readManifest() async =>
      await rootBundle.loadString(_assetManifest);
}
