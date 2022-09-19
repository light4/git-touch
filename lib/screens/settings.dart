import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/code.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/scaffolds/single.dart';
import 'package:git_touch/utils/locale.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:git_touch/widgets/action_button.dart';
import 'package:git_touch/widgets/app_bar_title.dart';
import 'package:git_touch/widgets/table_view.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    final auth = Provider.of<AuthModel>(context);
    final code = Provider.of<CodeModel>(context);
    return SingleScaffold(
      title: AppBarTitle(AppLocalizations.of(context)!.settings),
      body: Column(
        children: <Widget>[
          CommonStyle.verticalGap,
          TableView(header: Text(AppLocalizations.of(context)!.system), items: [
            if (auth.activeAccount!.platform == PlatformType.github) ...[
              TableViewItem(
                child: Text(AppLocalizations.of(context)!.githubStatus),
                url: 'https://www.githubstatus.com/',
              ),
              const TableViewItem(
                child: Text('Meta'),
                url: '/settings/github-meta',
              ),
              TableViewItem(
                child: Text(AppLocalizations.of(context)!.reviewPermissions),
                url:
                    'https://github.com/settings/connections/applications/$clientId',
                extra: Text(auth.activeAccount!.login),
              ),
            ],
            if (auth.activeAccount!.platform == PlatformType.gitlab)
              TableViewItem(
                child: Text(AppLocalizations.of(context)!.gitlabStatus),
                url: '${auth.activeAccount!.domain}/help',
                extra: FutureBuilder<String>(
                  future:
                      auth.fetchGitlab('/version').then((v) => v['version']),
                  builder: (context, snapshot) {
                    return Text(snapshot.data ?? '');
                  },
                ),
              ),
            if (auth.activeAccount!.platform == PlatformType.gitea)
              TableViewItem(
                prefixIconData: Octicons.info,
                child: Text(AppLocalizations.of(context)!.giteaStatus),
                url: '/gitea/status',
                extra: FutureBuilder<String>(
                  future: auth.fetchGitea('/version').then((v) => v['version']),
                  builder: (context, snapshot) {
                    return Text(snapshot.data ?? '');
                  },
                ),
              ),
            TableViewItem(
              child: Text(AppLocalizations.of(context)!.switchAccounts),
              url: '/login',
              extra: Text(auth.activeAccount!.login),
            ),
            TableViewItem(
              child: Text(AppLocalizations.of(context)!.appLanguage),
              extra: Text(theme.locale == null
                  ? AppLocalizations.of(context)!.followSystem
                  : localeNameMap[theme.locale!] ?? theme.locale!),
              onClick: () {
                // TODO: too many options, better use a new page
                theme.showActions(context, [
                  for (final key in [
                    null,
                    ...AppLocalizations.supportedLocales
                        .map((l) => l.toString())
                        .where((key) => localeNameMap[key] != null)
                  ])
                    ActionItem(
                      text: key == null
                          ? AppLocalizations.of(context)!.followSystem
                          : localeNameMap[key],
                      onTap: (_) async {
                        final res = await theme.showConfirm(
                          context,
                          const Text(
                              'The app will reload to make the language setting take effect'),
                        );
                        if (res == true && theme.locale != key) {
                          await theme.setLocale(key);
                          auth.reloadApp();
                        }
                      },
                    )
                ]);
              },
            )
          ]),
          CommonStyle.verticalGap,
          TableView(
            header: Text(AppLocalizations.of(context)!.theme),
            items: [
              TableViewItem(
                child: Text(AppLocalizations.of(context)!.brightness),
                extra: Text(theme.brighnessValue == AppBrightnessType.light
                    ? AppLocalizations.of(context)!.light
                    : theme.brighnessValue == AppBrightnessType.dark
                        ? AppLocalizations.of(context)!.dark
                        : AppLocalizations.of(context)!.followSystem),
                onClick: () {
                  theme.showActions(context, [
                    for (var t in [
                      Tuple2(AppLocalizations.of(context)!.followSystem,
                          AppBrightnessType.followSystem),
                      Tuple2(AppLocalizations.of(context)!.light,
                          AppBrightnessType.light),
                      Tuple2(AppLocalizations.of(context)!.dark,
                          AppBrightnessType.dark),
                    ])
                      ActionItem(
                        text: t.item1,
                        onTap: (_) {
                          if (theme.brighnessValue != t.item2) {
                            theme.setBrightness(t.item2);
                          }
                        },
                      )
                  ]);
                },
              ),
              TableViewItem(
                child: Text(AppLocalizations.of(context)!.codeTheme),
                url: '/choose-code-theme',
                extra: Text('${code.fontFamily}, ${code.fontSize}pt'),
              ),
              TableViewItem(
                child: Text(AppLocalizations.of(context)!.markdownRenderEngine),
                extra: Text(theme.markdown == AppMarkdownType.flutter
                    ? AppLocalizations.of(context)!.flutter
                    : AppLocalizations.of(context)!.webview),
                onClick: () {
                  theme.showActions(context, [
                    for (var t in [
                      Tuple2(AppLocalizations.of(context)!.flutter,
                          AppMarkdownType.flutter),
                      Tuple2(AppLocalizations.of(context)!.webview,
                          AppMarkdownType.webview),
                    ])
                      ActionItem(
                        text: t.item1,
                        onTap: (_) {
                          if (theme.markdown != t.item2) {
                            theme.setMarkdown(t.item2);
                          }
                        },
                      )
                  ]);
                },
              ),
            ],
          ),
          CommonStyle.verticalGap,
          TableView(
            header: Text(AppLocalizations.of(context)!.feedback),
            items: [
              TableViewItem(
                child: Text(AppLocalizations.of(context)!.submitAnIssue),
                extra: const Text('git-touch/git-touch'),
                url:
                    '${auth.activeAccount!.platform == PlatformType.github ? '/github' : 'https://github.com'}/git-touch/git-touch/issues/new',
              ),
              TableViewItem(
                child: Text(AppLocalizations.of(context)!.rateThisApp),
                onClick: () {
                  LaunchReview.launch(
                    androidAppId: 'io.github.pd4d10.gittouch',
                    iOSAppId: '1452042346',
                  );
                },
              ),
              TableViewItem(
                child: Text(AppLocalizations.of(context)!.email),
                extra: const Text('pd4d10@gmail.com'),
                hideRightChevron: true,
                url: 'mailto:pd4d10@gmail.com',
              ),
            ],
          ),
          CommonStyle.verticalGap,
          TableView(
            header: Text(AppLocalizations.of(context)!.about),
            items: [
              TableViewItem(
                  child: Text(AppLocalizations.of(context)!.version),
                  extra: FutureBuilder<String>(
                    future:
                        PackageInfo.fromPlatform().then((info) => info.version),
                    builder: (context, snapshot) {
                      return Text(snapshot.data ?? '');
                    },
                  )),
              TableViewItem(
                child: Text(AppLocalizations.of(context)!.sourceCode),
                extra: const Text('git-touch/git-touch'),
                url:
                    '${auth.activeAccount!.platform == PlatformType.github ? '/github' : 'https://github.com'}/git-touch/git-touch',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
