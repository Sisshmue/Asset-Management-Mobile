import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/assets/presentation/screens/first_page.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../network/auth_interceptor.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final initState = ref.watch(authInitProvider);
      final token = ref.watch(authTokenProvider);
      if (initState.isLoading) return '/';
      final isLoggedIn = token.isNotEmpty;
      final isLoginRoute = state.fullPath == '/login';

      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }

      if (isLoggedIn && isLoginRoute) {
        return '/home';
      }

      if (state.fullPath == '/') {
        return isLoggedIn ? '/home' : '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const FirstPage()),
    ],
  );
});
