import 'package:flutter/cupertino.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:provider/provider.dart';

// TODO:
class CupertinoLink extends StatefulWidget {
  final Widget? child;
  final Function? onTap;

  const CupertinoLink({this.child, this.onTap});

  @override
  _CupertinoLinkState createState() => _CupertinoLinkState();
}

class _CupertinoLinkState extends State<CupertinoLink> {
  Color? _color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color,
      child: GestureDetector(
        onTap: widget.onTap as void Function()?,
        onTapDown: (_) {
          print('down');
          setState(() {
            _color = Colors.black12;
          });
        },
        onTapUp: (_) {
          print('up');
          setState(() {
            _color = null;
          });
        },
        onTapCancel: () {
          print('cacnel');
          setState(() {
            _color = null;
          });
        },
        child: widget.child,
      ),
    );
  }
}

class LinkWidget extends StatelessWidget {
  final Widget child;
  final String? url;
  final Function? onTap;
  final Function? onLongPress;

  const LinkWidget({
    required this.child,
    this.url,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);

    Widget w = CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      onPressed: () async {
        if (onTap != null) onTap!();
        if (url != null) theme.push(context, url!);
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
