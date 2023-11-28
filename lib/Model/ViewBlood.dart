class ViewBloodModel {
    ViewBloodModel({
        required this.id,
        required this.name,
    
    });

    String id;
    String name;
 

    factory ViewBloodModel.fromJson(Map<String, dynamic> json) => ViewBloodModel(
        id: json["id"],
        name: json["name"],
       
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      
    };
}
