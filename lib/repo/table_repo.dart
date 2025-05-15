import 'package:mobile/model/entity/table_entity.dart';
import 'package:mobile/model/response/object_response.dart';
import 'package:mobile/network/api_client.dart';

abstract class ITableRepo {
  Future<ObjectResponse<List<TableEntity>>> getTable();
  Future<ObjectResponse<List<TableEntity>>> fillter({required String filtter});
}

class TableRepo extends ITableRepo {
  ApiClient apiClient;
  TableRepo(this.apiClient);
  @override
  Future<ObjectResponse<List<TableEntity>>> getTable() async {
    return await apiClient.getTable();
  }

  @override
  Future<ObjectResponse<List<TableEntity>>> fillter(
      {required String filtter}) async {
    return await apiClient.filtterTable({"fillter": filtter});
  }
}
