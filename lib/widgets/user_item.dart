import 'package:flutter/widgets.dart';
import 'package:git_touch/graphql/__generated__/github.data.gql.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:git_touch/widgets/avatar.dart';
import 'package:git_touch/widgets/link.dart';
import 'package:provider/provider.dart';

const userGqlChunk = '''
  login
  name
  avatarUrl
  bio
''';

class GhBioWidget extends StatelessWidget {
  const GhBioWidget({this.location, required this.createdAt});
  final String? location;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);

    if (isNotNullOrEmpty(location)) {
      return Row(
        children: <Widget>[
          Icon(
            Octicons.location,
            size: 15,
            color: theme.palette.secondaryText,
          ),
          const SizedBox(width: 4),
          Expanded(child: Text(location!, overflow: TextOverflow.ellipsis)),
        ],
      );
    }
    return Row(
      children: <Widget>[
        Icon(
          Octicons.clock,
          size: 15,
          color: theme.palette.secondaryText,
        ),
        const SizedBox(width: 4),
        Expanded(
            child: Text('Joined on ${dateFormat.format(createdAt)}',
                overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

class UserItem extends StatelessWidget {

  const UserItem.github({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.bio,
  }) : url = '/github/$login';

  UserItem.fromGqlUser(GUserParts p)
      : login = p.login,
        name = p.name,
        avatarUrl = p.avatarUrl,
        url = '/github/${p.login}',
        bio = GhBioWidget(location: p.location, createdAt: p.createdAt);

  UserItem.fromGqlOrg(GOrgParts p)
      : login = p.login,
        name = p.name,
        avatarUrl = p.avatarUrl,
        url = '/github/${p.login}',
        bio = GhBioWidget(location: p.location, createdAt: p.createdAt);

  const UserItem.gitlab({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.bio,
    required int? id,
  }) : url = '/gitlab/user/$id';

  const UserItem.gitlabGroup({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.bio,
    required int? id,
  }) : url = '/gitlab/group/$id';

  const UserItem.gitea({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.bio,
  }) : url = '/gitea/$login';

  const UserItem.gitee({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.bio,
  }) : url = '/gitee/$login';

  const UserItem.bitbucket({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.bio,
  }) : url = '/bitbucket/$login?team=1';

  const UserItem.gogs({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.bio,
  }) : url = '/gogs/$login';
  final String? login;
  final String? name;
  final String? avatarUrl;
  final Widget? bio;
  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    return LinkWidget(
      url: url,
      child: Container(
        padding: CommonStyle.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Avatar(url: avatarUrl, size: AvatarSize.large),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: <Widget>[
                      if (name != null && name!.isNotEmpty) ...[
                        Text(
                          name!,
                          style: TextStyle(
                            color: theme.palette.text,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          login!,
                          style: TextStyle(
                            color: theme.palette.text,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (bio != null)
                    DefaultTextStyle(
                      style: TextStyle(
                        color: theme.palette.secondaryText,
                        fontSize: 16,
                      ),
                      child: bio!,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
