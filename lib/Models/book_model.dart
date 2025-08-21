import 'package:ELibrary/Models/user_model.dart';
import 'book_category_model.dart';
import 'book_language_model.dart';
import 'book_subject_model.dart';


class BookModel {
  static const String idText = "id";
  static const String titleText = "title";
  static const String imageUrlText = "imageUrl";
  static const String pageCountText = "pageCount";
  static const String downloadCountText = "downloadCount";
  static const String totalRatingCountText = "totalRatingCount";
  static const String totalRatingText = "totalRating";
  static const String isSyncedText = "isSynced";
  static const String lastReadingTimeText = "lastReadingTime";


   double rating1Count;
   double rating2Count;
   double rating3Count;
   double rating4Count;
   double rating5Count;
   double myRate;
   int totalRatingCount;
   String? pageCount;
   String? myReview;
   bool inWishlist;
   bool isFinished;
   bool isStartToRead;
  final String? title;
  final String? imageUrl;
  final String? highlightText;
  final int? downloadCount;
  final int? page;
 double totalRating;
 final DateTime? lastReadingTime;
 final bool isSynced;

  final List<BookSubjectModel> bookSubjects;
  final List<BookCategoryModel> bookCategories;
  final List<UserModel> bookAuthors;
  final List<BookLanguageModel> bookLanguages;
  final int? id;
  final int? bookHighlightId;
  final int? bookMarkId;

  BookModel({
    this.rating1Count=0,
    this.rating2Count=0,
    this.rating3Count=0,
    this.rating4Count=0,
    this.rating5Count=0,
    this.totalRatingCount=0,
    this.inWishlist=false,
    this.isStartToRead=false,
    this.isFinished=false,
    this.title,
    this.myReview,
    this.imageUrl,
    this.highlightText,
    this.downloadCount,
    this.page,
    this.totalRating=0,
    this.pageCount='0',
    this.myRate=1,

    this.bookSubjects=const[],
    this.bookCategories=const[],
    this.bookAuthors=const[],
    this.bookLanguages=const[],
    this.id,
    this.bookHighlightId,
    this.bookMarkId,
    this.isSynced = false,
    this.lastReadingTime
  });
  String? get totalReviews {
    if (totalRatingCount >= 1000000) {
      return "${(totalRatingCount / 1000000).toStringAsFixed(1)}M";
    } else if (totalRatingCount >= 1000) {
      return "${(totalRatingCount / 1000).toStringAsFixed(1)}K";
    } else {
      return totalRatingCount.toString();
    }
  }

  BookModel copyWith({bool? isSynced,DateTime? lastReadingTime}) {
    return BookModel(
      id: id,
      title: title,
      imageUrl: imageUrl,
      pageCount: pageCount,
      downloadCount: downloadCount,
      totalRatingCount: totalRatingCount,
      totalRating: totalRating,
      lastReadingTime: lastReadingTime ?? this.lastReadingTime,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {

    return BookModel(
      id: json[idText],
      title: json[titleText],
      imageUrl: json[imageUrlText],
      pageCount:json[pageCountText]?.toString() ?? "0",
      downloadCount: json[downloadCountText],
      totalRatingCount: json[totalRatingCountText] ?? 0,
      totalRating: double.tryParse(json[totalRatingText]?.toString() ?? '0') ?? 0,

    rating1Count: double.tryParse(json["rating1Count"]?.toString()??'0')??0,
    rating2Count:double.tryParse(json["rating2Count"]?.toString()??'0')??0,
    rating3Count:double.tryParse(json["rating3Count"]?.toString()??'0')??0,
    rating4Count:double.tryParse(json["rating4Count"]?.toString()??'0')??0,
    rating5Count:double.tryParse(json["rating5Count"]?.toString()??'0')??0,
    myRate:double.tryParse(json["myRate"]?.toString()??'0')??1,
    inWishlist: json["inWishlist"]??false,
      isStartToRead: json["isStartToRead"]??false,
      myReview: json["myReview"],
      isFinished: json["isFinished"]??false,
    bookHighlightId: json["bookHighlightId"],
    highlightText: json["highlight"],
    page: json["page"],
    bookSubjects: json["bookSubjects"] == null ? [] : List<BookSubjectModel>.from(json["bookSubjects"]!.map((x) => BookSubjectModel.fromJson(x))),
    bookCategories: json["bookCategories"] == null ? [] : List<BookCategoryModel>.from(json["bookCategories"]!.map((x) => BookCategoryModel.fromJson(x))),
    bookAuthors: json["bookAuthers"] == null ? [] : List<UserModel>.from(json["bookAuthers"]!.map((x) => UserModel.fromJson(x))),
    bookLanguages: json["bookLanguages"] == null ? [] : List<BookLanguageModel>.from(json["bookLanguages"]!.map((x) => BookLanguageModel.fromJson(x))),
    bookMarkId: json["bookMarkId"],
  );
  }

  Map<String, dynamic> toJson() => {
    idText: id,
    titleText: title,
    imageUrlText: imageUrl,
    pageCountText: pageCount,
    downloadCountText: downloadCount,
    totalRatingCountText: totalRatingCount,
    totalRatingText: totalRating,
    "rating1Count": rating1Count,
    "rating2Count": rating2Count,
    "rating3Count": rating3Count,
    "rating4Count": rating4Count,
    "rating5Count": rating5Count,
    "inWishlist": inWishlist,
    "isStartToRead": isStartToRead,
    "page": page,
    "myReview": myReview,
    "isFinished": isFinished,
    "bookHighlightId": bookHighlightId,
    "highlight": highlightText,
    "bookSubjects":  List<dynamic>.from(bookSubjects.map((x) => x.toJson())),
    "bookCategories": List<dynamic>.from(bookCategories.map((x) => x.toJson())),
    "bookAuthers":  List<dynamic>.from(bookAuthors.map((x) => x.toJson())),
    "bookLanguages": List<dynamic>.from(bookLanguages.map((x) => x.toJson())),
    "bookMarkId": bookMarkId,
  };
  Map<String, dynamic> toJsonDB() => {
    idText: id,
    titleText: title,
    imageUrlText: imageUrl,
    pageCountText: pageCount,
    downloadCountText: downloadCount,
    totalRatingCountText: totalRatingCount,
    totalRatingText: totalRating,
  };
}








