import 'package:flutter/material.dart';

class CircularTag extends StatelessWidget {
  final String value;
  final String label;
  final Color fill;
  final Color borderOutline;

  const CircularTag({
    super.key,
    this.value = '00', // Default value for 'value' is '00'
    this.label = '', // Default value for 'label' is an empty string
    this.fill = Colors.grey, // Default container color is grey
    this.borderOutline = Colors.grey, // Default border color is grey
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50, // Set the width
          height: 50, // Set the height to be the same as the width

          decoration: BoxDecoration(
            border: Border.all(
                color: borderOutline), // Use the optional border color
            color: fill, // Use the optional container color
            borderRadius: BorderRadius.circular(45),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
