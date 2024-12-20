import 'package:flutter/material.dart';

class SampleTicket extends StatelessWidget {
  const SampleTicket({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            border: Border.all(color: Theme.of(context).colorScheme.inversePrimary),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(
          width: 25,
        ),
        Expanded(
            child: Container(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'The color code ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      '\nrepresents a medium-dark shade of blue with subtle green undertones. To use color in Flutter, you can convert the hex code into ARGB format. ',
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .primary // You can specify a different color for this part
                      // fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ))
      ],
    );
  }
}
