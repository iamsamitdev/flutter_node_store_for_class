import 'package:flutter/material.dart';

class ImageNotFound extends StatelessWidget {
  const ImageNotFound({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_not_supported,
          size: 50,
          color: Colors.black45,
        ),
        SizedBox(height: 8),
        Text(
          'Image not found',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}