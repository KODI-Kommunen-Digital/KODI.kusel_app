import 'package:core/base_model.dart';

class MunicipalPartyDetailRequestModel
    implements BaseModel<MunicipalPartyDetailRequestModel> {
  String municipalId;

  MunicipalPartyDetailRequestModel({required this.municipalId});

  @override
  MunicipalPartyDetailRequestModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"municipalId": municipalId};
  }
}
