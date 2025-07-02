import 'package:flutter/material.dart';

class LineItem extends StatelessWidget {
  const LineItem({super.key, this.onTap, this.line, this.isSelected = false});

  final String? line;
  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? Colors.white.withOpacity(.6) : null,
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 10,
        ),
        child: Text(
          line ?? '',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: isSelected ? Colors.black87 : Colors.white,
          ),
        ),
      ),
    );
  }
}
