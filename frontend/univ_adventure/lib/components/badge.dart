import 'package:flutter/material.dart';

class BadgeComponent extends StatelessWidget {
  final String badgeName;
  final IconData badgeIcon;
  final Color circleColor;
  final double scale;

  const BadgeComponent({required this.badgeName, required this.badgeIcon, required this.circleColor, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32 * scale,
            height: 32 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
            ),
            child: Icon(
              badgeIcon,
                size: 24 * scale,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 4 * scale),
          Text(
            badgeName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14 * scale,
            ),
          ),
        ],
      ),
    );
  }
}