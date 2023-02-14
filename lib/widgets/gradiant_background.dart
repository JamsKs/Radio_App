import 'package:flutter/material.dart';

class GradiantBackground extends StatelessWidget {
  final Widget child;
  const GradiantBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.pink],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight),
      ),
      child: child,
    );
  }
}
