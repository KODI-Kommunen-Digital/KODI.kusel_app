import 'package:core/base_model.dart';

class DigifitOverviewRequestModel
    extends BaseModel<DigifitOverviewRequestModel> {
  final int locationId;

  DigifitOverviewRequestModel({required this.locationId});

  @override
  DigifitOverviewRequestModel fromJson(Map<String, dynamic> json) {
    return DigifitOverviewRequestModel(locationId: json['locationId'] ?? '');
  }

  @override
  Map<String, dynamic> toJson() {
    return {'locationId': locationId};
  }
}
