import 'package:antd_mobile/antd_mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/scaffolds/refresh_stateful.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:git_touch/widgets/action_button.dart';
import 'package:git_touch/widgets/action_entry.dart';
import 'package:git_touch/widgets/app_bar_title.dart';
import 'package:git_touch/widgets/contribution.dart';
import 'package:git_touch/widgets/entry_item.dart';
import 'package:git_touch/widgets/mutation_button.dart';
import 'package:git_touch/widgets/repo_item.dart';
import 'package:git_touch/widgets/text_with_at.dart';
import 'package:git_touch/widgets/user_header.dart';
import 'package:go_router/go_router.dart';
import 'package:gql_github/user.data.gql.dart';
import 'package:gql_github/user.req.gql.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';

class _Repos extends StatelessWidget {
  _Repos(final Iterable<GRepoParts> pinned, final Iterable<GRepoParts>? repos)
      : title =
            pinned.isNotEmpty ? 'pinned repositories' : 'popular repositories',
        repos = pinned.isNotEmpty ? pinned : repos;
  final String title;
  final Iterable<GRepoParts>? repos;

  @override
  Widget build(BuildContext context) {
    return AntList(
      header: Text(title),
      children: [
        for (final v in repos!)
          RepoItem.gh(
            owner: v.owner.login,
            avatarUrl: v.owner.avatarUrl,
            name: v.name,
            description: v.description,
            starCount: v.stargazers.totalCount,
            forkCount: v.forks.totalCount,
            primaryLanguageName: v.primaryLanguage?.name,
            primaryLanguageColor: v.primaryLanguage?.color,
            isPrivate: v.isPrivate,
            isFork: v.isFork,
          ),
      ],
    );
  }
}

class _User extends StatelessWidget {
  const _User(this.p, {this.isViewer = false, this.rightWidgets = const []});
  final GUserParts p;
  final bool isViewer;
  final List<Widget> rightWidgets;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        UserHeader(
          avatarUrl: p.avatarUrl,
          name: p.name,
          login: p.login,
          createdAt: p.createdAt,
          bio: p.bio,
          isViewer: isViewer,
          rightWidgets: rightWidgets,
        ),
        CommonStyle.border,
        Row(
          children: [
            EntryItem(
              count: p.sponsors.totalCount,
              text: 'Sponsors',
              url: 'https://github.com/sponsors/${p.login}',
            ),
            EntryItem(
              count: p.followers.totalCount,
              text: AppLocalizations.of(context)!.followers,
              url: '/github/${p.login}?tab=followers',
            ),
            EntryItem(
              count: p.following.totalCount,
              text: AppLocalizations.of(context)!.following,
              url: '/github/${p.login}?tab=following',
            ),
          ],
        ),
        CommonStyle.border,
        ContributionWidget(
          weeks: [
            for (final week
                in p.contributionsCollection.contributionCalendar.weeks)
              [
                //  https://github.com/git-touch/git-touch/issues/122
                for (final day in week.contributionDays)
                  ContributionDay(hexColor: day.color)
              ]
          ],
        ),
        CommonStyle.border,
        AntList(
          children: [
            if (isNotNullOrEmpty(p.company))
              AntListItem(
                prefix: const Icon(Octicons.organization),
                child: TextWithAt(
                  text: p.company!,
                  linkFactory: (text) => '/github/${text.substring(1)}',
                  style: TextStyle(
                      fontSize: 17, color: AntTheme.of(context).colorText),
                  oneLine: true,
                ),
              ),
            if (isNotNullOrEmpty(p.location))
              AntListItem(
                prefix: const Icon(Octicons.location),
                child: Text(p.location!),
                onClick: () {
                  MapsLauncher.launchQuery(p.location!);
                },
              ),
            if (isNotNullOrEmpty(p.email))
              AntListItem(
                prefix: const Icon(Octicons.mail),
                child: Text(p.email),
                onClick: () {
                  launchStringUrl('mailto:${p.email}');
                },
              ),
            if (isNotNullOrEmpty(p.websiteUrl))
              AntListItem(
                prefix: const Icon(Octicons.link),
                child: Text(p.websiteUrl!),
                onClick: () {
                  var url = p.websiteUrl!;
                  if (!url.startsWith('http')) {
                    url = 'http://$url';
                  }
                  launchStringUrl(url);
                },
              ),
          ],
        ),
        CommonStyle.verticalGap,
        AntList(
          children: [
            AntListItem(
              prefix: const Icon(Octicons.organization),
              extra: Text(p.organizations.totalCount.toString()),
              onClick: () {
                context.push('/github/${p.login}?tab=organizations');
              },
              child: Text(AppLocalizations.of(context)!.organizations),
            ),
            AntListItem(
              prefix: const Icon(Octicons.repo),
              extra: Text(p.repositories.totalCount.toString()),
              onClick: () {
                context.pushUrl('/github/${p.login}?tab=repositories');
              },
              child: Text(AppLocalizations.of(context)!.repositories),
            ),
            AntListItem(
              prefix: const Icon(Octicons.star),
              extra: Text(p.starredRepositories.totalCount.toString()),
              onClick: () {
                context.pushUrl('/github/${p.login}?tab=stars');
              },
              child: Text(AppLocalizations.of(context)!.stars),
            ),
            AntListItem(
              prefix: const Icon(Octicons.book),
              extra: Text(p.gists.totalCount.toString()),
              child: Text(AppLocalizations.of(context)!.gists),
              onClick: () {
                context.push('/github/${p.login}?tab=gists');
              },
            ),
            AntListItem(
              prefix: const Icon(Octicons.rss),
              child: Text(AppLocalizations.of(context)!.events),
              onClick: () {
                context.push('/github/${p.login}?tab=events');
              },
            ),
          ],
        ),
        CommonStyle.verticalGap,
        _Repos(
          p.pinnedItems.nodes!.whereType<GRepoParts>(),
          p.repositories.nodes,
        ),
        CommonStyle.verticalGap,
      ],
    );
  }
}

class GhViewerScreen extends StatelessWidget {
  const GhViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);
    return RefreshStatefulScaffold<GUserParts?>(
      fetch: () async {
        final req = GViewerReq();
        final res = await auth.ghGqlClient.request(req).first;
        return res.data?.viewer;
      },
      title: AppBarTitle(AppLocalizations.of(context)!.me),
      action: const ActionEntry(
        iconData: Ionicons.cog,
        url: '/settings',
      ),
      bodyBuilder: (p, _) {
        if (p == null) return null;
        return _User(p, isViewer: true);
      },
    );
  }
}

class GhUserScreen extends StatelessWidget {
  const GhUserScreen(this.login, {super.key});
  final String login;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);
    return RefreshStatefulScaffold<GUserData?>(
      fetch: () async {
        final req = GUserReq((b) => b..vars.login = login);
        final res = await auth.ghGqlClient.request(req).first;
        return res.data;
      },
      title: AppBarTitle(login),
      actionBuilder: (payload, _) {
        final url = payload?.user?.url ?? payload?.organization?.url;
        if (url == null) return null;

        return ActionButton(
          title: 'User Actions',
          items: ActionItem.getUrlActions(url),
        );
      },
      bodyBuilder: (data, setData) {
        if (data?.user != null) {
          final p = data!.user!;
          return _User(
            p,
            rightWidgets: [
              if (p.viewerCanFollow)
                MutationButton(
                  active: p.viewerIsFollowing,
                  text: p.viewerIsFollowing
                      ? AppLocalizations.of(context)!.unfollow
                      : AppLocalizations.of(context)!.follow,
                  onTap: () async {
                    if (p.viewerIsFollowing) {
                      await auth.ghClient.users.unfollowUser(p.login);
                    } else {
                      await auth.ghClient.users.followUser(p.login);
                    }
                    setData(data.rebuild((b) {
                      b.user.viewerIsFollowing = !b.user.viewerIsFollowing!;
                    }));
                  },
                )
            ],
          );
        } else if (data?.organization != null) {
          final p = data!.organization!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              UserHeader(
                avatarUrl: p.avatarUrl,
                name: p.name,
                login: p.login,
                createdAt: p.createdAt,
                bio: p.description,
                rightWidgets: [
                  MutationButton(
                    active: p.viewerIsFollowing,
                    text: p.viewerIsFollowing
                        ? AppLocalizations.of(context)!.unfollow
                        : AppLocalizations.of(context)!.follow,
                    onTap: () async {
                      if (p.viewerIsFollowing) {
                        await auth.ghClient.users.unfollowUser(p.login);
                      } else {
                        await auth.ghClient.users.followUser(p.login);
                      }
                      setData(data.rebuild((b) {
                        b.organization.viewerIsFollowing =
                            !b.organization.viewerIsFollowing!;
                      }));
                    },
                  ),
                ],
              ),
              CommonStyle.border,
              Row(
                children: [
                  EntryItem(
                    count: p.sponsors.totalCount,
                    text: 'Sponsors',
                    url: 'https://github.com/sponsors/${p.login}',
                  ),
                  EntryItem(
                    count: p.membersWithRole.totalCount,
                    text: AppLocalizations.of(context)!.members,
                    url: '/github/${p.login}?tab=people',
                  ),
                ],
              ),
              AntList(
                children: [
                  if (isNotNullOrEmpty(p.location))
                    AntListItem(
                      prefix: const Icon(Octicons.location),
                      child: Text(p.location!),
                      onClick: () {
                        launchStringUrl(
                            'https://www.google.com/maps/place/${p.location!.replaceAll(RegExp(r'\s+'), '')}');
                      },
                    ),
                  if (isNotNullOrEmpty(p.email))
                    AntListItem(
                      prefix: const Icon(Octicons.mail),
                      child: Text(p.email!),
                      onClick: () {
                        launchStringUrl('mailto:${p.email!}');
                      },
                    ),
                  if (isNotNullOrEmpty(p.websiteUrl))
                    AntListItem(
                      prefix: const Icon(Octicons.link),
                      child: Text(p.websiteUrl!),
                      onClick: () {
                        var url = p.websiteUrl!;
                        if (!url.startsWith('http')) {
                          url = 'http://$url';
                        }
                        launchStringUrl(url);
                      },
                    ),
                ],
              ),
              CommonStyle.verticalGap,
              AntList(
                children: [
                  AntListItem(
                    prefix: const Icon(Octicons.repo),
                    extra: Text(p.pinnableItems.totalCount.toString()),
                    child: Text(AppLocalizations.of(context)!.repositories),
                    onClick: () {
                      context.pushUrl('/github/${p.login}?tab=repositories');
                    },
                  ),
                  AntListItem(
                    prefix: const Icon(Octicons.rss),
                    child: Text(AppLocalizations.of(context)!.events),
                    onClick: () {
                      context.push('/github/${p.login}?tab=events');
                    },
                  ),
                ],
              ),
              CommonStyle.verticalGap,
              _Repos(
                p.pinnedItems.nodes!.whereType<GRepoParts>(),
                p.pinnableItems.nodes!.whereType<GRepoParts>(),
              ),
              CommonStyle.verticalGap,
            ],
          );
        }
        return null; // TODO: not found
      },
    );
  }
}
