import 'dart:io';
import 'dart:convert';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/gitlab.dart';
import 'package:git_touch/scaffolds/refresh_stateful.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:git_touch/widgets/blob_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

Future<bool> _checkPermission() async {
  if (Platform.isIOS) {
    return true;
  }

  if (Platform.isAndroid) {
    final info = await DeviceInfoPlugin().androidInfo;
    if (info.version.sdkInt > 28) {
      return true;
    }

    final status = await Permission.storage.status;
    if (status == PermissionStatus.granted) {
      return true;
    }

    final result = await Permission.storage.request();
    return result == PermissionStatus.granted;
  }

  throw StateError('unknown platform');
}

class GlBlobScreen extends StatelessWidget {
  const GlBlobScreen(this.id, this.ref, {this.path});
  final int id;
  final String ref;
  final String? path;

  @override
  Widget build(BuildContext context) {
    late bool _permissionReady;
    late String _localPath;

    Future<String?> _getSavedDir() async {
      String? externalStorageDirPath;

      if (Platform.isAndroid) {
        try {
          externalStorageDirPath = await AndroidPathProvider.downloadsPath;
        } catch (err, st) {
          print('failed to get downloads path: $err, $st');

          final directory = await getExternalStorageDirectory();
          externalStorageDirPath = directory?.path;
        }
      } else if (Platform.isIOS) {
        externalStorageDirPath =
            (await getApplicationDocumentsDirectory()).absolute.path;
      }
      return '$externalStorageDirPath/gittouch_downloads';
    }

    Future<void> _prepareSaveDir() async {
      _localPath = (await _getSavedDir())!;
      final savedDir = Directory(_localPath);
      if (!savedDir.existsSync()) {
        await savedDir.create();
      }
    }

    Future<void> _prepare() async {
      _permissionReady = await _checkPermission();
      if (_permissionReady) {
        await _prepareSaveDir();
      }
    }

    Future<void> saveInStorage(String fileName, String content) async {
      await _checkPermission();
      final filename =
          "${fileName.split('/').last.trim()}_${const Uuid().v4()}.${fileName.ext!}";
      final filePath = '$_localPath/$filename';
      final fileDef = File(filePath);
      await fileDef.create(recursive: true);
      await fileDef.writeAsBytes(base64.decode(content));
    }

    return RefreshStatefulScaffold<GitlabBlob>(
      title: Text(path ?? ''),
      fetch: () async {
        final auth = context.read<AuthModel>();
        final res = await auth.fetchGitlab(
            '/projects/$id/repository/files/${path!.urlencode}?ref=$ref');
        return GitlabBlob.fromJson(res);
      },
      action: CupertinoButton(
        minSize: 0,
        padding: EdgeInsets.zero,
        onPressed: () async {
          await _prepare();
          final auth = context.read<AuthModel>();
          final res = await auth.fetchGitlab(
              '/projects/$id/repository/files/${path!.urlencode}?ref=$ref');
          final blob = GitlabBlob.fromJson(res);
          await saveInStorage(path!, blob.content!);
          await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Download Completed'),
              content: Text('file $path! downloaded to $_localPath!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Ionicons.download, size: 22),
      ),
      bodyBuilder: (data, _) {
        return BlobView(path, base64Text: data.content);
      },
    );
  }
}
