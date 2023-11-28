class ViewBloodReqModel {
  String id;
  String name;
  String blood;
  String place;
  String whno;
  String mainno;
  String image;

  ViewBloodReqModel({
    required this.id,
    required this.name,
    required this.blood,
    required this.place,
    required this.whno,
    required this.mainno,
    required this.image,
  });

  factory ViewBloodReqModel.fromJson(Map<String, dynamic> json) =>
      ViewBloodReqModel(
        id: json["id"],
        name: json["name"],
        blood: json["blood"],
        place: json["place"],
        whno: json["whno"],
        mainno: json["image"],
        image: json["image"],
      );
}
