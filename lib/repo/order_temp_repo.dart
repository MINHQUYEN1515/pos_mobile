import 'package:mobile/model/entity/entity.dart';
import 'package:mobile/network/api_client.dart';

import '../model/response/object_response.dart';

abstract class IOrderTempRepo {
  Future<ObjectResponse<List<OrderTempEntity>>> getOrderTemp(
      {required String id});
  Future<ObjectResponse> addOrderTemp(
      {required OrderTempEntity orderTemp, required String tableId});
  Future<ObjectResponse> order(
      {required TableEntity table, required String username});
}

class OrderTempRepo extends IOrderTempRepo {
  ApiClient apiClient;
  OrderTempRepo(this.apiClient);
  @override
  Future<ObjectResponse<List<OrderTempEntity>>> getOrderTemp(
      {required String id}) async {
    return await apiClient.getOrderTemp(id);
  }

  @override
  Future<ObjectResponse> addOrderTemp(
      {required OrderTempEntity orderTemp, required String tableId}) async {
    return await apiClient.addOrderTemp(
        {"order_temp": orderTemp.toJson(), "position": 0, "table_id": tableId});
  }

  @override
  Future<ObjectResponse> order(
      {required TableEntity table, required String username}) async {
    return await apiClient
        .order({"table": table.toJson(), "username": username});
  }
}
