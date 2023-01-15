class Alliance {
  bool? isDone = false;

  int? id;
  String? name;
  int? warbands;
  String? icon;

  Alliance({this.id, this.name, this.warbands, this.icon});

  factory Alliance.fromJson(Map<String, dynamic> json) => Alliance(
      id: json["id"],
      name: json["name"],
      warbands: json["warbands"],
      icon: json["icon"]);

  Map<String, dynamic> toJson() => {
      "id": id, 
      "name": name, 
      "warbands": warbands, 
      "icon": icon
    };
}
