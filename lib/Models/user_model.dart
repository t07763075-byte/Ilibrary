// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String? email;
  final String? userName;
  final String? phoneNumber;
  final String? countryCode;
  final String? photoUrl;
  final String? token;
  final DateTime? birthDate;

  const UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.userName,
    this.phoneNumber,
    this.countryCode,
    this.photoUrl,
    this.birthDate,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    name: json["name"] ?? (json["firstName"]!= null? "${json["firstName"]} ${json["lastName"]}" : null),
    email: json["email"] == ""? null : json["email"],
    userName: json["userName"],
    phoneNumber: json["phoneNumber"],
    countryCode: json["countryCode"],
    photoUrl: json["photoUrl"],
    birthDate: json["birthDate"] == null? null : DateTime.tryParse(json["birthDate"]),
    token: json["token"],
  );

  UserModel copyWith({String? token,}){
    return UserModel(
      id: id,
      firstName: firstName,
      lastName: lastName,
      name: name,
      email: email,
      userName: userName,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      photoUrl: photoUrl,
      birthDate: birthDate,
      token: token ?? this.token
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "name": name,
    "email": email,
    "userName": userName,
    "phoneNumber": phoneNumber,
    "countryCode": countryCode,
    "photoUrl": photoUrl,
    "birthDate": birthDate?.toIso8601String(),
    "token": token,
  };

  Map<String, String> toUpdateProfileJson() => {
    "firstName": firstName ?? "",
    "lastName": lastName ?? "",
    "BirthDate": birthDate == null ? "" : DateFormat('yyyy-MM-dd').format(birthDate!),
  };
}
