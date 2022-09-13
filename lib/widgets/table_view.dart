import 'package:antd_mobile/antd_mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/utils/utils.dart';
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
  final Widget child;
  final IconData? prefixIconData;
  final Widget? prefix;
  final Widget? extra;
  final void Function()? onClick;
  final String? url;
  final bool hideRightChevron;

  const TableViewItem({
    required this.child,
    this.prefixIconData,
    this.prefix,
    this.extra,
    this.onClick,
    this.url,
    this.hideRightChevron = false,
  }) : assert(prefixIconData == null || prefix == null);
}

class TableViewItemWidget extends StatelessWidget {
  const TableViewItemWidget(this.item, {super.key});

  final TableViewItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);

    return LinkWidget(
      onTap: item.onClick,
      url: item.url,
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 17, color: theme.palette.text),
        overflow: TextOverflow.ellipsis,
        child: SizedBox(
          height: 44,
          child: Row(
            children: [
              SizedBox(
                width: (item.prefix == null && item.prefixIconData == null)
                    ? 12
                    : 44,
                child: Center(
                    child: item.prefix ??
                        Icon(
                          item.prefixIconData,
                          color: theme.palette.primary,
                          size: 20,
                        )),
              ),
              Expanded(child: item.child),
              if (item.extra != null) ...[
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 17,
                    color: theme.palette.tertiaryText,
                  ),
                  child: item.extra!,
                ),
                const SizedBox(width: 6)
              ],
              if ((item.onClick != null || item.url != null) &&
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
  final Widget? header;
  final Iterable<TableViewItem> items;

  const TableView({
    super.key,
    this.header,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);

    return AntList(
      header: header,
      items: [
        for (final item in items)
          AntListItem(
            child: item.child,
            prefix: item.prefix ??
                (item.prefixIconData == null
                    ? null
                    : Icon(item.prefixIconData)),
            extra: item.extra,
            onClick: item.onClick != null
                ? item.onClick!
                : item.url != null
                    ? () {
                        theme.push(context, item.url!);
                      }
                    : null,
          ),
      ],
    );
  }
}
