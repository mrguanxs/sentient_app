import 'package:sentient_app/entity/user.dart';
import 'package:sentient_app/utils/http.dart';

const authApiPrefix = '/api/vs/manage-auth';

class AuthApi{

  /// 用户名密码登录
  static Future<UserInfoEntity> pwdLogin(String username, String password) async {
    Map<String, dynamic> params = {
      "username": username,
      "password": password
    };
    var response = await HttpUtil().post(authApiPrefix + '/pwd-login', params: params);
    return UserInfoEntity.fromJson(response);
  }

  /// 注册
  static Future<UserInfoEntity> register(String username, String email, String password) async {
    Map<String, dynamic> params = {
      "username": username,
      "email": email,
      "password": password
    };
    var response = await HttpUtil().post(authApiPrefix + '/register', params: params);
    return UserInfoEntity.fromJson(response);
  }
}