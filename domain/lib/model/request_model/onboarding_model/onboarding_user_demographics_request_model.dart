import 'package:core/base_model.dart';

class OnboardingUserDemographicsRequestModel
    extends BaseModel<OnboardingUserDemographicsRequestModel> {
  final String? maritalStatus;
  final String? accommodationPreference;
  final int? cityId;

  OnboardingUserDemographicsRequestModel(
      {this.maritalStatus, this.accommodationPreference, this.cityId});

  @override
  OnboardingUserDemographicsRequestModel fromJson(Map<String, dynamic> json) {
    return OnboardingUserDemographicsRequestModel(
      maritalStatus: json['maritalStatus'] ?? '',
      accommodationPreference: json['accommodationPreference'] ?? '',
      cityId: json['cityId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "maritalStatus": maritalStatus,
      "accommodationPreference": accommodationPreference,
      "cityId": cityId
    };
  }
}
