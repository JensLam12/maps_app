import 'dart:convert';

TrafficResponse? trafficResponseFromJson(String str) => TrafficResponse.fromJson(json.decode(str));

String trafficResponseToJson(TrafficResponse? data) => json.encode(data!.toJson());

class TrafficResponse {
  TrafficResponse({
    required this.routes,
    required this.waypoints,
    required this.code,
    required this.uuid,
  });

  List<Route> routes;
  List<Waypoint> waypoints;
  String code;
  String uuid;

  factory TrafficResponse.fromJson(Map<String, dynamic> json) => TrafficResponse(
    routes: List<Route>.from(json["routes"]!.map((x) => Route.fromJson(x))),
    waypoints: List<Waypoint>.from(json["waypoints"]!.map((x) => Waypoint.fromJson(x))),
    code: json["code"],
    uuid: json["uuid"],
  );

  Map<String, dynamic> toJson() => {
    "routes": routes == null ? [] : List<dynamic>.from(routes!.map((x) => x!.toJson())),
    "waypoints": waypoints == null ? [] : List<dynamic>.from(waypoints!.map((x) => x!.toJson())),
    "code": code,
    "uuid": uuid,
  };
}

class Route {
  Route({
    required this.countryCrossed,
    required this.weightName,
    required this.weight,
    required this.duration,
    required this.distance,
    required this.legs,
    required this.geometry,
  });

  bool countryCrossed;
  String weightName;
  double weight;
  double duration;
  double distance;
  List<Leg?> legs;
  String geometry;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    countryCrossed: json["country_crossed"],
    weightName: json["weight_name"],
    weight: json["weight"].toDouble(),
    duration: json["duration"].toDouble(),
    distance: json["distance"].toDouble(),
    legs: json["legs"] == null ? [] : List<Leg?>.from(json["legs"]!.map((x) => Leg.fromJson(x))),
    geometry: json["geometry"],
  );

  Map<String, dynamic> toJson() => {
    "country_crossed": countryCrossed,
    "weight_name": weightName,
    "weight": weight,
    "duration": duration,
    "distance": distance,
    "legs": legs == null ? [] : List<dynamic>.from(legs.map((x) => x!.toJson())),
    "geometry": geometry,
  };
}

class Leg {
  Leg({
    required this.viaWaypoints,
    required this.admins,
    required this.weight,
    required this.duration,
    required this.steps,
    required this.distance,
    required this.summary,
  });

  List<dynamic> viaWaypoints;
  List<Admin> admins;
  double weight;
  double duration;
  List<dynamic> steps;
  double distance;
  String summary;

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
    viaWaypoints: json["via_waypoints"] == null ? [] : List<dynamic>.from(json["via_waypoints"]!.map((x) => x)),
    admins: List<Admin>.from(json["admins"].map((x) => Admin.fromJson(x))),
    weight: json["weight"].toDouble(),
    duration: json["duration"].toDouble(),
    steps: json["steps"] == null ? [] : List<dynamic>.from(json["steps"]!.map((x) => x)),
    distance: json["distance"].toDouble(),
    summary: json["summary"],
  );

  Map<String, dynamic> toJson() => {
    "via_waypoints": viaWaypoints == null ? [] : List<dynamic>.from(viaWaypoints!.map((x) => x)),
    "admins": admins == null ? [] : List<dynamic>.from(admins!.map((x) => x!.toJson())),
    "weight": weight,
    "duration": duration,
    "steps": steps == null ? [] : List<dynamic>.from(steps!.map((x) => x)),
    "distance": distance,
    "summary": summary,
  };
}

class Admin {
  Admin({
    required this.iso31661Alpha3,
    required this.iso31661,
  });

  String iso31661Alpha3;
  String iso31661;

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    iso31661Alpha3: json["iso_3166_1_alpha3"],
    iso31661: json["iso_3166_1"],
  );

  Map<String, dynamic> toJson() => {
    "iso_3166_1_alpha3": iso31661Alpha3,
    "iso_3166_1": iso31661,
  };
}

class Waypoint {
  
  Waypoint({
    required this.distance,
    required this.name,
    required this.location,
  });

  double distance;
  String name;
  List<double> location;

  factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
    distance: json["distance"].toDouble(),
    name: json["name"],
    location: List<double>.from(json["location"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "distance": distance,
    "name": name,
    "location": location == null ? [] : List<dynamic>.from(location!.map((x) => x)),
  };
}
