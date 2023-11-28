// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

HospitalProfileModel welcomeFromJson(String str) =>
    HospitalProfileModel.fromJson(json.decode(str));

String welcomeToJson(HospitalProfileModel data) => json.encode(data.toJson());

class HospitalProfileModel {
  String msg;
  String id;
  String hospitalname;
  String address;
  String place;
  String district;
  String image;
  List<BloodstockHospital> bloodstocks;

  HospitalProfileModel({
    required this.msg,
    required this.id,
    required this.hospitalname,
    required this.address,
    required this.place,
    required this.district,
    required this.image,
    required this.bloodstocks,
  });

  factory HospitalProfileModel.fromJson(Map<String, dynamic> json) =>
      HospitalProfileModel(
        msg: json["msg"],
        id: json["id"],
        hospitalname: json["hospitalname"],
        address: json["address"],
        place: json["place"],
        district: json["district"],
        image: json["image"],
        bloodstocks: List<BloodstockHospital>.from(
            json["bloodstocks"].map((x) => BloodstockHospital.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "id": id,
        "hospitalname": hospitalname,
        "address": address,
        "place": place,
        "district": district,
        "image": image,
        "bloodstocks": List<dynamic>.from(bloodstocks.map((x) => x.toJson())),
      };
}

class BloodstockHospital {
  String bllodgroupname;
  String bloodunitcount;

  BloodstockHospital({
    required this.bllodgroupname,
    required this.bloodunitcount,
  });

  factory BloodstockHospital.fromJson(Map<String, dynamic> json) =>
      BloodstockHospital(
        bllodgroupname: json["bllodgroupname"],
        bloodunitcount: json["bloodunitcount"],
      );

  Map<String, dynamic> toJson() => {
        "bllodgroupname": bllodgroupname,
        "bloodunitcount": bloodunitcount,
      };
}
