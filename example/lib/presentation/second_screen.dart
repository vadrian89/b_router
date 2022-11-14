import 'package:b_router/b_router.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final String text;

  const SecondScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text),
              ElevatedButton(
                onPressed: () => context.bPush(
                  name: "third-screen",
                  arguments: {"arg": "An invisible argument"},
                ),
                child: const Text("Press me"),
              ),
            ],
          ),
        ),
      );
}
