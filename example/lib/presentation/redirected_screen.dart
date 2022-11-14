import 'package:flutter/material.dart';

class RedirectedScreen extends StatelessWidget {
  final String text;
  const RedirectedScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "Redirected screen with the following parameter value: $text",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      );
}
