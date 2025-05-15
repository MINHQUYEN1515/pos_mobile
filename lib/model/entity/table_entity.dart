class TableEntity {
  String? hiveId;
  String? code;
  int? seats;
  double? amount;
  String? craetedAt;
  String? updatedAt;
  String? tableId;
  String? imageBase64;
  String? userName;
  String? position;
  String? status;
  dynamic timeOrder;

  TableEntity(
      {this.hiveId,
      this.code,
      this.seats,
      this.amount,
      this.craetedAt,
      this.updatedAt,
      this.tableId,
      this.imageBase64,
      this.userName,
      this.position,
      this.status,
      this.timeOrder});

  TableEntity.fromJson(Map<String, dynamic> json) {
    hiveId = json['hiveId'];
    code = json['code'];
    seats = json['seats'];
    amount = json['amount'];

    craetedAt = json['craetedAt'];
    updatedAt = json['updatedAt'];
    tableId = json['tableId'];
    imageBase64 = json['imageBase64'];
    userName = json['userName'];
    position = json['position'];
    status = json['status'];
    timeOrder = json['timeOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hiveId'] = this.hiveId;
    data['code'] = this.code;
    data['seats'] = this.seats;
    data['amount'] = this.amount;

    data['craetedAt'] = this.craetedAt;
    data['updatedAt'] = this.updatedAt;
    data['tableId'] = this.tableId;

    data['imageBase64'] = this.imageBase64;
    data['userName'] = this.userName;
    data['position'] = this.position;
    data['status'] = this.status;
    data['timeOrder'] = this.timeOrder;
    return data;
  }
}
