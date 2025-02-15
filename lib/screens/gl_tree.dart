import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/gitlab.dart';
import 'package:git_touch/scaffolds/list_stateful.dart';
import 'package:provider/provider.dart';
import 'package:antd_mobile/antd_mobile.dart';
import 'package:file_icon/file_icon.dart';

class GlTreeScreen extends StatelessWidget {
  const GlTreeScreen(this.id, this.ref, {this.path});
  final int id;
  final String ref;
  final String? path;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);

    return ListStatefulScaffold<GitlabTreeItem, int>(
      title: Text(path ?? AppLocalizations.of(context)!.files),
      fetch: (page) async {
        final uri = Uri(
          path: '/projects/$id/repository/tree',
          queryParameters: {
            'ref': ref,
            'page': page?.toString(),
            ...(path == null ? {} : {'path': path})
          },
        );
        final res = await auth.fetchGitlabWithPage(uri.toString());
        return ListPayload(
          cursor: res.cursor,
          hasMore: res.hasMore,
          items: [for (var v in res.data) GitlabTreeItem.fromJson(v)],
        );
      },
      itemBuilder: (item) {
        final url = item.type == 'tree'
            ? '/gitlab/projects/$id/tree/$ref?path=${item.path.urlencode}'
            : item.type == 'blob'
                ? '/gitlab/projects/$id/blob/$ref?path=${item.path.urlencode}'
                : '';
        return AntListItem(
          prefix: FileIcon(item.name, size: 26),
          extra: null,
          onClick: () async {
            context.pushUrl(url);
          },
          arrow: const Icon(AntIcons.rightOutline),
          child: Text(item.name),
        );
      },
    );
  }
}
