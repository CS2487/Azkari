import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    return SafeArea(
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (leading != null)
              leading!
            else
              const SizedBox(width: 48), // مساحة فارغة إذا لم يوجد أي leading
            Expanded(
              child: Center(
                child: Text(
                  title ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (actions != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              )
            else
              const SizedBox(width: 48), // مساحة فارغة للتوازن
          ],
        ),
      ),
    );
  }
}
