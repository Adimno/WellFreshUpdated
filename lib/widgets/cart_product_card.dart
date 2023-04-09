import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';
import 'package:wellfreshlogin/theme.dart';

class CartProductCard extends StatefulWidget {
  const CartProductCard({
    Key? key,
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  final dynamic id;
  final String name;
  final String category;
  final String imageUrl;
  final int price;
  final int quantity;

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [containerShadow],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            children: [
              Image.network(
                widget.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                        height: 1.25,
                      ),
                    ),
                    Text(
                      'PHP ${widget.price}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: accentTextColor,
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                      ),
                    ),
                    Text(
                      widget.category,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [containerShadow],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            IconlyBroken.arrowLeft2,
                            size: 20,
                            color: primaryTextColor,
                          ),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            if (widget.quantity == 1) {
                              showDeleteDialog(context, widget.id, widget.quantity);
                            }
                            else {
                              FirestoreServices.removeItemQuantity(widget.id, widget.quantity);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${widget.quantity}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [containerShadow],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            IconlyBroken.arrowRight2,
                            size: 20,
                            color: primaryTextColor,
                          ),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            FirestoreServices.addItemQuantity(widget.id, widget.quantity);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showDeleteDialog(BuildContext context, id, quantity) {
  AlertDialog alert = AlertDialog(
    backgroundColor: surfaceColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24))
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    title: Text(
      'Confirm removal',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: secondaryTextColor,
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Are you sure you want to remove this item?',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cardColor,
                foregroundColor: accentTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
                shadowColor: boxShadowColor,
                elevation: 10,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: errorColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
                shadowColor: boxShadowColor,
                elevation: 10,
              ),
              child: const Text('Remove item'),
              onPressed: () {
                FirestoreServices.removeItemQuantity(id, quantity);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}