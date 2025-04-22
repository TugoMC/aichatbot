import 'package:flutter/material.dart';
import 'svg_icon.dart';

class ServiceCard extends StatelessWidget {
  final Map<String, String> card;
  final Color cardBgColor;
  final Color textColor;
  final Color textColorSecondary;
  final Color borderColor;

  const ServiceCard({
    Key? key,
    required this.card,
    required this.cardBgColor,
    required this.textColor,
    required this.textColorSecondary,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card['title']!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            card['description']!,
            style: TextStyle(
              fontSize: 14,
              color: textColorSecondary,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: cardBgColor,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: SvgIcon(
                  'M5 12H19M12 5V19',
                  color: textColorSecondary,
                ),
                iconSize: 16,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
