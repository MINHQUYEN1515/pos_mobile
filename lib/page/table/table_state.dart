import 'package:equatable/equatable.dart';
import 'package:mobile/model/entity/entity.dart';
import 'package:mobile/model/enums/load_status.dart';

class TableState extends Equatable {
  final LoadStatus status;
  final List<OrderTempEntity> ordersTemp;
  final List<Product> products;
  final List<Product> productFiltter;
  final double total;
  final String? username;
  const TableState(
      {this.ordersTemp = const [],
      this.products = const [],
      this.status = LoadStatus.initial,
      this.total = 0,
      this.productFiltter = const [],
      this.username});

  @override
  List<Object?> get props =>
      [status, ordersTemp, products, total, productFiltter, username];
  TableState copyWith(
      {LoadStatus? status,
      List<OrderTempEntity>? ordersTemp,
      List<Product>? products,
      double? total,
      List<Product>? productFiltter,
      String? username}) {
    return TableState(
        status: status ?? this.status,
        ordersTemp: ordersTemp ?? this.ordersTemp,
        products: products ?? this.products,
        total: total ?? this.total,
        productFiltter: productFiltter ?? this.productFiltter,
        username: username ?? this.username);
  }
}
