import 'package:flutter/cupertino.dart';
import 'package:git_touch/utils/utils.dart';

class LinkWidget extends StatelessWidget {
  const LinkWidget({
    required this.child,
    this.url,
    this.onTap,
    this.onLongPress,
  });
  final Widget child;
  final String? url;
  final Function? onTap;
  final Function? onLongPress;

  @override
  Widget build(BuildContext context) {
    Widget w = CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      onPressed: () async {
        if (onTap != null) onTap!();
        if (url != null) context.pushUrl(url!);
      },
      child: child,
    );
    if (onLongPress != null) {
      w = GestureDetector(
          onLongPress: onLongPress as void Function()?, child: w);
    }
    return w;
  }
}
