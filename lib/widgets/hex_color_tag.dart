import 'package:antd_mobile/antd_mobile.dart';
import 'package:flutter/material.dart';
import 'package:git_touch/utils/utils.dart';

class HexColorTag extends StatelessWidget {
  final String name;
  final String color;

  const HexColorTag({
    super.key,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AntTag(
      round: true,
      color: convertColor(color),
      child: Text(name),
    );
  }
}
