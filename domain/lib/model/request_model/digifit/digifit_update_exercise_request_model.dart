import 'package:core/base_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'digifit_update_exercise_request_model.g.dart';

@HiveType(typeId: 8)
class DigifitUpdateExerciseRequestModel
    extends BaseModel<DigifitUpdateExerciseRequestModel> {
  @HiveField(0)
  final String exerciseId;
  @HiveField(1)
  final List<DigifitExerciseRecordModel> records;

  DigifitUpdateExerciseRequestModel({
    this.exerciseId = '',
    List<DigifitExerciseRecordModel>? records,
  }) : records = records ?? [];

  @override
  DigifitUpdateExerciseRequestModel fromJson(Map<String, dynamic> json) {
    final key = json.keys.first;
    final value = json[key] as List;

    return DigifitUpdateExerciseRequestModel(
      exerciseId: key,
      records: value
          .map((e) => DigifitExerciseRecordModel().fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      exerciseId: records.map((e) => e.toJson()).toList(),
    };
  }
}


@HiveType(typeId: 9)
class DigifitExerciseRecordModel
    extends BaseModel<DigifitExerciseRecordModel> {
  @HiveField(0)
  final int setComplete;
  @HiveField(1)
  final int locationId;
  @HiveField(2)
  final String createdAt;
  @HiveField(3)
  final String updatedAt;
  @HiveField(4)
  final List<String> setTimeList;

  DigifitExerciseRecordModel({
    this.setComplete = 0,
    this.locationId = 0,
    this.createdAt = '',
    this.updatedAt = '',
    List<String>? setTimeList,
  }) : setTimeList = setTimeList ?? [];

  @override
  DigifitExerciseRecordModel fromJson(Map<String, dynamic> json) {
    return DigifitExerciseRecordModel(
      setComplete: json['setComplete'] ?? 0,
      locationId: json['locationId'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      setTimeList: (json['setTimeList'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'setComplete': setComplete,
      'locationId': locationId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'setTimeList': setTimeList,
    };
  }
}