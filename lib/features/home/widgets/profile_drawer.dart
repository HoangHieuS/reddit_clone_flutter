import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({Key? key}) : super(key: key);

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToProfileScreen(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void changeTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
                radius: 70,
              ),
              const SizedBox(height: 10),
              Text(
                'u/${user.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              ListTile(
                title: const Text('My Profile'),
                leading: const Icon(Icons.person),
                onTap: () =>navigateToProfileScreen(context, user.uid),
              ),
              ListTile(
                title: const Text('Log Out'),
                leading: Icon(
                  Icons.logout,
                  color: Pallete.redColor,
                ),
                onTap: () => logOut(ref),
              ),
              Switch.adaptive(
                value: ref.watch(themeNotifierProvider.notifier).mode == ThemeMode.dark,
                onChanged: (value) => changeTheme(ref),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
