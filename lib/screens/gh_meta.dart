import 'package:antd_mobile/antd_mobile.dart';
import 'package:flutter/widgets.dart';
import 'package:git_touch/graphql/__generated__/github.data.gql.dart';
import 'package:git_touch/graphql/__generated__/github.req.gql.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/scaffolds/refresh_stateful.dart';
import 'package:provider/provider.dart';

class GhMetaScreen extends StatelessWidget {
  const GhMetaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshStatefulScaffold<GMetaData_meta>(
      title: const Text('Meta'),
      fetch: () async {
        final req = GMetaReq();
        final res =
            await context.read<AuthModel>().gqlClient.request(req).first;
        return res.data!.meta;
      },
      bodyBuilder: (meta, _) {
        return AntList(
          children: [
            AntListItem(
              extra: Text(meta.gitHubServicesSha),
              child: const Text('Service SHA'),
            ),
          ],
        );
      },
    );
  }
}
