import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String imageUrl;
  final String altText;
  final dynamic hero;

  const ImageScreen({
    Key? key,
    required this.imageUrl,
    required this.altText,
    required this.hero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: hero,
              child: Image.network(imageUrl),
            ),
            const SizedBox(height: 24),
            Text(
              altText,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: FloatingActionButton.small(
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: Colors.grey[800],
          child: const Icon(Icons.close),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}