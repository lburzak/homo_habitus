import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconAsset {
  final String name;
  final String path;

  IconAsset({required this.name, required this.path});

  IconAsset.ofDefaultPath(this.name) : path = _makeDefaultIconPath(name);

  SvgPicture asSvgPicture(BuildContext context) => SvgPicture.asset(
        path,
        color: Theme.of(context).iconTheme.color,
      );

  @override
  String toString() {
    return 'IconAsset{name: $name, path: $path}';
  }

  static IconAsset placeholder() => IconAsset.ofDefaultPath('language');

  static String _makeDefaultIconPath(String iconName) =>
      "assets/icons/$iconName.svg";
}