import 'package:flutter/material.dart';

class MySizedBox extends StatelessWidget {
  final double width;
  final double height;
  const MySizedBox({super.key, this.width = 0, this.height = 0});

  @override
  Widget build(BuildContext context) {
    final double displayScale = MediaQuery.of(context).size.height / 900;
    return SizedBox(
      width: width * displayScale,
      height: height * displayScale,
    );
  }
}
