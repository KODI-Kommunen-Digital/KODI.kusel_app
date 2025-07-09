import 'package:core/base_model.dart';

class DigifitUserTrophiesResponseModel extends BaseModel<DigifitUserTrophiesResponseModel> {
  final DigifitUserTrophyDataModel? data;
  final String? status;

  DigifitUserTrophiesResponseModel({
    this.data,
    this.status,
  });

  @override
  DigifitUserTrophiesResponseModel fromJson(Map<String, dynamic> json) {
    return DigifitUserTrophiesResponseModel(
      data: DigifitUserTrophyDataModel().fromJson(json['data']),
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

class DigifitUserTrophyDataModel extends BaseModel<DigifitUserTrophyDataModel> {
  final int? sourceId;
  final DigifitUserTrophyStatsModel? userStats;
  final List<DigifitUserTrophyItemModel>? latestTrophies;
  final DigifitUserTrophyAllModel? allTrophies;
  final DigifitUserTrophyUnlockedModel? unlockedTrophies;
  final DigifitUserTrophyActionsModel? actions;

  DigifitUserTrophyDataModel({
    this.sourceId,
    this.userStats,
    this.latestTrophies,
    this.allTrophies,
    this.unlockedTrophies,
    this.actions,
  });

  @override
  DigifitUserTrophyDataModel fromJson(Map<String, dynamic> json) {
    return DigifitUserTrophyDataModel(
      sourceId: json['sourceId'],
      userStats: DigifitUserTrophyStatsModel().fromJson(json['userStats']),
      latestTrophies: json['latestTrophies'] != null
          ? List<Map<String, dynamic>>.from(json['latestTrophies'])
              .map((e) => DigifitUserTrophyItemModel().fromJson(e))
              .toList()
          : null,
      allTrophies: DigifitUserTrophyAllModel().fromJson(json['allTrophies']),
      unlockedTrophies:
          DigifitUserTrophyUnlockedModel().fromJson(json['unlockedTrophies']),
      actions: DigifitUserTrophyActionsModel().fromJson(json['actions']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'sourceId': sourceId,
      'userStats': userStats?.toJson(),
      'latestTrophies': latestTrophies?.map((e) => e.toJson()).toList(),
      'allTrophies': allTrophies?.toJson(),
      'unlockedTrophies': unlockedTrophies?.toJson(),
      'actions': actions?.toJson(),
    };
  }
}

class DigifitUserTrophyStatsModel
    extends BaseModel<DigifitUserTrophyStatsModel> {
  final int? points;
  final int? trophies;

  DigifitUserTrophyStatsModel({
    this.points,
    this.trophies,
  });

  @override
  DigifitUserTrophyStatsModel fromJson(Map<String, dynamic> json) {
    return DigifitUserTrophyStatsModel(
      points: json['points'],
      trophies: json['trophies'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'trophies': trophies,
    };
  }
}

class DigifitUserTrophyItemModel extends BaseModel<DigifitUserTrophyItemModel> {
  final int? id;
  final String? name;
  final String? iconUrl;
  final bool? isUnlocked;

  DigifitUserTrophyItemModel({
    this.id,
    this.name,
    this.iconUrl,
    this.isUnlocked,
  });

  @override
  DigifitUserTrophyItemModel fromJson(Map<String, dynamic> json) {
    return DigifitUserTrophyItemModel(
      id: json['id'],
      name: json['name'],
      iconUrl: json['iconUrl'],
      isUnlocked: json['isUnlocked'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconUrl': iconUrl,
      'isUnlocked': isUnlocked,
    };
  }
}

class DigifitUserTrophyAllModel extends BaseModel<DigifitUserTrophyAllModel> {
  final int? total;
  final int? unlocked;
  final List<DigifitUserTrophyItemModel>? trophies;

  DigifitUserTrophyAllModel({
    this.total,
    this.unlocked,
    this.trophies,
  });

  @override
  DigifitUserTrophyAllModel fromJson(Map<String, dynamic> json) {
    return DigifitUserTrophyAllModel(
      total: json['total'],
      unlocked: json['unlocked'],
      trophies: json['trophies'] != null
          ? List<Map<String, dynamic>>.from(json['trophies'])
              .map((e) => DigifitUserTrophyItemModel().fromJson(e))
              .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'unlocked': unlocked,
      'trophies': trophies?.map((e) => e.toJson()).toList(),
    };
  }
}

class DigifitUserTrophyUnlockedModel
    extends BaseModel<DigifitUserTrophyUnlockedModel> {
  final int? count;
  final int? total;
  final List<DigifitUserTrophyItemModel>? trophies;

  DigifitUserTrophyUnlockedModel({
    this.count,
    this.total,
    this.trophies,
  });

  @override
  DigifitUserTrophyUnlockedModel fromJson(Map<String, dynamic> json) {
    return DigifitUserTrophyUnlockedModel(
      count: json['count'],
      total: json['total'],
      trophies: json['trophies'] != null
          ? List<Map<String, dynamic>>.from(json['trophies'])
              .map((e) => DigifitUserTrophyItemModel().fromJson(e))
              .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'total': total,
      'trophies': trophies?.map((e) => e.toJson()).toList(),
    };
  }
}

class DigifitUserTrophyActionsModel
    extends BaseModel<DigifitUserTrophyActionsModel> {
  final String? scanWorkoutUrl;
  final String? loadMoreTrophiesUrl;

  DigifitUserTrophyActionsModel({
    this.scanWorkoutUrl,
    this.loadMoreTrophiesUrl,
  });

  @override
  DigifitUserTrophyActionsModel fromJson(Map<String, dynamic> json) {
    return DigifitUserTrophyActionsModel(
      scanWorkoutUrl: json['scanWorkoutUrl'],
      loadMoreTrophiesUrl: json['loadMoreTrophiesUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'scanWorkoutUrl': scanWorkoutUrl,
      'loadMoreTrophiesUrl': loadMoreTrophiesUrl,
    };
  }
}
