import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FBIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff1877F2),
            Color(0xff2851A3),
          ],
        ),
        // color: Color(0xff1877F2),
        // color: Color(0xff2851A3),
        // gradient: Gradient.lerp(a, b, t),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -5.0,
            child: SizedBox(
                width: 34.0,
                height: 34.0,
                child: SvgPicture.asset('assets/svg/fb_icon.svg')),
          ),
        ],
      ),
    );
  }
}
