import 'package:flutter/material.dart';
import 'svg_icon.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController messageController;
  final bool isFocused;
  final Function(bool) onFocusChanged;
  final Color cardBgColor;
  final Color textColor;
  final Color textColorSecondary;
  final Color borderColor;
  final Color purpleColor;
  final VoidCallback onSend;

  const ChatInput({
    Key? key,
    required this.messageController,
    required this.isFocused,
    required this.onFocusChanged,
    required this.cardBgColor,
    required this.textColor,
    required this.textColorSecondary,
    required this.borderColor,
    required this.purpleColor,
    required this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Colors matching React implementation more closely
    final focusBorderColor = purpleColor;
    final focusRingColor = isDarkMode
        ? const Color(0xFF4C1D95).withOpacity(0.5)
        : const Color(0xFFDDD6FE).withOpacity(0.5);

    // Matching React's box decoration - WITHOUT ANY SHADOW
    final inputDecoration = BoxDecoration(
      color: cardBgColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isFocused ? focusBorderColor : borderColor,
        width: 1,
      ),
      // No boxShadow even when focused
    );

    return Container(
      decoration: inputDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Attachment button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgIcon(
                  'M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25',
                  color: textColorSecondary,
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),

          // Text field
          Expanded(
            child: TextField(
              controller: messageController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Type here',
                hintStyle: TextStyle(color: textColorSecondary),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                isDense: true,
              ),
              onTap: () {
                onFocusChanged(true);
              },
              onTapOutside: (_) {
                onFocusChanged(false);
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),

          // Microphone button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgIcon(
                  'M12 1a3 3 0 00-3 3v8a3 3 0 006 0V4a3 3 0 00-3-3z M19 10v2a7 7 0 01-14 0v-2M12 19v4M8 23h8',
                  color: textColorSecondary,
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),

          // Send button
          Container(
            margin: const EdgeInsets.only(left: 8),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: purpleColor,
              shape: BoxShape.circle,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onSend,
                child: Center(
                  child: SvgIcon(
                    'M5 12h14M12 5l7 7-7 7',
                    color: Colors.white,
                    width: 20,
                    height: 20,
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
