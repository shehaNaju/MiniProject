class ViewPlaceModel {
  ViewPlaceModel({
    required this.id,
    required this.place,
  });

  String id;
  String place;

  factory ViewPlaceModel.fromJson(Map<String, dynamic> json) => ViewPlaceModel(
        id: json["id"],
        place: json["place"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "place": place,
      };
}
