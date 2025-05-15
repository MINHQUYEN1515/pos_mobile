import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/database/share_preferences_helper.dart';
import 'package:mobile/model/enums/load_status.dart';
import 'package:mobile/repo/table_repo.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  late ITableRepo _repo;
  HomeCubit(this._repo) : super(const HomeState());
  void init() async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      var data = await _repo.getTable();
      String? username = await SharedPreferencesHelper().getUser();
      if (data.data?.length != 0) {
        emit(state.copyWith(
            tables: data.data, username: username, status: LoadStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure));
    }
  }

  void fillter({required String fillter}) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      var data = await _repo.fillter(filtter: fillter);
      emit(state.copyWith(tables: data.data, status: LoadStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure));
    }
  }
}
