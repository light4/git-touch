import 'package:flutter/widgets.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle(this.text);
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Text(text!, overflow: TextOverflow.ellipsis);
  }
}
