import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _api = ApiClient.instance;

  /// POST /user-login
  /// Returns UserModel with token on success
  Future<UserModel> login({
    required String mobileNumber,
    required String password,
  }) async {
    final response = await _api.post(
      ApiConstants.userLogin,
      data: {
        'mobile_number': mobileNumber,
        'password': password,
      },
    );
    return UserModel.fromJson(response);
  }

  /// POST /register
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String address,
    required String dob,
    required String mobileNumber,
    required String doj,
    required String location,
  }) async {
    final response = await _api.post(
      ApiConstants.register,
      data: {
        'first_name':    firstName,
        'last_name':     lastName,
        'email':         email,
        'password':      password,
        'address':       address,
        'dob':           dob,
        'mobile_number': mobileNumber,
        'doj':           doj,
        'location':      location,
      },
    );
    return response;
  }
}