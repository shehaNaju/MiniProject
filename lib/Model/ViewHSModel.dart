class ViewHSModel {
  ViewHSModel({
    required this.id,
    required this.hsname,
  });

  String id;
  String hsname;

  factory ViewHSModel.fromJson(Map<String, dynamic> json) => ViewHSModel(
        id: json["id"],
        hsname: json["hsname"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hsname": hsname,
      };
}
