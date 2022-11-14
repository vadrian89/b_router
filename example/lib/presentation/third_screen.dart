import 'package:b_router/b_router.dart';
import 'package:flutter/material.dart';

class ThirdScreen extends StatelessWidget {
  final String text;
  const ThirdScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text),
              ElevatedButton(
                onPressed: () => context.bPush(name: "third-screen/the-provided-id"),
                child: const Text("Presse me"),
              ),
            ],
          ),
        ),
      );
}
