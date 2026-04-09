import 'package:asset_management_mobile/features/auth/presentation/viewmodel/auth_datasource_provider.dart';
import 'package:riverpod/riverpod.dart';
import '../../data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authRemoteDatasource = ref.read(authDatasourceProvider);
  return AuthRepository(remoteDatasource: authRemoteDatasource);
});
