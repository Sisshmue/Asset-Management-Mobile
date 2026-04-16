import 'package:asset_management_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:asset_management_mobile/features/auth/data/model/login_model.dart';
import 'package:asset_management_mobile/features/auth/data/model/user_model.dart';

class AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepository({required this.remoteDatasource});

  Future<UserModel> login(LoginModel model) async {
    return await remoteDatasource.login(model);
  }
}
