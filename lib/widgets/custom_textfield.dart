import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.title,
    required this.hint,
    required this.icon,
    required this.controller,
  }) : super(key: key);

  final String? title;
  final String? hint;
  final dynamic icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(178, 178, 178, .2),
                blurRadius: 30,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
              hintText: hint,
              isDense: true,
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              alignLabelWithHint: true,
              prefixIcon: Icon(icon),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}