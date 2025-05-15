import 'package:mobile/model/entity/user.dart';
import 'package:mobile/model/response/object_response.dart';
import 'package:mobile/network/api_client.dart';

abstract class IAuthRepo {
  Future<ObjectResponse<UserEntity?>> authLogin(
      {required String username, required String password});
}

class AuthRepo extends IAuthRepo {
  ApiClient apiClient;
  AuthRepo(this.apiClient);
  @override
  Future<ObjectResponse<UserEntity?>> authLogin(
      {required String username, required String password}) async {
    return await apiClient.authLogin(
        {"username": username, "password": password, "permission": "User"});
  }
}
