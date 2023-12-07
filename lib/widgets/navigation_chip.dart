import 'package:flutter/material.dart';

class NavigationChip extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const NavigationChip({Key? key, required this.label, this.onTap}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white
            )
          ),
        ),
      ),
    );
  }
}