import 'package:antd_mobile/antd_mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:github/github.dart' as github;
import 'package:provider/provider.dart';

class LanguageBarItem {
  LanguageBarItem({
    required this.name,
    required this.ratio,
    String? hexColor,
  }) : hexColor = hexColor ?? github.languageColors[name!];
  String? name;
  String? hexColor;
  double? ratio;
}

class LanguageBar extends StatelessWidget {
  const LanguageBar(this.items);
  final List<LanguageBarItem> items;

  @override
  Widget build(BuildContext context) {
    final langWidth = MediaQuery.of(context).size.width -
        CommonStyle.padding.left -
        CommonStyle.padding.right -
        items.length +
        1;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: () async {
        await AntPopup.show(
          context: context,
          closeOnMaskClick: true,
          builder: _buildPopup,
        );
      },
      child: Container(
        // color: AntTheme.of(context).background,
        padding: CommonStyle.padding.copyWith(top: 8, bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: 10,
            child: Row(
              children: join(
                const SizedBox(width: 1),
                items
                    .map((lang) => Container(
                        color: fromCssColor(lang.hexColor!),
                        width: langWidth * lang.ratio!))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopup(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    return Container(
      color: AntTheme.of(context).colorBackground,
      padding: CommonStyle.padding,
      height: 300,
      child: SingleChildScrollView(
        child: Table(children: [
          for (final edge in items)
            TableRow(children: [
              Container(
                padding: CommonStyle.padding,
                child: Row(children: <Widget>[
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: fromCssColor(edge.hexColor!),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    edge.name!,
                    style: TextStyle(
                      color: AntTheme.of(context).colorText,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      decorationColor: AntTheme.of(context).colorBackground,
                    ),
                  ),
                ]),
              ),
              Container(
                padding: CommonStyle.padding,
                child: Text(
                  '${(edge.ratio! * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: AntTheme.of(context).colorTextSecondary,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                    decorationColor: AntTheme.of(context).colorBackground,
                  ),
                ),
              ),
            ])
        ]),
      ),
    );
  }
}
