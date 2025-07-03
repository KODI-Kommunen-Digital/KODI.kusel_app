import 'package:core/base_model.dart';

class DigifitInformationResponseModel
    extends BaseModel<DigifitInformationResponseModel> {
  final DigifitInformationDataModel? data;
  final String? status;

  DigifitInformationResponseModel({
    this.data,
    this.status,
  });

  @override
  DigifitInformationResponseModel fromJson(Map<String, dynamic> json) {
    return DigifitInformationResponseModel(
      data: json['data'] != null
          ? DigifitInformationDataModel().fromJson(json['data'])
          : null,
      status: json['status'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'status': status,
    };
  }
}

class DigifitInformationDataModel {
  final DigifitInformationUserStatsModel? userStats;
   List<DigifitInformationParcoursModel>? parcours;
  final DigifitInformationActionsModel? actions;

  DigifitInformationDataModel({
    this.userStats,
    this.parcours,
    this.actions,
  });

  DigifitInformationDataModel fromJson(Map<String, dynamic> json) {
    return DigifitInformationDataModel(
      userStats: json['userStats'] != null
          ? DigifitInformationUserStatsModel().fromJson(json['userStats'])
          : null,
      parcours: json['parcours'] != null
          ? List<DigifitInformationParcoursModel>.from(json['parcours']
              .map((e) => DigifitInformationParcoursModel().fromJson(e)))
          : null,
      actions: json['actions'] != null
          ? DigifitInformationActionsModel().fromJson(json['actions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userStats': userStats?.toJson(),
      'parcours': parcours?.map((e) => e.toJson()).toList(),
      'actions': actions?.toJson(),
    };
  }
}

class DigifitInformationUserStatsModel {
  final int? points;
  final int? trophies;

  DigifitInformationUserStatsModel({
    this.points,
    this.trophies,
  });

  DigifitInformationUserStatsModel fromJson(Map<String, dynamic> json) {
    return DigifitInformationUserStatsModel(
      points: json['points'],
      trophies: json['trophies'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'trophies': trophies,
    };
  }
}

class DigifitInformationParcoursModel {
  final String? name;
  final int? locationId;
  final String? mapImageUrl;
  final String? showParcoursUrl;
   List<DigifitInformationStationModel>? stations;

  DigifitInformationParcoursModel({
    this.name,
    this.locationId,
    this.mapImageUrl,
    this.showParcoursUrl,
    this.stations,
  });

  DigifitInformationParcoursModel fromJson(Map<String, dynamic> json) {
    return DigifitInformationParcoursModel(
      name: json['name'],
      locationId: json['locationId'],
      mapImageUrl: json['mapImageUrl'],
      showParcoursUrl: json['showParcoursUrl'],
      stations: json['stations'] != null
          ? List<DigifitInformationStationModel>.from(json['stations']
              .map((e) => DigifitInformationStationModel().fromJson(e)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'locationId': locationId,
      'mapImageUrl': mapImageUrl,
      'showParcoursUrl': showParcoursUrl,
      'stations': stations?.map((e) => e.toJson()).toList(),
    };
  }
}

class DigifitInformationStationModel {
  final int? id;
  final String? name;
  final String? muscleGroups;
  final String? machineImageUrl;
   bool? isFavorite;
  final bool? isCompleted;

  DigifitInformationStationModel({
    this.id,
    this.name,
    this.muscleGroups,
    this.machineImageUrl,
    this.isFavorite,
    this.isCompleted,
  });

  DigifitInformationStationModel fromJson(Map<String, dynamic> json) {
    return DigifitInformationStationModel(
      id: json['id'],
      name: json['name'],
      muscleGroups: json['muscleGroups'],
      machineImageUrl: json['machineImageUrl'],
      isFavorite: json['isFavorite'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'muscleGroups': muscleGroups,
      'machineImageUrl': machineImageUrl,
      'isFavorite': isFavorite,
      'isCompleted': isCompleted,
    };
  }
}

class DigifitInformationActionsModel {
  final String? trophiesUrl;
  final String? puzzleUrl;

  DigifitInformationActionsModel({
    this.trophiesUrl,
    this.puzzleUrl,
  });

  DigifitInformationActionsModel fromJson(Map<String, dynamic> json) {
    return DigifitInformationActionsModel(
      trophiesUrl: json['trophiesUrl'],
      puzzleUrl: json['puzzleUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trophiesUrl': trophiesUrl,
      'puzzleUrl': puzzleUrl,
    };
  }
}
