import 'package:flutter/material.dart';
import 'package:reddit_clone/features/features.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-community': (_) =>
        const MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (routeData) => MaterialPage(
          child: CommunityScreen(name: routeData.pathParameters['name']!),
        ),
    '/mod-tools/:name': (routeData) => MaterialPage(
          child: ModToolScreen(name: routeData.pathParameters['name']!),
        ),
    '/edit-community/:name': (routeData) => MaterialPage(
          child: EditCommunityScreen(name: routeData.pathParameters['name']!),
        ),
    '/add-mod/:name': (routeData) => MaterialPage(
          child: AddModScreen(name: routeData.pathParameters['name']!),
        ),
    '/u/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(uid: routeData.pathParameters['uid']!),
        ),
    '/edit-profile/:uid': (routeData) => MaterialPage(
          child: EditProfileScreen(uid: routeData.pathParameters['uid']!),
        ),
  },
);
 