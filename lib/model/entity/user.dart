class UserEntity {
  String? hiveId;
  String? username;
  String? password;
  String? permission;

  UserEntity({this.hiveId, this.username, this.password, this.permission});

  UserEntity.fromJson(Map<String, dynamic> json) {
    hiveId = json['hiveId'];
    username = json['username'];
    password = json['password'];
    permission = json['permission'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hiveId'] = this.hiveId;
    data['username'] = this.username;
    data['password'] = this.password;
    data['permission'] = this.permission;
    return data;
  }
}
