import 'package:antd_mobile/antd_mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:git_touch/widgets/link.dart';
import 'package:provider/provider.dart';

class TableViewHeader extends StatelessWidget {
  const TableViewHeader(this.title, {super.key});
  final String? title;

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

class TableViewItemWidget extends StatelessWidget {
  const TableViewItemWidget(this.item, {super.key});

  final AntListItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);

    return LinkWidget(
      onTap: item.onClick,
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 17, color: theme.palette.text),
        overflow: TextOverflow.ellipsis,
        child: SizedBox(
          height: 44,
          child: Row(
            children: [
              SizedBox(
                width: (item.prefix == null) ? 12 : 44,
                child: Center(child: item.prefix),
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
              if (item.onClick != null)
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
