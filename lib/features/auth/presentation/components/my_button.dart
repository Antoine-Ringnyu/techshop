import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTab;
  final String text;

  const MyButton({super.key, required this.onTab, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //tab function
      onTap: onTab,

      //button decoration
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          //color of button
          color: Theme.of(context).colorScheme.tertiary,

          //curve corners
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          //button text
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
