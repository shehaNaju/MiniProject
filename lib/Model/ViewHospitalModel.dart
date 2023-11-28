class ViewHospitalModel {
  String id;
  String mobileno;
  String hospitalname;
  String address;
  String place;
  String district;
  String image;
  List<Bloodstock> bloodstocks;

  ViewHospitalModel({
    required this.id,
    required this.mobileno,
    required this.hospitalname,
    required this.address,
    required this.place,
    required this.district,
    required this.image,
    required this.bloodstocks,
  });

  factory ViewHospitalModel.fromJson(Map<String, dynamic> json) =>
      ViewHospitalModel(
        id: json["id"],
        mobileno: json["mobileno"],
        hospitalname: json["hospitalname"],
        address: json["address"],
        place: json["place"],
        district: json["district"],
        image: json["image"],
        bloodstocks: List<Bloodstock>.from(
            json["bloodstocks"].map((x) => Bloodstock.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mobileno": mobileno,
        "hospitalname": hospitalname,
        "address": address,
        "place": place,
        "district": district,
        "bloodstocks": List<dynamic>.from(bloodstocks.map((x) => x.toJson())),
      };
}

class Bloodstock {
  String bllodgroupname;
  String bloodunitcount;

  Bloodstock({
    required this.bllodgroupname,
    required this.bloodunitcount,
  });

  factory Bloodstock.fromJson(Map<String, dynamic> json) => Bloodstock(
        bllodgroupname: json["bllodgroupname"],
        bloodunitcount: json["bloodunitcount"],
      );

  Map<String, dynamic> toJson() => {
        "bllodgroupname": bllodgroupname,
        "bloodunitcount": bloodunitcount,
      };
}
