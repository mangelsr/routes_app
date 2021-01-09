// To parse this JSON data, do
//
//     final locationInfoResponse = locationInfoResponseFromJson(jsonString);

import 'dart:convert';

LocationInfoResponse locationInfoResponseFromJson(String str) =>
    LocationInfoResponse.fromJson(json.decode(str));

String locationInfoResponseToJson(LocationInfoResponse data) =>
    json.encode(data.toJson());

class LocationInfoResponse {
  LocationInfoResponse({
    this.type,
    this.query,
    this.features,
    this.attribution,
  });

  String type;
  List<double> query;
  List<Feature> features;
  String attribution;

  factory LocationInfoResponse.fromJson(Map<String, dynamic> json) =>
      LocationInfoResponse(
        type: json["type"],
        query: List<double>.from(json["query"].map((x) => x.toDouble())),
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "query": List<dynamic>.from(query.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "attribution": attribution,
      };
}

class Feature {
  Feature({
    this.id,
    this.type,
    this.placeType,
    this.relevance,
    this.properties,
    this.text,
    this.placeName,
    this.center,
    this.geometry,
    this.address,
    this.context,
    this.bbox,
  });

  String id;
  String type;
  List<String> placeType;
  int relevance;
  Properties properties;
  String text;
  String placeName;
  List<double> center;
  Geometry geometry;
  String address;
  List<Context> context;
  List<double> bbox;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"],
        properties: Properties.fromJson(json["properties"]),
        text: json["text"],
        placeName: json["place_name"],
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        address: json["address"] == null ? null : json["address"],
        context: json["context"] == null
            ? null
            : List<Context>.from(
                json["context"].map((x) => Context.fromJson(x))),
        bbox: json["bbox"] == null
            ? null
            : List<double>.from(json["bbox"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "relevance": relevance,
        "properties": properties.toJson(),
        "text": text,
        "place_name": placeName,
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        "address": address == null ? null : address,
        "context": context == null
            ? null
            : List<dynamic>.from(context.map((x) => x.toJson())),
        "bbox": bbox == null ? null : List<dynamic>.from(bbox.map((x) => x)),
      };
}

class Context {
  Context({
    this.id,
    this.text,
    this.wikidata,
    this.shortCode,
  });

  String id;
  String text;
  Wikidata wikidata;
  ShortCode shortCode;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        text: json["text"],
        wikidata: json["wikidata"] == null
            ? null
            : wikidataValues.map[json["wikidata"]],
        shortCode: json["short_code"] == null
            ? null
            : shortCodeValues.map[json["short_code"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "wikidata": wikidata == null ? null : wikidataValues.reverse[wikidata],
        "short_code":
            shortCode == null ? null : shortCodeValues.reverse[shortCode],
      };
}

enum ShortCode { US_NY, US }

final shortCodeValues =
    EnumValues({"us": ShortCode.US, "US-NY": ShortCode.US_NY});

enum Wikidata { Q11299, Q60, Q1384, Q30 }

final wikidataValues = EnumValues({
  "Q11299": Wikidata.Q11299,
  "Q1384": Wikidata.Q1384,
  "Q30": Wikidata.Q30,
  "Q60": Wikidata.Q60
});

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class Properties {
  Properties({
    this.accuracy,
    this.wikidata,
    this.shortCode,
  });

  String accuracy;
  Wikidata wikidata;
  ShortCode shortCode;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        accuracy: json["accuracy"] == null ? null : json["accuracy"],
        wikidata: json["wikidata"] == null
            ? null
            : wikidataValues.map[json["wikidata"]],
        shortCode: json["short_code"] == null
            ? null
            : shortCodeValues.map[json["short_code"]],
      );

  Map<String, dynamic> toJson() => {
        "accuracy": accuracy == null ? null : accuracy,
        "wikidata": wikidata == null ? null : wikidataValues.reverse[wikidata],
        "short_code":
            shortCode == null ? null : shortCodeValues.reverse[shortCode],
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
