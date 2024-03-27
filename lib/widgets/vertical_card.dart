import 'package:flutter/material.dart';

class VerticalCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;
  final double height;

  VerticalCard({
    required this.title,
    required this.onPressed,
    required this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the width based on the screen size
    final double cardWidth = MediaQuery.of(context).size.width / 3 - 32;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: cardWidth, // Set the calculated width
        height: height, // Set the height directly
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              '#$title',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
