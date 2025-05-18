import 'package:mobile/model/entity/order_temp_entity.dart';
import 'package:mobile/network/api_client.dart';

import '../model/response/object_response.dart';

abstract class IProductRepo {
  Future<ObjectResponse<List<Product>>> getProduct();
}

class ProductRepo extends IProductRepo {
  ApiClient apiClient;
  ProductRepo(this.apiClient);
  @override
  Future<ObjectResponse<List<Product>>> getProduct() async {
    return await apiClient.getProduct();
  }
}
