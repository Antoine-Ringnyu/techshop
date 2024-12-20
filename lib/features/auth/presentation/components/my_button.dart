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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
    
          border: Border.all(
            //color of button
            color: Theme.of(context).colorScheme.tertiary,
            width: 1,
          ),

          //curve corners
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          //button text
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
