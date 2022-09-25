import 'package:ferry/ferry.dart';
import 'package:flutter/widgets.dart';
import 'package:git_touch/graphql/__generated__/github.data.gql.dart';
import 'package:git_touch/graphql/__generated__/github.req.gql.dart';
import 'package:git_touch/graphql/__generated__/github.var.gql.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/scaffolds/list_stateful.dart';
import 'package:git_touch/widgets/app_bar_title.dart';
import 'package:git_touch/widgets/user_item.dart';
import 'package:provider/provider.dart';

class GhFollowers extends StatelessWidget {
  const GhFollowers(this.login);
  final String login;

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GUserParts, String?>(
      title: const AppBarTitle('Followers'),
      fetch: (cursor) async {
        final auth = context.read<AuthModel>();
        final req = GFollowersReq((b) {
          b.vars.login = login;
          b.vars.after = cursor;
        });
        final OperationResponse<GFollowersData, GFollowersVars?> res =
            await auth.gqlClient.request(req).first;
        final p = res.data!.user!.followers;
        return ListPayload(
          cursor: p.pageInfo.endCursor,
          hasMore: p.pageInfo.hasNextPage,
          items: p.nodes!,
        );
      },
      itemBuilder: (p) {
        return UserItem.fromGqlUser(p);
      },
    );
  }
}

class GhFollowing extends StatelessWidget {
  const GhFollowing(this.login);
  final String login;

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GUserParts, String?>(
      title: const AppBarTitle('Following'),
      fetch: (cursor) async {
        final auth = context.read<AuthModel>();
        final req = GFollowingReq((b) {
          b.vars.login = login;
          b.vars.after = cursor;
        });
        final OperationResponse<GFollowingData, GFollowingVars?> res =
            await auth.gqlClient.request(req).first;
        final p = res.data!.user!.following;
        return ListPayload(
          cursor: p.pageInfo.endCursor,
          hasMore: p.pageInfo.hasNextPage,
          items: p.nodes!,
        );
      },
      itemBuilder: (p) {
        return UserItem.fromGqlUser(p);
      },
    );
  }
}

class GhOrgs extends StatelessWidget {
  const GhOrgs(this.login, {super.key});
  final String login;

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GOrgParts, String?>(
      title: const AppBarTitle('Organizations'),
      fetch: (cursor) async {
        final auth = context.read<AuthModel>();
        final req = GOrgsReq((b) {
          b.vars.login = login;
          b.vars.after = cursor;
        });
        final res = await auth.gqlClient.request(req).first;
        final p = res.data!.user!.organizations;
        return ListPayload(
          cursor: p.pageInfo.endCursor,
          hasMore: p.pageInfo.hasNextPage,
          items: p.nodes!,
        );
      },
      itemBuilder: (p) {
        return UserItem.fromGqlOrg(p);
      },
    );
  }
}

class GhMembers extends StatelessWidget {
  const GhMembers(this.login);
  final String login;

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GUserParts, String?>(
      title: const AppBarTitle('Members'),
      fetch: (cursor) async {
        final auth = context.read<AuthModel>();
        final req = GMembersReq((b) {
          b.vars.login = login;
          b.vars.after = cursor;
        });
        final OperationResponse<GMembersData, GMembersVars?> res =
            await auth.gqlClient.request(req).first;
        final p = res.data!.organization!.membersWithRole;
        return ListPayload(
          cursor: p.pageInfo.endCursor,
          hasMore: p.pageInfo.hasNextPage,
          items: p.nodes!,
        );
      },
      itemBuilder: (p) {
        return UserItem.fromGqlUser(p);
      },
    );
  }
}

class GhWachers extends StatelessWidget {
  const GhWachers(this.owner, this.name);
  final String owner;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GUserParts, String?>(
      title: const AppBarTitle('Wachers'),
      fetch: (cursor) async {
        final auth = context.read<AuthModel>();
        final req = GWatchersReq((b) {
          b.vars.owner = owner;
          b.vars.name = name;
          b.vars.after = cursor;
        });
        final OperationResponse<GWatchersData, GWatchersVars?> res =
            await auth.gqlClient.request(req).first;
        final p = res.data!.repository!.watchers;
        return ListPayload(
          cursor: p.pageInfo.endCursor,
          hasMore: p.pageInfo.hasNextPage,
          items: p.nodes!,
        );
      },
      itemBuilder: (p) {
        return UserItem.fromGqlUser(p);
      },
    );
  }
}

class GhStargazers extends StatelessWidget {
  const GhStargazers(this.owner, this.name);
  final String owner;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GUserParts, String?>(
      title: const AppBarTitle('Stargazers'),
      fetch: (cursor) async {
        final auth = context.read<AuthModel>();
        final req = GStargazersReq((b) {
          b.vars.owner = owner;
          b.vars.name = name;
          b.vars.after = cursor;
        });
        final OperationResponse<GStargazersData, GStargazersVars?> res =
            await auth.gqlClient.request(req).first;
        final p = res.data!.repository!.stargazers;
        return ListPayload(
          cursor: p.pageInfo.endCursor,
          hasMore: p.pageInfo.hasNextPage,
          items: p.nodes!,
        );
      },
      itemBuilder: (p) {
        return UserItem.fromGqlUser(p);
      },
    );
  }
}
