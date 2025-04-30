import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final tokenStatusProvider = Provider((ref) => TokenStatus(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class TokenStatus {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  TokenStatus({required this.ref, required this.sharedPreferenceHelper});

  // Gives false if token is expired
  bool isAccessTokenExpired() {
    try {
      final token = sharedPreferenceHelper.getString(tokenKey);

      if (token != null) {
        final result = JwtDecoder.isExpired(token);
        return result;
      }

      return true;
    } catch (error) {
      return true;
    }
  }

  // Gives false if token is expired
  bool isRefreshTokenValid() {
    final refreshToken = sharedPreferenceHelper.getString(refreshTokenKey);

    if (refreshToken != null) {
      final result = JwtDecoder.isExpired(refreshToken);
      return result;
    }

    return false;
  }
}
