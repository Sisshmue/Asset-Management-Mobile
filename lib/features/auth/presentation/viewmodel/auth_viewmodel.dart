import 'package:asset_management_mobile/core/utils/secure_storage.dart';
import 'package:asset_management_mobile/features/auth/data/model/user_model.dart';
import 'package:asset_management_mobile/features/auth/presentation/viewmodel/auth_repository_provider.dart';
import 'package:riverpod/riverpod.dart';
import '../../data/model/login_model.dart';

final authViewModelProvider = AsyncNotifierProvider<AuthViewmodel, UserModel?>(
  AuthViewmodel.new,
);

class AuthViewmodel extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    return null;
  }

  Future<void> login(LoginModel model) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final res = await repo.login(model);
      final token = res.token;
      if (token != null) {
        await ref.read(secureStorageProvider).saveToken(token);
      }
      state = AsyncData(res);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
