import 'package:flutter/material.dart';

class RichTextItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icons;

  const RichTextItem({super.key, this.icons, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icons != null ? Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            icons,
            size: 30.0,
            color: Colors.blueGrey[300]
          ),
        ): const Text(""),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 20.0
                  )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}