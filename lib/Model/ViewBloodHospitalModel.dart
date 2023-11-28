class ViewBloodHospitalModel {
  ViewBloodHospitalModel(
      {required this.id,
      required this.name,
      required this.isChecked,
      required this.textFieldData});

  String id;
  String name;
  bool isChecked;
  String textFieldData;

  factory ViewBloodHospitalModel.fromJson(Map<String, dynamic> json) =>
      ViewBloodHospitalModel(
        id: json["id"],
        name: json["name"],
        isChecked: false,
        textFieldData: "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isChecked": isChecked,
        "textFieldData": textFieldData,
      };
}
