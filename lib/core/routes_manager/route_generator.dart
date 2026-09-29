import 'package:flutter/material.dart';
import 'package:hemaya_mogg/core/routes_manager/routes.dart';
import '../../features/home/presentation/screens/home_screen.dart';


class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeRoute:{
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      }
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('No Route Found'),
        ),
        body: const Center(child: Text('No Route Found')),
      ),
    );
  }
}
