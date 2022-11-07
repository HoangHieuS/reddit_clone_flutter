import 'package:flutter/material.dart';
import 'package:reddit_clone/features/features.dart';

class AppConstants {
  static const logoPath = 'assets/images/logo.png';
  static const loginEmotePath = 'assets/images/loginEmote.png';
  static const googleLogoPath = 'assets/images/google.png';

  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  static const tabWidgets = [
    FeedScreen(),
    AddPostScreen(),
  ];

   static const IconData up = IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static const IconData down = IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${AppConstants.awardsPath}/awesomeanswer.png',
    'gold': '${AppConstants.awardsPath}/gold.png',
    'platinum': '${AppConstants.awardsPath}/platinum.png',
    'helpful': '${AppConstants.awardsPath}/helpful.png',
    'plusone': '${AppConstants.awardsPath}/plusone.png',
    'rocket': '${AppConstants.awardsPath}/rocket.png',
    'thankyou': '${AppConstants.awardsPath}/thankyou.png',
    'til': '${AppConstants.awardsPath}/til.png',
  };
}
