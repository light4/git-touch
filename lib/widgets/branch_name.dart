import 'package:antd_mobile/antd_mobile.dart';
import 'package:flutter/widgets.dart';

class BranchName extends StatelessWidget {
  const BranchName(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return AntTag(
      fill: AntTagFill.outline,
      color: AntTheme.primary,
      round: true,
      child: Text(name),
    );
  }
}
