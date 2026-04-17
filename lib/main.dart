import 'package:asset_management_mobile/core/utils/app_theme.dart';
import 'package:asset_management_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/network/auth_interceptor.dart';
import 'core/utils/router_provider.dart';
import 'features/assets/presentation/screens/first_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      title: 'Asset Management App',
    );
  }
}
