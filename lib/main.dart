import 'package:flutter/widgets.dart';
import 'package:git_touch/app.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/code.dart';
import 'package:git_touch/models/notification.dart';
import 'package:git_touch/models/theme.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://595252fc3dd6457e89c628a70c4ed2db@o4504243789365248.ingest.sentry.io/4504243797295104';
    },
    // Init your App.
    appRunner: () async {
      final notificationModel = NotificationModel();
      final themeModel = ThemeModel();
      final authModel = AuthModel();
      final codeModel = CodeModel();
      await Future.wait([
        themeModel.init(),
        authModel.init(),
        codeModel.init(),
      ]);

      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => notificationModel),
          ChangeNotifierProvider(create: (context) => themeModel),
          ChangeNotifierProvider(create: (context) => authModel),
          ChangeNotifierProvider(create: (context) => codeModel),
        ],
        child: const MyApp(),
      ));
    },
  );
}
