import 'package:asset_management_mobile/core/network/dio_client.dart';
import 'package:asset_management_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:riverpod/riverpod.dart';

final authDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final dio = ref.read(dioProvider);
  return AuthRemoteDatasource(dio);
});
