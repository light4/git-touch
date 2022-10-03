import 'package:flutter/widgets.dart';
import 'package:git_touch/utils/utils.dart';

class ErrorReload extends StatelessWidget {
  const ErrorReload({required this.text, required this.onTap});
  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        children: <Widget>[
          const Text(
            'Woops, something bad happened. Error message:',
            style: TextStyle(fontSize: 16),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.redAccent,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          GestureDetector(
            onTap: onTap as void Function()?,
            child: const Text(
              'Reload',
              style: TextStyle(fontSize: 20, color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}
