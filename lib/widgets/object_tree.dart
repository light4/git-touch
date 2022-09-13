import 'package:file_icon/file_icon.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:git_touch/widgets/table_view.dart';
import 'package:primer/primer.dart';

Widget _buildIcon(String type, String name) {
  switch (type) {
    case 'blob': // github gql, gitlab
    case 'file': // github rest, gitea
    case 'commit_file': // bitbucket
      return FileIcon(name, size: 36);
    case 'tree': // github gql, gitlab
    case 'dir': // github rest, gitea
    case 'commit_directory': // bitbucket
      return const Icon(
        Octicons.file_directory,
        color: PrimerColors.blue300,
        size: 24,
      );
    case 'commit':
      return const Icon(
        Octicons.file_submodule,
        color: PrimerColors.blue300,
        size: 24,
      );
    default:
      throw 'object type error';
  }
}

TableViewItem createObjectTreeItem({
  required String name,
  required String type,
  required String url,
  String? downloadUrl,
  int? size,
}) {
  return TableViewItem(
    leftWidget: _buildIcon(type, name),
    text: Text(name),
    rightWidget: size == null ? null : Text(filesize(size)),
    url: [
      // Let system browser handle these files
      //
      // TODO:
      // Unhandled Exception: PlatformException(Error, Error while launching
      // https://github.com/flutter/flutter/issues/49162

      // Docs
      'pdf', 'docx', 'doc', 'pptx', 'ppt', 'xlsx', 'xls',
      // Fonts
      'ttf', 'otf', 'eot', 'woff', 'woff2',
      'svg',
    ].contains(name.ext)
        ? downloadUrl
        : url,
    hideRightChevron: size != null,
  );
}
