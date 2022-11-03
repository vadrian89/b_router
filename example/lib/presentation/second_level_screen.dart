import 'package:flutter/material.dart';

class SecondLevelScreen extends StatelessWidget {
  final String text;
  final void Function(BuildContext context)? onButtonPressed;

  const SecondLevelScreen({
    Key? key,
    required this.text,
    this.onButtonPressed,
  }) : super(key: key);

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
                  onPressed: (onButtonPressed != null) ? () => onButtonPressed!(context) : null,
                  child: const Text("Presse me"),
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
