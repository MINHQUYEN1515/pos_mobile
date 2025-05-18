import 'package:mobile/model/entity/order_temp_entity.dart';
import 'package:uuid/uuid.dart';

class OrderItemUtils {
  OrderItemUtils._();
  static OrderTempEntity createOrderTemp(
      {required Product product,
      required String tableId,
      String? notes,
      List<Extras>? extras,
      int? quantity,
      String? username,
      int? position}) {
    double _price = 0;
    extras?.forEach((e) {
      _price += e.price!;
    });
    return OrderTempEntity(
        hiveId: Uuid().v4(),
        tableId: tableId,
        product: product,
        note: notes,
        craetedAt: DateTime.now().toString(),
        extras: extras,
        quantity: quantity,
        username: username,
        totalAmount: (quantity! * product.price!) + _price,
        updatedAt: DateTime.now().toString(),
        position: position);
  }
}
