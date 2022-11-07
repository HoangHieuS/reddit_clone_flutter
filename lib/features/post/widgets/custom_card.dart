import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    this.cardSize = 120,
    required this.currentTheme,
    this.iconSize = 60,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final double cardSize;
  final ThemeData currentTheme;
  final double iconSize;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: cardSize,
        width: cardSize,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: currentTheme.backgroundColor,
          elevation: 16,
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}