import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/language_provider.dart';

class LanguageToggleButton extends StatelessWidget {
  final bool isDark;

  const LanguageToggleButton({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return GestureDetector(
      onTap: () => lang.toggleLanguage(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withAlpha(40) : AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white70 : AppTheme.border,
            width: 1.2,
          ),
          boxShadow: isDark ? null : AppTheme.softShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              lang.isFrench ? "🇫🇷 FR" : "🇬🇧 EN",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: isDark ? Colors.white : AppTheme.black,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.swap_horiz,
              size: 14,
              color: isDark ? Colors.white70 : AppTheme.mutedText,
            ),
          ],
        ),
      ),
    );
  }
}
