
class NotificationModel {
  final int? senderId;
  final int? recipientId;
  final String? title;
  final String? body;
  final String? icon;
  final bool isSeen;
  final dynamic seenDate;
  final DateTime? creationDate;
  final String? showDate;
  final int? notificationEventId;
  final int? notificationTypeId;
  final String? messageKeyString;
  final int? messageKeyId;

  final dynamic entityType;
  final dynamic entityTypeId;
  final int? id;

  NotificationModel({
    this.senderId,
    this.recipientId,
    this.title,
    this.body,
    this.icon,
    this.isSeen=false,
    this.seenDate,
    this.creationDate,
    this.showDate,
    this.notificationEventId,
    this.notificationTypeId,
    this.messageKeyString,
    this.messageKeyId,

    this.entityType,
    this.entityTypeId,
    this.id,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    senderId: json["senderId"],
    recipientId: json["recipientId"],
    title: json["title"],
    body: json["body"],
    icon: json["icon"],
    isSeen: json["isSeen"]??false,
    seenDate: json["seenDate"],
    creationDate: json["creationDate"] == null ? null : DateTime.parse(json["creationDate"]),
    showDate: json["showDate"],
    notificationEventId: json["notificationEventId"],
    notificationTypeId: json["notificationTypeId"],
    messageKeyString: json["messageKeyString"],
    messageKeyId: json["messageKeyId"],

    entityType: json["entityType"],
    entityTypeId: json["entityTypeId"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "senderId": senderId,
    "recipientId": recipientId,
    "title": title,
    "body": body,
    "icon": icon,
    "isSeen": isSeen,
    "seenDate": seenDate,
    "creationDate": creationDate?.toIso8601String(),
    "showDate": showDate,
    "notificationEventId": notificationEventId,
    "notificationTypeId": notificationTypeId,
    "messageKeyString": messageKeyString,
    "messageKeyId": messageKeyId,

    "entityType": entityType,
    "entityTypeId": entityTypeId,
    "id": id,
  };
}
