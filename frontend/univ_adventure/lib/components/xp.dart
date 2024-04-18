import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class XPComponent extends StatelessWidget {
  final int xp;
  final double scale;

  XPComponent({required this.xp, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0 * scale, vertical: 2.5 * scale),

      decoration: BoxDecoration(
        color: Color.fromARGB(255,130, 227, 192),
        borderRadius: BorderRadius.circular(15 * scale),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            xp.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 16 * scale,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4 * scale),
          Icon(
            LucideIcons.sparkles,
            color: Colors.black,
            size: 16 * scale,
          )
        ],
      ),
    );
  }
}
