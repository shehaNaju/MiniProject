class UpdateBloodModel {
  UpdateBloodModel(
      {required this.id, required this.name, required this.textFieldData});

  String id;
  String name;

  String textFieldData;

  factory UpdateBloodModel.fromJson(Map<String, dynamic> json) =>
      UpdateBloodModel(
        id: json["id"],
        name: json["name"],
        textFieldData: json["textFieldData"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "textFieldData": textFieldData,
      };
}
