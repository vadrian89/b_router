import 'package:b_router/b_router.dart';
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Redirected screen with the following parameter value: $text",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                ElevatedButton(
                  onPressed: () => context.bRedirect(location: "/"),
                  child: const Text("Go to root"),
                ),
              ],
            ),
          ),
        ),
      );
}
