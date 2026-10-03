import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/language_provider.dart';
import '../providers/menu_provider.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = context.watch<MenuProvider>();
    final lang = context.watch<LanguageProvider>();

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: menu.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = menu.categories[index];
          final isSelected = menu.selectedCategory == cat.id;
          final count = menu.getCategoryCount(cat.id);
          final title = lang.isFrench ? cat.nameFr : cat.nameEn;

          return GestureDetector(
            onTap: () => menu.selectCategory(cat.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryGreen : AppTheme.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryGreen : AppTheme.border,
                  width: 1.2,
                ),
                boxShadow: isSelected ? AppTheme.greenShadow : AppTheme.softShadow,
              ),
              child: Row(
                children: [
                  Text(
                    cat.icon,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.black,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withAlpha(50) : AppTheme.creamDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "$count",
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
