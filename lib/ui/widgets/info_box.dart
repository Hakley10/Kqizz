import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color iconColor;
  final bool isDarkmode;

  const InfoBox({
    super.key,
    required this.icon,
    required this.value,
    required this.iconColor,
    required this.isDarkmode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkmode ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              color: isDarkmode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
