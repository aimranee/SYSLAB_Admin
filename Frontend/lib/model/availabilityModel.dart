class AvailabilityModel{
  String mon;
  String tue;
  String wed;
  String thu;
  String fri;
  String sat;
  String sun;
  String id;

  AvailabilityModel({
    this.mon,
    this.tue,
    this.wed,
    this.thu,
    this.fri,
    this.sat,
    this.sun,
    this.id
});

  factory AvailabilityModel.fromJson(Map<String,dynamic> json){
    return AvailabilityModel(
    mon: json['mon'],
    tue: json['tue'],
    wed: json['wed'],
    thu: json['thu'],
    fri: json['fri'],
    sat: json['sat'],
    sun: json['sun'],
      id: json['id']

    );
  }
  Map<String,dynamic> toUpdateJson(){
    return {
      "mon":this.mon,
      "tue":this.tue,
      "wed":this.wed,
      "thu":this.thu,
      "fri":this.fri,
      "sat":this.sat,
      "sun":this.sun,
      "id":this.id
    };

  }

}