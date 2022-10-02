import 'package:antd_mobile/antd_mobile.dart';
import 'package:flutter/widgets.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:git_touch/widgets/avatar.dart';
import 'package:git_touch/widgets/link.dart';

class RepoHeader extends StatelessWidget {
  const RepoHeader({
    required this.avatarUrl,
    required this.avatarLink,
    required this.owner,
    required this.name,
    required this.description,
    this.homepageUrl,
    this.actions,
    this.trailings,
  });
  final String? avatarUrl;
  final String? avatarLink;
  final String? owner;
  final String? name;
  final String? description;
  final String? homepageUrl;
  final List<Widget>? actions;
  final List<Widget>? trailings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: CommonStyle.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: join(const SizedBox(height: 12), [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Avatar(
                url: avatarUrl,
                size: AvatarSize.small,
                linkUrl: avatarLink,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$owner / $name',
                  style: TextStyle(
                    fontSize: 20,
                    color: AntTheme.of(context).colorPrimary,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          if (actions != null) ...actions!,
          if (description != null && description!.isNotEmpty)
            Text(
              description!,
              style: TextStyle(
                color: AntTheme.of(context).colorTextSecondary,
                fontSize: 17,
              ),
            ),
          if (homepageUrl != null && homepageUrl!.isNotEmpty)
            LinkWidget(
              url: homepageUrl,
              child: Text(
                homepageUrl!,
                style: TextStyle(
                  color: AntTheme.of(context).colorPrimary,
                  fontSize: 17,
                ),
              ),
            ),
          if (trailings != null) ...trailings!
        ]),
      ),
    );
  }
}
