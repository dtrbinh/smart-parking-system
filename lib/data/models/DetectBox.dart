// To parse this JSON data, do
//
//     final detectBox = detectBoxFromJson(jsonString);

import 'dart:convert';

class DetectBox {
  DetectBox({
    required this.predictions,
    required this.image,
  });

  final List<Prediction> predictions;
  final Image image;

  factory DetectBox.fromRawJson(String str) =>
      DetectBox.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetectBox.fromJson(Map<String, dynamic> json) => DetectBox(
        predictions: List<Prediction>.from(
            json["predictions"].map((x) => Prediction.fromJson(x))),
        image: Image.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "predictions": List<dynamic>.from(predictions.map((x) => x.toJson())),
        "image": image.toJson(),
      };
}

class Image {
  Image({
    required this.width,
    required this.height,
  });

  final int width;
  final int height;

  factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
      };
}

class Prediction {
  Prediction({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.predictionClass,
    required this.confidence,
  });

  final double x;
  final double y;
  final int width;
  final int height;
  final String predictionClass;
  final double confidence;

  factory Prediction.fromRawJson(String str) =>
      Prediction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        x: json["x"].toDouble(),
        y: json["y"].toDouble(),
        width: json["width"],
        height: json["height"],
        predictionClass: json["class"],
        confidence: json["confidence"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
        "width": width,
        "height": height,
        "class": predictionClass,
        "confidence": confidence,
      };
}
