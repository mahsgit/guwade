import 'package:flutter/material.dart';

class RelatedVideoCard extends StatelessWidget {
  final String title;
  final String price;
  final int likes;
  final Color color;

  const RelatedVideoCard({
    super.key,
    required this.title,
    required this.price,
    required this.likes,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Icon(
                    Icons.favorite,
                    size: 16,
                    color: color,
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.favorite_border,
                size: 14,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                '$likes',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
