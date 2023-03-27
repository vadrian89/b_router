import 'package:flutter/material.dart';

/// A 404-error style screen.
///
/// This screen is shown when the router's state is [RootRouterState.unkown] and
/// when the Uri path contains [RootRouterState.notFoundPath].
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final foregroundColor = themeData.colorScheme.error;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: foregroundColor, size: 100),
            Flexible(
              child: Text(
                "Error 404: resource not found!",
                style: themeData.textTheme.displayMedium!.copyWith(color: foregroundColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
