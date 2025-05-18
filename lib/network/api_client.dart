import 'package:dio/dio.dart';

import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../model/entity/entity.dart';

import '../model/response/object_response.dart';
part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST('/login')
  Future<ObjectResponse<UserEntity?>> authLogin(
      @Body() Map<String, dynamic> body);
  @GET('/table')
  Future<ObjectResponse<List<TableEntity>>> getTable();
  @POST('/fillterTable')
  Future<ObjectResponse<List<TableEntity>>> filtterTable(
    @Body() Map<String, dynamic> body,
  );
  @GET('/orderTemp/{id}')
  Future<ObjectResponse<List<OrderTempEntity>>> getOrderTemp(
      @Path('id') String id);
  @GET('/product')
  Future<ObjectResponse<List<Product>>> getProduct();
  @POST('/createOrderTemp')
  Future<ObjectResponse> addOrderTemp(
    @Body() Map<String, dynamic> body,
  );
  @POST('/order')
  Future<ObjectResponse> order(
    @Body() Map<String, dynamic> body,
  );
}
