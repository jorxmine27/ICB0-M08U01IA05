class Warband {
  bool? isDone = false;

  int? id;
  int? id_faction;
  String? alliance;
  String? warband;

  Warband({this.id, this.id_faction, this.alliance, this.warband});

  factory Warband.fromJson(Map<String, dynamic> json) => Warband(
      id: json["id"],
      id_faction: json["id_faction"],
      alliance: json["alliance"],
      warband: json["warband"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_faction": id_faction,
        "alliance": alliance,
        "warband": warband
      };
}
