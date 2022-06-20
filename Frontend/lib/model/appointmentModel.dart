
class AppointmentModel{
  String appointmentDate;
  String appointmentStatus;
  String appointmentTime;
  String pCity;
  String age;
  String pEmail;
  String pFirstName;
  String pLastName;
  String serviceName;
  int serviceTimeMin;
  String uId;
  String pPhn;
  String description;
  String searchByName;
  String uName;
  String id;
  String createdTimeStamp;
  String updatedTimeStamp;
  String gender;
  AppointmentModel({
    this.appointmentDate,
    this.appointmentStatus,
    this.appointmentTime,
    this.pCity,
    this.age,
    this.pEmail,
    this.pFirstName,
    this.pLastName,
    this.serviceName,
    this.serviceTimeMin,
    this.uId,
    this.pPhn,
    this.description,
    this.searchByName,
    this.uName,
    this.id,
    this.createdTimeStamp,
    this.updatedTimeStamp,
    this.gender

  });

  factory AppointmentModel.fromJson(Map<String,dynamic> json){
    return AppointmentModel(
      appointmentDate:json['appointmentDate'],
      appointmentStatus:json['appointmentStatus'],
      appointmentTime:json['appointmentTime'],
      pCity:json['pCity'],
      age:json['age'],
      pEmail:json['pEmail'],
      pFirstName:json['pFirstName'],
      pLastName:json['pLastName'],
      serviceName:json['serviceName'],
      serviceTimeMin:int.parse(json['serviceTimeMin'],),
      uId:json['uId'],
      pPhn:json['pPhn'],
      description:json['description'],
      searchByName:json['searchByName'],
      uName:json['uName'],
        id:json['id'],
        createdTimeStamp:json['createdTimeStamp'],
        updatedTimeStamp:json['updatedTimeStamp'],
      gender: json["gender"]

    );
  }
   Map<String,dynamic> toJsonUpdate(){
    return {

      "id":this.id,
      "pCity":this.pCity,
      "age":this.age,
      "pEmail":this.pEmail,
      "pFirstName":this.pFirstName,
      'pLastName':this.pLastName,
      "pPhn":this.pPhn,
      "description":this.description,
      "searchByName":this.searchByName,
      "gender":this.gender
    };

  }
  Map<String,dynamic> toJsonUpdateStatus(){
    return {

      "appointmentStatus":this.appointmentStatus,
      "id":this.id,

    };

  }
  Map<String,dynamic> toJsonUpdateResch(){
    return {
      "appointmentStatus":this.appointmentStatus,
      "id":this.id,
      "appointmentDate":this.appointmentDate,
      "appointmentTime":this.appointmentTime

    };

  }
  Map<String,dynamic> toJsonAdd(){
    return {
      "appointmentDate":this.appointmentDate,
      "appointmentStatus":this.appointmentStatus,
      "appointmentTime":this.appointmentTime,
      "pCity":this.pCity,
      "age":this.age,
      "pEmail":this.pEmail,
      "pFirstName":this.pFirstName,
      'pLastName':this.pLastName,
      "serviceName":this.serviceName,
      "serviceTimeMin":(this.serviceTimeMin).toString(),
      "uId":this.uId,
      "pPhn":this.pPhn,
      "description":this.description,
      "searchByName":this.searchByName,
      "uName":this.uName,
      "gender":this.gender,


    };

  }
}