import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTab;
  final String text;
  final Color? textColor;
  final Color? containerColor; // Optional parameter for container color
  final Color? borderColor; // Optional parameter for border color
  final double? borderRadius; // Optional parameter for border radius

  const MyButton({
    super.key,
    required this.onTab,
    required this.text,
    this.textColor,
    this.containerColor, // Accept containerColor as an optional parameter
    this.borderColor, // Accept borderColor as an optional parameter
    this.borderRadius = 12, // Default border radius is 12
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // tap function
      onTap: onTab,

      // button decoration
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: containerColor ??
              Theme.of(context)
                  .colorScheme
                  .inversePrimary, // Use passed color or default to theme
          border: Border.all(
            // color of button
            color: borderColor ??
                Theme.of(context)
                    .colorScheme
                    .secondary, // Use passed color or default to theme
            // width: 2,
          ),
          // curve corners with optional borderRadius
          borderRadius: BorderRadius.circular(
              borderRadius ?? 24), // Use passed borderRadius or default to 12
        ),
        child: Center(
          // button text
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor ?? Theme.of(context).colorScheme.tertiary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
