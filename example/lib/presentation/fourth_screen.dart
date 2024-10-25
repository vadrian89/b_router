import 'package:b_router/b_router.dart';
import 'package:flutter/material.dart';

class FourthScreen extends StatelessWidget {
  final String text;

  const FourthScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text),
              Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => context.bPush(name: "lala"),
                  child: const Text("Press me"),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, 505),
                child: const Text("Pop with value 505"),
              )
            ],
          ),
        ),
      );
}
