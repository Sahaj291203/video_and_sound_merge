import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  final Color? color;
  const LoaderWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(color: color, strokeWidth: 2),
      ),
    );
  }
}
