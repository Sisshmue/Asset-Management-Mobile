import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import '../utils/secure_storage.dart';

final authTokenProvider = StateProvider<String>((ref) => "");

final authInitProvider = FutureProvider<void>((ref) async {
  final storage = ref.read(secureStorageProvider);
  final token = await storage.getToken();
  if (token != null) {
    ref.read(authTokenProvider.notifier).state = token;
  }
});

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final token = ref.read(authTokenProvider);
      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    } catch (e) {
      handler.next(options);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
