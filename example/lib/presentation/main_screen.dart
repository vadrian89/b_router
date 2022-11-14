import 'package:b_router/b_router.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final void Function(BuildContext context)? onPressed;

  const MainScreen({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Wrap(
            direction: Axis.vertical,
            spacing: 10,
            runSpacing: 10,
            children: [
              Text(
                "First level screen",
                style: Theme.of(context).textTheme.headline6,
              ),
              ElevatedButton(
                onPressed: () => context.bPush(
                  name: "page2",
                  arguments: {"page-2-arg": "Screen pushed with argument!!"},
                  params: {"something": "45"},
                ),
                child: const Text("Push me"),
              ),
              ElevatedButton(
                onPressed: () => context.bRedirect(location: "redirected-screen/5546"),
                child: const Text("Redirect to 'redirected-screen/5546'"),
              ),
            ],
          ),
        ),
      );
}
