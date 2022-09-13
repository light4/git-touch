import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:git_touch/widgets/border_view.dart';
import 'package:git_touch/widgets/link.dart';
import 'package:provider/provider.dart';

class TableViewHeader extends StatelessWidget {
  final String? title;

  const TableViewHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        title!.toUpperCase(),
        style: TextStyle(color: theme.palette.secondaryText, fontSize: 13),
      ),
    );
  }
}

class TableViewItem {
  final Widget text;
  final IconData? leftIconData;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final void Function()? onTap;
  final String? url;
  final bool hideRightChevron;

  const TableViewItem({
    required this.text,
    this.leftIconData,
    this.leftWidget,
    this.rightWidget,
    this.onTap,
    this.url,
    this.hideRightChevron = false,
  }) : assert(leftIconData == null || leftWidget == null);
}

class TableViewItemWidget extends StatelessWidget {
  const TableViewItemWidget(this.item, {super.key});

  final TableViewItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);

    return LinkWidget(
      onTap: item.onTap,
      url: item.url,
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 17, color: theme.palette.text),
        overflow: TextOverflow.ellipsis,
        child: SizedBox(
          height: 44,
          child: Row(
            children: [
              SizedBox(
                width: (item.leftWidget == null && item.leftIconData == null)
                    ? 12
                    : 44,
                child: Center(
                    child: item.leftWidget ??
                        Icon(
                          item.leftIconData,
                          color: theme.palette.primary,
                          size: 20,
                        )),
              ),
              Expanded(child: item.text),
              if (item.rightWidget != null) ...[
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 17,
                    color: theme.palette.tertiaryText,
                  ),
                  child: item.rightWidget!,
                ),
                const SizedBox(width: 6)
              ],
              if ((item.onTap != null || item.url != null) &&
                  !item.hideRightChevron)
                Icon(Ionicons.chevron_forward,
                    size: 20, color: theme.palette.tertiaryText)
              else
                const SizedBox(width: 2),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class TableView extends StatelessWidget {
  final String? headerText;
  final Iterable<TableViewItem> items;
  final bool? hasIcon;

  const TableView({
    super.key,
    this.headerText,
    required this.items,
    this.hasIcon = true,
  });

  double get _leftPadding => hasIcon == true ? 44 : 12;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (headerText != null) TableViewHeader(headerText),
        ...join(
          BorderView(leftPadding: _leftPadding),
          [for (final item in items) TableViewItemWidget(item)],
        ),
        CommonStyle.border,
      ],
    );
  }
}
