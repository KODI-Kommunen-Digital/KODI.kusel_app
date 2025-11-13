import 'package:core/base_model.dart';

class MathHuntResponseModel extends BaseModel<MathHuntResponseModel> {
  final MathHuntDataModel? data;
  final String? status;

  MathHuntResponseModel({
    this.data,
    this.status,
  });

  @override
  MathHuntResponseModel fromJson(Map<String, dynamic> json) {
    return MathHuntResponseModel(
      data: json['data'] != null
          ? MathHuntDataModel().fromJson(json['data'])
          : null,
      status: json['status'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'status': status,
      };
}

class MathHuntDataModel extends BaseModel<MathHuntDataModel> {
  final List<String>? problem;
  final List<String>? options;
  final int? correctAnswer;
  final int? timer;
  final int? sessionId;
  final int? activityId;

  MathHuntDataModel({
    this.problem,
    this.options,
    this.correctAnswer,
    this.timer,
    this.sessionId,
    this.activityId,
  });

  @override
  MathHuntDataModel fromJson(Map<String, dynamic> json) {
    return MathHuntDataModel(
      problem:
          json['problem'] != null ? List<String>.from(json['problem']) : null,
      options:
          json['options'] != null ? List<String>.from(json['options']) : null,
      correctAnswer: json['correctAnswer'],
      timer: json['timer'],
      sessionId: json['sessionId'],
      activityId: json['activityId'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'problem': problem,
        'options': options,
        'correctAnswer': correctAnswer,
        'timer': timer,
        'sessionId': sessionId,
        'activityId': activityId,
      };
}
