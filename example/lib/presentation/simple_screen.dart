import 'package:flutter/material.dart';

class SimpleScreen extends StatelessWidget {
  final int screenNumber;
  final void Function(BuildContext context) onButtonPressed;

  const SimpleScreen({
    Key? key,
    required this.screenNumber,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Simple screen #$screenNumber"),
              ElevatedButton(
                onPressed: () => onButtonPressed(context),
                child: const Text("Press me"),
              ),
            ],
          ),
        ),
      );
}
