
class ServiceModel {
 String title;
 String subTitle;
 String imageUrl;
 String id;
 String desc;


  ServiceModel({
     this.title,
     this.subTitle,
     this.imageUrl,
     this.id,
     this.desc
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json){
    return ServiceModel(

      title: json['title'],
      subTitle: json['subTitle'],
      imageUrl: json['imageUrl'],
      id: json['id'],
      desc: json['description']

    );
  }

 Map<String, dynamic> toAddJson() {
    return {
      "title": this.title,
      "subTitle": this.subTitle,
      "imageUrl": this.imageUrl,
      "description":this.desc
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      "title": this.title,
      "subTitle": this.subTitle,
      "imageUrl": this.imageUrl,
      "id":this.id,
      "description":this.desc
    };
  }
}