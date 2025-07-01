import 'package:core/base_model.dart';

class DigifitOverviewRequestModel
    extends BaseModel<DigifitOverviewRequestModel> {
  final String location;

  DigifitOverviewRequestModel({required this.location});

  @override
  DigifitOverviewRequestModel fromJson(Map<String, dynamic> json) {
    return DigifitOverviewRequestModel(location: json['location'] ?? '');
  }

  @override
  Map<String, dynamic> toJson() {
    return {'location': location};
  }
}
