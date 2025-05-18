import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/database/share_preferences_helper.dart';
import 'package:mobile/model/entity/table_entity.dart';
import 'package:mobile/model/enums/load_status.dart';
import 'package:mobile/repo/order_temp_repo.dart';
import 'package:mobile/repo/product_repo.dart';
import 'package:mobile/utils/logger.dart';

import '../../model/entity/order_temp_entity.dart';
import 'table_state.dart';

class TableCubit extends Cubit<TableState> {
  late IProductRepo _iProductRepo;
  late IOrderTempRepo _iOrderTempRepo;
  TableCubit(this._iOrderTempRepo, this._iProductRepo)
      : super(const TableState());

  void init({required String id}) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      var orderTemp = await _iOrderTempRepo.getOrderTemp(id: id);
      var products = await _iProductRepo.getProduct();
      String? username = await SharedPreferencesHelper().getUser();
      double _price = 0;
      orderTemp.data?.forEach((e) {
        _price += e.totalAmount!;
        e.extras?.forEach((el) {
          _price += el.price!;
        });
      });
      emit(state.copyWith(
          ordersTemp: orderTemp.data,
          products: products.data,
          status: LoadStatus.success,
          total: _price,
          productFiltter: products.data,
          username: username));
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: LoadStatus.failure));
    }
  }

  void fillterProduct({required String fillter}) {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      var products = state.products;
      products = products.where((e) => e.type == fillter).toList();
      emit(
          state.copyWith(status: LoadStatus.success, productFiltter: products));
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: LoadStatus.failure));
    }
  }

  void addOrderTemp(
      {required OrderTempEntity order, required String tableId}) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      var data = await _iOrderTempRepo.addOrderTemp(
          orderTemp: order, tableId: tableId);
      if (data.message == "Success") {
        var orderTemp = await _iOrderTempRepo.getOrderTemp(id: tableId);
        double _price = 0;
        orderTemp.data?.forEach((e) {
          _price += e.totalAmount!;
          e.extras?.forEach((el) {
            _price += el.price!;
          });
        });
        emit(state.copyWith(
          ordersTemp: orderTemp.data,
          status: LoadStatus.success,
          total: _price,
        ));
      }
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: LoadStatus.failure));
    }
  }

  Future order({required TableEntity table}) async {
    if (state.username == null) return;
    _iOrderTempRepo.order(table: table, username: state.username!);
  }
}
