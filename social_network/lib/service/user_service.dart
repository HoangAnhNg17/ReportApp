import 'package:social_network/service/api_service.dart';
import '../model/user.dart';

extension UserService on APIService {
  Future<User> login({
    required String phone,
    required String password,
  }) async {
    final body = {
      'PhoneNumber': phone,
      'Password': password,
    };

    final result = await request(
      path: '/api/accounts/login',
      method: Method.post,
      body: body,
    );

    final user = User.fromJson(result);
    return user;
  }

  Future<User> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final body = {
      'Name': name,
      'PhoneNumber': phone,
      'Email': email,
      'Password': password,
    };

    final result = await request(
      path: '/api/accounts/register',
      method: Method.post,
      body: body,
    );

    final user = User.fromJson(result);
    return user;
  }

  Future<User> updateProfile(
      {required String name,
      required String email,
      required String address,
      required String birth,
      required String gender,
      required String avatar}) async {
    final body = {
      'Name': name,
      'email': email,
      'address': address,
      'dateOfBirth': birth,
      'gender': gender,
      'avatar': avatar,
    };

    final result = await request(
      path: '/api/accounts/update',
      method: Method.post,
      body: body,
    );

    final user = User.fromJson(result);
    return user;
  }

  Future<User> getProfile() async {
    final result = await request(path: '/api/accounts/profile');
    final profileUser = User.fromJson(result);
    return profileUser;
  }
  
  Future<bool> changePassword({
  required String oldPassword,
    required String newPassword,
}) async {
    final body = {
      'OldPassword': oldPassword,
      'NewPassword': newPassword,
    };
    final result = await request(path: '/api/accounts/changePassword', method: Method.post, body: body);
    return result;
  }
}
