import 'package:flutter/material.dart';
import 'package:notification_calling_example/calling_page.dart';
import 'package:notification_calling_example/home_page.dart';

class AppRoute {
  static const homePage = '/home_page';

  static const callingPage = '/calling_page';

  static Route<Object>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case callingPage:
        return MaterialPageRoute(
          builder: (_) => const CallingPage(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
