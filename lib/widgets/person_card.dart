import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:wellfreshlogin/theme.dart';

class PersonCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final String subtext;
  final double rating;
  final Widget? customName;
  final Widget? customImage;
  final VoidCallback? action;

  const PersonCard({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.subtext = '',
    this.rating = -1,
    this.action,
    this.customName,
    this.customImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [containerShadow],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: action,
          child: Row(
            children: [
              Container(
                width: 94,
                height: 94,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: customImage ?? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  cacheWidth: 200,
                  cacheHeight: 200,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customName ?? Text(
                        name,
                        overflow: TextOverflow.ellipsis,
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
                          mainAxisAlignment: MainAxisAlignment.start,
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
              ),
              if (action != null) ...[
                const Icon(
                  IconlyLight.arrowRight2,
                  color: tertiaryTextColor,
                ),
                const SizedBox(width: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}