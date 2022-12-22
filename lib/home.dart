import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/future'),
              child: const Text('Future Builder'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/stream'),
              child: const Text('Stream Builder'),
            ),
          ],
        ),
      ),
    );
  }
}
