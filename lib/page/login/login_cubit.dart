import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/database/share_preferences_helper.dart';
import 'package:mobile/model/enums/load_status.dart';
import 'package:mobile/repo/auth_repo.dart';
import 'package:mobile/utils/logger.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  late IAuthRepo _repo;
  LoginCubit(this._repo) : super(const LoginState());

  Future<bool> login(
      {required String username, required String password}) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final data =
          await _repo.authLogin(username: username, password: password);
      if (data.data?.username != null) {
        SharedPreferencesHelper().setUser(data.data!.username!);
        emit(state.copyWith(status: LoadStatus.success));
        return true;
      }
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: LoadStatus.failure));
    }
    return false;
  }
}
