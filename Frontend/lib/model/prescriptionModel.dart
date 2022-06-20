
class PrescriptionModel {
 String prescription;
 String patientName; //fcm id
 String appointmentId;
 String appointmentTime;
 String appointmentDate;
 String appointmentName;
 String drName;
 String imageUrl;
 String id;
 String patientId;

  PrescriptionModel({
    this.appointmentTime,
    this.appointmentDate,
    this.appointmentId,
    this.appointmentName,
    this.patientName,
    this.prescription,
    this.imageUrl,
    this.drName,
    this.id,
    this.patientId
  });

  factory PrescriptionModel.fromJson(Map<String,dynamic> json){
    return PrescriptionModel(
            appointmentTime: json['appointmentTime'],
      appointmentDate: json['appointmentDate'],
      appointmentId: json['appointmentId'],
      appointmentName: json['appointmentName'],
      prescription: json['prescription'],
      patientName: json['patientName'],
      imageUrl: json['imageUrl'],
      drName: json['drName'],
      id: json['id'].toString()

    );
  }

  Map<String,dynamic> toJsonUpdate(){
    return {
      "prescription":this.prescription,
      "id":this.id,
      "drName":this.drName,
      "patientName":this.patientName,
      "imageUrl":this.imageUrl
    };

  }
  Map<String,dynamic> toJsonAdd(){
    return {
      "appointmentId":this.appointmentId,
      "patientId":this.patientId,
      "appointmentTime":this.appointmentTime,
      "appointmentDate":this.appointmentDate,
      "imageUrl":this.imageUrl,
      "appointmentName":this.appointmentName,
      "drName":this.drName,
      "patientName":this.patientName,
      "prescription":this.prescription,
    };
  }

}