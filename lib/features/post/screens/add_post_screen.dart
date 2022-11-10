import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../theme/pallete.dart';
import '../widgets/custom_card.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigatreToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomCard(
            onTap: () => navigatreToType(context, 'image'),
            currentTheme: currentTheme,
            icon: Icons.image_outlined,
          ),
          CustomCard(
            onTap: () => navigatreToType(context, 'text'),
            currentTheme: currentTheme,
            icon: Icons.font_download_outlined,
          ),
          CustomCard(
            onTap: () => navigatreToType(context, 'link'),
            currentTheme: currentTheme,
            icon: Icons.link_outlined,
          ),
        ],
      ),
    );
  }
}
