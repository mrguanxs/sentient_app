
class UserInfoEntity{
  num id;
  /// 用户名
  String username;
  /// 年龄
  num age;
  /// 性别
  num sex;
  /// 邮箱
  String email;
  /// 国别号
  String region;
  /// 手机号
  String phone;
  /// 生日
  num birthday;

  UserInfoEntity({
    this.id,
    this.username,
    this.age,
    this.sex,
    this.email,
    this.region,
    this.phone,
    this.birthday
  });

  factory UserInfoEntity.fromJson(Map<String, dynamic> json)=>
      UserInfoEntity(
        id: json["id"],
        username: json["username"],
        age: json["age"],
        sex: json["sex"],
        email: json["email"],
        region: json["region"],
        phone: json["phone"],
        birthday: json["birthday"],
      );
  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "age": age,
    "sex": sex,
    "email": email,
    "region": region,
    "phone": phone,
    "birthday": birthday,
  };
}