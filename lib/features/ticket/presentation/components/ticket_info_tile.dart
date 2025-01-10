import 'package:flutter/material.dart';

class TicketInfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final FontWeight? bold;
  final CrossAxisAlignment crossAxisAlignment;

  const TicketInfoTile({
    super.key,
    required this.icon,
    required this.text,
    this.bold,
    required this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 30,
        ),
        const SizedBox(width: 25),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: bold,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18),
          ),
        )
      ],
    );
  }
}
