
import 'package:ELibrary/Models/generic_pagination_model.dart';
import 'package:ELibrary/Models/rating_data_model.dart';


class RatingModel {
  final double? totalRating;
  final int? totalRatingCount;
  final double? rating1Count;
  final double? rating2Count;
  final double? rating3Count;
  final double? rating4Count;
  final double? rating5Count;
  final GenericPaginationModel<RatingDataModel>? listRatings;

  const RatingModel({
    this.totalRating,
    this.totalRatingCount,
    this.rating1Count,
    this.rating2Count,
    this.rating3Count,
    this.rating4Count,
    this.rating5Count,
    this.listRatings,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
    totalRating: double.parse(json["totalRating"]?.toString()??'0'),
    totalRatingCount: json["totalRatingCount"],
    rating1Count:double.parse(json["rating1Count"]?.toString()??'0'),
    rating2Count:double.parse(json["rating2Count"]?.toString()??'0'),
    rating3Count:double.parse(json["rating3Count"]?.toString()??'0'),
    rating4Count:double.parse(json["rating4Count"]?.toString()??'0'),
    rating5Count: double.parse(json["rating5Count"]?.toString()??'0'),
    listRatings: GenericPaginationModel.ratingFromJson(json,fromJson:RatingDataModel.fromJson),
  );

  Map<String, dynamic> toJson() => {
    "totalRating": totalRating,
    "totalRatingCount": totalRatingCount,
    "rating1Count": rating1Count,
    "rating2Count": rating2Count,
    "rating3Count": rating3Count,
    "rating4Count": rating4Count,
    "rating5Count": rating5Count,
    // "listRatings":  listRatings,
  };
}




