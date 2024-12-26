import 'package:flutter/material.dart';

class MyTicketTextfield extends StatelessWidget {
  final IconData textFieldIcon;
  final TextEditingController controller;
  final String hintText;
  final int? minLines;

  const MyTicketTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.textFieldIcon,
      required this.minLines});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Icon(
            textFieldIcon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(
          width: 25,
        ),
        Expanded(
          child: TextField(
            maxLines: 5, // This is the maximum height (number of lines)
            minLines: minLines, // This is the minimum height (number of lines)

            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              hintStyle:
                  TextStyle(color: Colors.grey.shade500),
              fillColor: Colors.white,
              filled: true,

              // Border when selected
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        )
      ],
    );
  }
}
