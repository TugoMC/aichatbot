import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String pathData;
  final Color color;
  final double? width;
  final double? height;

  const SvgIcon(
    this.pathData, {
    Key? key,
    required this.color,
    this.width = 24,
    this.height = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final svgString = '''
    <svg width="${width}" height="${height}" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="$pathData" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
    </svg>
    ''';

    return SvgPicture.string(
      svgString,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
