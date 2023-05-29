class Clothes {
  int? id;
  String? name;
  String? gender;
  String? section;
  String? description;
  String? imagePath;
  int? lowTemp;
  int? highTemp;

  Clothes({this.id, this.name, this.gender, this.section, this.description,
      this.imagePath, this.lowTemp, this.highTemp});


  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'name': name,
      'gender': gender,
      'section': section,
      'description': description,
      'imagePath': imagePath,
      'lowTemp' : lowTemp,
      'highTemp' : highTemp,
    };
  }
}
