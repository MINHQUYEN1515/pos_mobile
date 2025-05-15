import 'package:equatable/equatable.dart';
import 'package:mobile/model/entity/table_entity.dart';
import 'package:mobile/model/enums/load_status.dart';

class HomeState extends Equatable {
  final LoadStatus status;
  final List<TableEntity> tables;
  final String? username;
  const HomeState(
      {this.status = LoadStatus.initial,
      this.tables = const [],
      this.username});
  @override
  List<Object?> get props => [status, tables, username];
  HomeState copyWith(
      {LoadStatus? status, List<TableEntity>? tables, String? username}) {
    return HomeState(
        status: status ?? this.status,
        tables: tables ?? this.tables,
        username: username ?? this.username);
  }
}
