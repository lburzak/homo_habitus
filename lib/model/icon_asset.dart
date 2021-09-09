import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconAsset {
  final String name;
  final String path;

  IconAsset(this.name, this.path);

  SvgPicture asSvgPicture(BuildContext context) => SvgPicture.asset(
    path,
    color: Theme.of(context).iconTheme.color,
  );
}