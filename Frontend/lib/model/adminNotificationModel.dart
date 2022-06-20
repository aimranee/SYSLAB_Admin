
class AdminNotificationModel{
  String body;
  String sendBy;
  String title;
  String uId;
  String createdTimeStamp;
  String id;
  String status;

  AdminNotificationModel({
    this.body,
    this.title,
    this.uId,
    this.createdTimeStamp,
    this.sendBy,
    this.id,
    this.status

  });

  factory AdminNotificationModel.fromJson(Map<String,dynamic> json){
    return AdminNotificationModel(
        title:json['title'],
        body:json['body'],
        sendBy:json['sendBy'],
        uId:json['uId'],
        createdTimeStamp:json['createdTimeStamp'],
        id: json['id'],
         status:"admin"

    );
  }

}