import 'package:json_annotation/json_annotation.dart';

part 'object_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ObjectResponse<T> {
  @JsonKey(defaultValue: "")
  final String message;
  @JsonKey()
  final T? data;
  @JsonKey()
  final bool success;

  ObjectResponse({
    this.message = "",
    this.success = false,
    this.data,
  });

  factory ObjectResponse.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    if (json['data'] != null &&
        (json['data'] is Map<String, dynamic> || json['data'] is List)) {
      return _$ObjectResponseFromJson(json, fromJsonT);
    }
    ObjectResponse<T> resultGeneric = ObjectResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] ?? "",
    );

    /// cho những TH là kiểu dữ liệu nguyên thủy: String, int, double ...
    return resultGeneric.copyWith(data: json['data']);
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ObjectResponseToJson(this, toJsonT);

  ObjectResponse<T> copyWith({
    bool? success,
    dynamic message,
    T? data,
  }) {
    return ObjectResponse<T>(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
