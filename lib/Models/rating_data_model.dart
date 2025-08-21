import 'package:ELibrary/Models/user_model.dart';

class RatingDataModel {
  final int? ratingId;
  final double? rating;
  final String? review;
  final int? objectTypeId;
  final int? objectId;
  final int? totalRatingCount;
   double? totalRating;
  final String? photoUrl;
   int likes;
  final int? disLikes;
   bool isUserLike;
  final bool? isUserDisLike;
  final UserModel? user;
  final DateTime? createdAt;
  final DateTime? lastModifiedAt;

  RatingDataModel({
    this.ratingId,
    this.rating,
    this.review,
    this.objectTypeId,
    this.objectId,
    this.totalRatingCount,
    this.totalRating,
    this.photoUrl,
    this.likes=0,
    this.disLikes,
    this.isUserLike=false,
    this.isUserDisLike,
    this.user,
    this.createdAt,
    this.lastModifiedAt,
  });

  factory RatingDataModel.fromJson(Map<String, dynamic> json) => RatingDataModel(
    ratingId: json["ratingId"],
    rating: json["rating"]?.toDouble(),
    review: json["review"],
    objectTypeId: json["objectTypeId"],
    objectId: json["objectId"],
    totalRatingCount: json["totalRatingCount"],
    totalRating: json["totalRating"]?.toDouble(),
    photoUrl: json["photoUrl"],
    likes: json["likes"]??0,
    disLikes: json["disLikes"],
    isUserLike: json["isUserLike"]??false,
    isUserDisLike: json["isUserDisLike"],
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    lastModifiedAt: json["lastModifiedAt"] == null ? null : DateTime.parse(json["lastModifiedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "ratingId": ratingId,
    "rating": rating,
    "review": review,
    "objectTypeId": objectTypeId,
    "objectId": objectId,
    "totalRatingCount": totalRatingCount,
    "totalRating": totalRating,
    "photoUrl": photoUrl,
    "likes": likes,
    "disLikes": disLikes,
    "isUserLike": isUserLike,
    "isUserDisLike": isUserDisLike,
    "user": user?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "lastModifiedAt": lastModifiedAt?.toIso8601String(),
  };
}