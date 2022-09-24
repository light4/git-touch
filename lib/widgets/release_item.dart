import 'package:antd_mobile/antd_mobile.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:git_touch/graphql/__generated__/github.data.gql.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:git_touch/widgets/avatar.dart';
import 'package:git_touch/widgets/markdown_view.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReleaseItem extends StatelessWidget {
  const ReleaseItem(
      {required this.login,
      required this.publishedAt,
      required this.name,
      required this.tagName,
      required this.avatarUrl,
      required this.description,
      this.releaseAssets});
  final String? login;
  final DateTime? publishedAt;
  final String? name;
  final String? avatarUrl;
  final String? tagName;
  final String? description;
  final GReleasesData_repository_releases_nodes_releaseAssets? releaseAssets;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Row(children: <Widget>[
          Avatar(url: avatarUrl, size: AvatarSize.large),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      tagName!,
                      style: TextStyle(
                        color: AntTheme.of(context).colorPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                DefaultTextStyle(
                  style: TextStyle(
                    color: AntTheme.of(context).colorTextSecondary,
                    fontSize: 16,
                  ),
                  child: Text(
                      '${login!} ${AppLocalizations.of(context)!.released} ${timeago.format(publishedAt!)}'),
                ),
              ],
            ),
          ),
        ]),
        if (description != null && description!.isNotEmpty) ...[
          MarkdownFlutterView(
            description,
          ),
          const SizedBox(height: 10),
        ],
        Card(
          color: AntTheme.of(context).colorBox,
          margin: const EdgeInsets.all(0),
          child: ExpansionTile(
            title: Text(
              'Assets (${releaseAssets?.nodes?.length ?? 0})',
              style: TextStyle(
                color: AntTheme.of(context).colorTextSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: <Widget>[
              AntList(
                children: [
                  if (releaseAssets != null)
                    for (var asset in releaseAssets!.nodes!)
                      AntListItem(
                        extra: IconButton(
                          onPressed: () {
                            context.pushUrl(asset.downloadUrl);
                          },
                          icon: const Icon(Ionicons.download_outline),
                        ),
                        arrow: null,
                        child: Text(
                          asset.name,
                          style: TextStyle(
                            color: AntTheme.of(context).colorPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
