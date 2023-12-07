// To parse this JSON data, do
//
//     final welcome = plantIdAnalizedFromJson(jsonString);

import 'dart:convert';

PlantIdAnalized plantIdAnalizedFromJson(String str) => PlantIdAnalized.fromJson(json.decode(str));

String plantIdAnalizedToJson(PlantIdAnalized data) => json.encode(data.toJson());

class PlantIdAnalized {
    String accessToken; 
    String modelVersion;
    dynamic customId;
    Input input;
    Result result;
    String status;
    bool slaCompliantClient;
    bool slaCompliantSystem;
    double created;
    double completed;

    PlantIdAnalized({
        required this.accessToken,
        required this.modelVersion,
        required this.customId,
        required this.input,
        required this.result,
        required this.status,
        required this.slaCompliantClient,
        required this.slaCompliantSystem,
        required this.created,
        required this.completed,
    });

    factory PlantIdAnalized.fromJson(Map<String, dynamic> json) => PlantIdAnalized(
        accessToken: json["access_token"],
        modelVersion: json["model_version"],
        customId: json["custom_id"],
        input: Input.fromJson(json["input"]),
        result: Result.fromJson(json["result"]),
        status: json["status"],
        slaCompliantClient: json["sla_compliant_client"],
        slaCompliantSystem: json["sla_compliant_system"],
        created: json["created"]?.toDouble(),
        completed: json["completed"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "model_version": modelVersion,
        "custom_id": customId,
        "input": input.toJson(),
        "result": result.toJson(),
        "status": status,
        "sla_compliant_client": slaCompliantClient,
        "sla_compliant_system": slaCompliantSystem,
        "created": created,
        "completed": completed,
    };
}

class Input {
    dynamic latitude;
    dynamic longitude;
    String health;
    List<String> images;
    DateTime datetime;

    Input({
        required this.latitude,
        required this.longitude,
        required this.health,
        required this.images,
        required this.datetime,
    });

    factory Input.fromJson(Map<String, dynamic> json) => Input(
        latitude: json["latitude"],
        longitude: json["longitude"],
        health: json["health"],
        images: List<String>.from(json["images"].map((x) => x)),
        datetime: DateTime.parse(json["datetime"]),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "health": health,
        "images": List<dynamic>.from(images.map((x) => x)),
        "datetime": datetime.toIso8601String(),
    };
}

class Result {
    Is isPlant;
    Is isHealthy;
    Disease disease;

    Result({
        required this.isPlant,
        required this.isHealthy,
        required this.disease,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        isPlant: Is.fromJson(json["is_plant"]),
        isHealthy: Is.fromJson(json["is_healthy"]),
        disease: Disease.fromJson(json["disease"]),
    );

    Map<String, dynamic> toJson() => {
        "is_plant": isPlant.toJson(),
        "is_healthy": isHealthy.toJson(),
        "disease": disease.toJson(),
    };
}

class Disease {
    List<Suggestion> suggestions;

    Disease({
        required this.suggestions,
    });

    factory Disease.fromJson(Map<String, dynamic> json) => Disease(
        suggestions: List<Suggestion>.from(json["suggestions"].map((x) => Suggestion.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "suggestions": List<dynamic>.from(suggestions.map((x) => x.toJson())),
    };
}

class Suggestion {
    String id;
    String name;
    double probability;
    Details details;

    Suggestion({
        required this.id,
        required this.name,
        required this.probability,
        required this.details,
    });

    factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
        id: json["id"],
        name: json["name"],
        probability: json["probability"]?.toDouble(),
        details: Details.fromJson(json["details"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "probability": probability,
        "details": details.toJson(),
    };
}

class Details {
    String language;
    String entityId;

    Details({
        required this.language,
        required this.entityId,
    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        language: json["language"],
        entityId: json["entity_id"],
    );

    Map<String, dynamic> toJson() => {
        "language": language,
        "entity_id": entityId,
    };
}

class Is {
    double probability;
    bool binary;
    double threshold;

    Is({
        required this.probability,
        required this.binary,
        required this.threshold,
    });

    factory Is.fromJson(Map<String, dynamic> json) => Is(
        probability: json["probability"]?.toDouble(),
        binary: json["binary"],
        threshold: json["threshold"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "probability": probability,
        "binary": binary,
        "threshold": threshold,
    };
}
