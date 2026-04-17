import 'package:asset_management_mobile/core/network/api_exception.dart';
import 'package:asset_management_mobile/features/auth/data/model/user_model.dart';
import 'package:dio/dio.dart';
import '../model/login_model.dart';

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource(this.dio);

  Future<UserModel> login(LoginModel model) async {
    try {
      final response = await dio.post('/auth/login', data: model.toJson());

      return UserModel.fromJson(response.data);
    } catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
