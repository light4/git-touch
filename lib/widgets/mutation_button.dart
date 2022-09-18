import 'package:antd_mobile/antd_mobile.dart';
import 'package:flutter/cupertino.dart';

class MutationButton extends StatelessWidget {
  final bool active;
  final String text;
  final VoidCallback onTap;

  const MutationButton({
    super.key,
    this.active = false,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AntButton(
      color: AntTheme.primary,
      fill: active ? AntButtonFill.solid : AntButtonFill.outline,
      shape: AntButtonShape.rounded,
      onClick: onTap,
      child: Text(text),
    );
  }
}
