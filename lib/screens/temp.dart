import 'package:flutter/widgets.dart';

class Temporary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String payload =
        ModalRoute.of(context).settings.arguments;
    return Container(
      child: Center(
child: Text(payload),
      ),
    );
  }
}