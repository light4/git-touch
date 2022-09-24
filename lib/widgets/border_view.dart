import 'package:antd_mobile/antd_mobile.dart';
import 'package:flutter/widgets.dart';
import 'package:git_touch/models/theme.dart';
import 'package:provider/provider.dart';

class BorderView extends StatelessWidget {
  const BorderView({
    this.height,
    this.leftPadding = 0,
  });
  final double? height;
  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);

    if (height == null) {
      // Physical pixel
      return Container(
        margin: EdgeInsets.only(left: leftPadding),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AntTheme.of(context).colorBorder, width: 0),
          ),
        ),
      );
    }

    return Row(
      children: <Widget>[
        SizedBox(
          width: leftPadding,
          height: height,
          child: DecoratedBox(
            decoration:
                BoxDecoration(color: AntTheme.of(context).colorBackground),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: height,
            child: DecoratedBox(
              decoration:
                  BoxDecoration(color: AntTheme.of(context).colorBorder),
            ),
          ),
        ),
      ],
    );
  }
}
