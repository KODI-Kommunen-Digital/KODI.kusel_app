import 'package:core/base_model.dart';

class DigifitOverviewResponseModel
    extends BaseModel<DigifitOverviewResponseModel> {
  DigifitOverviewDataModel? data;
  String? status;

  DigifitOverviewResponseModel({this.data, this.status});

  @override
  DigifitOverviewResponseModel fromJson(Map<String, dynamic> json) {
    return DigifitOverviewResponseModel(
      status: json['status'],
      data: json['data'] != null
          ? DigifitOverviewDataModel().fromJson(json['data'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.toJson(),
      };
}

class DigifitOverviewDataModel extends BaseModel<DigifitOverviewDataModel> {
  DigifitOverviewUserStatsModel? userStats;
  DigifitOverviewParcoursModel? parcours;
  DigifitOverviewActionsModel? actions;

  DigifitOverviewDataModel({this.userStats, this.parcours, this.actions});

  @override
  DigifitOverviewDataModel fromJson(Map<String, dynamic> json) {
    return DigifitOverviewDataModel(
      userStats: json['userStats'] != null
          ? DigifitOverviewUserStatsModel().fromJson(json['userStats'])
          : null,
      parcours: json['parcours'] != null
          ? DigifitOverviewParcoursModel().fromJson(json['parcours'])
          : null,
      actions: json['actions'] != null
          ? DigifitOverviewActionsModel().fromJson(json['actions'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'userStats': userStats?.toJson(),
        'parcours': parcours?.toJson(),
        'actions': actions?.toJson(),
      };
}

class DigifitOverviewUserStatsModel
    extends BaseModel<DigifitOverviewUserStatsModel> {
  int? points;
  int? trophies;

  DigifitOverviewUserStatsModel({this.points, this.trophies});

  @override
  DigifitOverviewUserStatsModel fromJson(Map<String, dynamic> json) {
    return DigifitOverviewUserStatsModel(
      points: json['points'],
      trophies: json['trophies'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'points': points,
        'trophies': trophies,
      };
}

class DigifitOverviewParcoursModel
    extends BaseModel<DigifitOverviewParcoursModel> {
  String? name;
  List<DigifitOverviewStationModel>? offeneUebungen;
  List<DigifitOverviewStationModel>? abgeschlossen;

  DigifitOverviewParcoursModel(
      {this.name, this.offeneUebungen, this.abgeschlossen});

  @override
  DigifitOverviewParcoursModel fromJson(Map<String, dynamic> json) {
    List<DigifitOverviewStationModel> offeneList = [];
    List<DigifitOverviewStationModel> abgeschlossenList = [];

    if (json['Offene Übungen'] != null) {
      for (var item in json['Offene Übungen']) {
        offeneList.add(DigifitOverviewStationModel().fromJson(item));
      }
    }

    if (json['Abgeschlossen'] != null) {
      for (var item in json['Abgeschlossen']) {
        abgeschlossenList.add(DigifitOverviewStationModel().fromJson(item));
      }
    }

    return DigifitOverviewParcoursModel(
      name: json['name'],
      offeneUebungen: offeneList,
      abgeschlossen: abgeschlossenList,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'Offene Übungen': offeneUebungen?.map((e) => e.toJson()).toList(),
        'Abgeschlossen': abgeschlossen?.map((e) => e.toJson()).toList(),
      };
}

class DigifitOverviewStationModel
    extends BaseModel<DigifitOverviewStationModel> {
  int? id;
  String? name;
  String? muscleGroups;
  String? machineImageUrl;
  bool? isFavorite;
  bool? isCompleted;

  DigifitOverviewStationModel({
    this.id,
    this.name,
    this.muscleGroups,
    this.machineImageUrl,
    this.isFavorite,
    this.isCompleted,
  });

  @override
  DigifitOverviewStationModel fromJson(Map<String, dynamic> json) {
    return DigifitOverviewStationModel(
      id: json['id'],
      name: json['name'],
      muscleGroups: json['muscleGroups'],
      machineImageUrl: json['machineImageUrl'],
      isFavorite: json['isFavorite'],
      isCompleted: json['isCompleted'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'muscleGroups': muscleGroups,
        'machineImageUrl': machineImageUrl,
        'isFavorite': isFavorite,
        'isCompleted': isCompleted,
      };
}

class DigifitOverviewActionsModel
    extends BaseModel<DigifitOverviewActionsModel> {
  String? trophiesUrl;
  String? puzzleUrl;

  DigifitOverviewActionsModel({this.trophiesUrl, this.puzzleUrl});

  @override
  DigifitOverviewActionsModel fromJson(Map<String, dynamic> json) {
    return DigifitOverviewActionsModel(
      trophiesUrl: json['trophiesUrl'],
      puzzleUrl: json['puzzleUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'trophiesUrl': trophiesUrl,
        'puzzleUrl': puzzleUrl,
      };
}
