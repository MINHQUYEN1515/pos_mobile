class OrderTempEntity {
  String? hiveId;
  String? code;
  String? username;
  double? amount;
  Product? product;
  int? quantity;
  String? craetedAt;
  String? updatedAt;
  double? totalAmount;
  String? tableId;
  String? note;
  List<Extras>? extras;
  int? position;

  OrderTempEntity(
      {this.hiveId,
      this.code,
      this.username,
      this.amount,
      this.product,
      this.quantity,
      this.craetedAt,
      this.updatedAt,
      this.totalAmount,
      this.tableId,
      this.note,
      this.extras,
      this.position});

  OrderTempEntity.fromJson(Map<String, dynamic> json) {
    hiveId = json['hiveId'];
    code = json['code'];
    username = json['username'];
    amount = json['amount'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
    craetedAt = json['craetedAt'];
    updatedAt = json['updatedAt'];
    totalAmount = json['totalAmount'];
    tableId = json['tableId'];
    note = json['note'];
    if (json['extras'] != null) {
      extras = <Extras>[];
      json['extras'].forEach((v) {
        extras!.add(new Extras.fromJson(v));
      });
    }
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hiveId'] = this.hiveId;
    data['code'] = this.code;
    data['username'] = this.username;
    data['amount'] = this.amount;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['quantity'] = this.quantity;
    data['craetedAt'] = this.craetedAt;
    data['updatedAt'] = this.updatedAt;
    data['totalAmount'] = this.totalAmount;
    data['tableId'] = this.tableId;
    data['note'] = this.note;
    if (this.extras != null) {
      data['extras'] = this.extras!.map((v) => v.toJson()).toList();
    }
    data['position'] = this.position;
    return data;
  }
}

class Product {
  String? hiveId;
  String? name;
  double? price;
  String? type;
  String? code;
  String? image;
  String? craetedAt;
  String? updatedAt;
  List<Extras>? extras;

  Product(
      {this.hiveId,
      this.name,
      this.price,
      this.type,
      this.code,
      this.image,
      this.craetedAt,
      this.updatedAt,
      this.extras});

  Product.fromJson(Map<String, dynamic> json) {
    hiveId = json['hiveId'];
    name = json['name'];
    price = json['price'];
    type = json['type'];
    code = json['code'];
    image = json['image'];
    craetedAt = json['craetedAt'];
    updatedAt = json['updatedAt'];
    if (json['extras'] != null) {
      extras = <Extras>[];
      json['extras'].forEach((v) {
        extras!.add(new Extras.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hiveId'] = this.hiveId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['type'] = this.type;
    data['code'] = this.code;
    data['image'] = this.image;
    data['craetedAt'] = this.craetedAt;
    data['updatedAt'] = this.updatedAt;
    if (this.extras != null) {
      data['extras'] = this.extras!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Extras {
  String? hiveId;
  String? name;
  double? price;
  String? createdAt;
  int? quantity;
  double? total;

  Extras(
      {this.hiveId,
      this.name,
      this.price,
      this.createdAt,
      this.quantity,
      this.total});

  Extras.fromJson(Map<String, dynamic> json) {
    hiveId = json['hiveId'];
    name = json['name'];
    price = json['price'];
    createdAt = json['createdAt'];
    quantity = json['quantity'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hiveId'] = this.hiveId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['createdAt'] = this.createdAt;
    data['quantity'] = this.quantity;
    data['total'] = this.total;
    return data;
  }
}
