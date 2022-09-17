import 'package:flutter/cupertino.dart';
import 'package:git_touch/models/theme.dart';
import 'package:provider/provider.dart';

class ActionEntry extends StatelessWidget {
  final IconData? iconData;
  final String? url;
  final VoidCallback? onTap;
  const ActionEntry({this.url, this.iconData, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      onPressed: () {
        if (onTap != null) onTap!();
        if (url != null) theme.push(context, url!);
      },
      child: Icon(iconData, size: 22),
    );
  }
}
