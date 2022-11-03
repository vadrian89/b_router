import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final void Function(BuildContext context)? onPressed;

  const MainScreen({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("First level screen"),
              const SizedBox(height: 20),
              Builder(
                builder: (context) => ElevatedButton(
                  onPressed: (onPressed != null) ? () => onPressed!(context) : null,
                  child: const Text("Push me"),
                ),
              ),
            ],
          ),
        ),
      );
}
