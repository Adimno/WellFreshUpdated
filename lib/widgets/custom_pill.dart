import 'package:flutter/material.dart';
import 'package:wellfreshlogin/theme.dart';

class DecorationPill extends StatelessWidget {
  final String text;
  final double borderRadius;

  const DecorationPill({
    super.key,
    required this.text,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [containerShadow],
      ),
      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class PillCarousel extends StatelessWidget {
  final dynamic data;
  final double borderRadius;

  const PillCarousel({
    super.key,
    required this.data,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        shrinkWrap: true,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.only(right: 16),
            child: DecorationPill(text: data[index], borderRadius: borderRadius)
          );
        },
      ),
    );
  }
}

class PillCarouselPicker extends StatefulWidget {
  final List data;
  final double borderRadius;

  const PillCarouselPicker({
    super.key,
    required this.data,
    this.borderRadius = 12,
  });

  @override
  State<PillCarouselPicker> createState() => _PillCarouselPickerState();
}

class _PillCarouselPickerState extends State<PillCarouselPicker> {
  var selectedPill = 1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...(widget.data).map(
            (pill) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedPill = pill['id'];
                });
              },
              child: Container(
                height: 44,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: pill['id'] == selectedPill ? accentColor : cardColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: const [containerShadow],
                ),
                child: Text(
                  pill['role'],
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: pill['id'] == selectedPill ? invertTextColor : primaryTextColor
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}