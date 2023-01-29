import 'dart:convert';

PlacesResponse PlacesResponseFromJson(String str) => PlacesResponse.fromJson(json.decode(str));

String PlacesResponseToJson(PlacesResponse data) => json.encode(data.toJson());

class PlacesResponse {
  PlacesResponse({
    required this.type,
    //required this.query,
    required this.features,
    required this.attribution,
  });

  String type;
  //List<String> query;
  List<Feature> features;
  String attribution;

  factory PlacesResponse.fromJson(Map<String, dynamic> json) => PlacesResponse(
    type: json["type"],
    //query: List<String>.from(json["query"].map((x) => x)),
    features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
    attribution: json["attribution"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    //"query": List<dynamic>.from(query.map((x) => x)),
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
    "attribution": attribution,
  };
}

class Feature {
  Feature({
    required this.id,
    required this.type,
    required this.placeType,
    required this.properties,
    required this.textEs,
    required this.placeNameEs,
    required this.text,
    required this.placeName,
    required this.center,
    required this.geometry,
    required this.context,
  });

  String id;
  String type;
  List<String> placeType;
  Properties properties;
  String textEs;
  String placeNameEs;
  String text;
  String placeName;
  List<double> center;
  Geometry geometry;
  List<Context> context;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    id: json["id"],
    type: json["type"],
    placeType: List<String>.from(json["place_type"].map((x) => x)),
    properties: Properties.fromJson(json["properties"]),
    textEs: json["text_es"],
    placeNameEs: json["place_name_es"],
    text: json["text"],
    placeName: json["place_name"],
    center: List<double>.from(json["center"].map((x) => x?.toDouble())),
    geometry: Geometry.fromJson(json["geometry"]),
    context: List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "place_type": List<dynamic>.from(placeType.map((x) => x)),
    "properties": properties.toJson(),
    "text_es": textEs,
    "place_name_es": placeNameEs,
    "text": text,
    "place_name": placeName,
    "center": List<dynamic>.from(center.map((x) => x)),
    "geometry": geometry.toJson(),
    "context": List<dynamic>.from(context.map((x) => x.toJson())),
  };
}

class Context {
  Context({
    required this.id,
    required this.textEs,
    required this.text,
    this.wikidata,
    this.languageEs,
    this.language,
    this.shortCode,
  });

  String id;
  String textEs;
  String text;
  String? wikidata;
  String? languageEs;
  String? language;
  String? shortCode;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
    id: json["id"],
    textEs: json["text_es"],
    text: json["text"],
    wikidata: json["wikidata"],
    languageEs: json["language_es"],
    language: json["language"],
    shortCode: json["short_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text_es": textEs,
    "text": text,
    "wikidata": wikidata,
    "language_es": languageEs,
    "language": language,
    "short_code": shortCode,
  };
}

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    type: json["type"],
    coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

class Properties {
  Properties({
    required this.accuracy,
  });

  String? accuracy;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    accuracy: json["accuracy"],
  );

  Map<String, dynamic> toJson() => {
    "accuracy": accuracy,
  };
}
