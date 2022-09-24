import 'package:antd_mobile/antd_mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:git_touch/models/theme.dart';
import 'package:provider/provider.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({required this.controller, this.placeholder});
  final TextEditingController controller;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);

    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      style: TextStyle(color: AntTheme.of(context).colorText),
    );
  }
}
