import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:wellfreshlogin/theme.dart';
import 'dart:math';

class PersonCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final String subtext;
  final double rating;
  final VoidCallback? action;

  const PersonCard({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.subtext = '',
    this.rating = -1,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    var rng = Random();
    var colorSeed = [
      rng.nextInt(255),
      rng.nextInt(176) + 79,
      rng.nextInt(91) + 164,
    ];

    return InkWell(
      onTap: action,
      child: Container(
        height: 94,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [containerShadow],
        ),
        child: Row(
          children: [
            Container(
              width: 97,
              height: 94,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, 0.0),
                  radius: 0.5,
                  colors: [
                    Color.fromRGBO(colorSeed[0], colorSeed[1] - 79, colorSeed[2] - 164, 1),
                    Color.fromRGBO(colorSeed[0], colorSeed[1], colorSeed[2], 1),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.fill,
                cacheWidth: 97,
                cacheHeight: 94,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: tertiaryTextColor,
                    ),
                  ),
                  if (subtext != '') ...[
                    Text(
                      subtext,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: tertiaryTextColor,
                      ),
                    ),
                  ],
                  if (rating != -1) ...[
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          IconlyBold.star,
                          color: warningTextColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          rating.toString(),
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: tertiaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (action != null) ...[
              const Spacer(),
              const Icon(
                IconlyLight.arrowRight2,
                color: tertiaryTextColor,
              ),
              const SizedBox(width: 12),
            ],
          ],
        ),
      ),
    );
  }
}