import 'package:flutter/material.dart';

class QuestBadge extends StatelessWidget {
  final String badgeName;
  final IconData badgeIcon;
  final Color circleColor;
  final double scale;

  const QuestBadge(
      {super.key,
      required this.badgeName,
      required this.badgeIcon,
      required this.circleColor,
      this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20 * scale,
            height: 20 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
            ),
            child: Center(
              child: Icon(
                badgeIcon,
                size: 15 * scale,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 4 * scale),
          Text(
            badgeName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 11 * scale,
            ),
          ),
        ],
      ),
    );
  }
}
