import 'package:core/base_model.dart';

class DigifitBulkTrackingResponseModel
    extends BaseModel<DigifitBulkTrackingResponseModel> {
  final String status;
  final String message;

  DigifitBulkTrackingResponseModel({
    this.status = '',
    this.message = '',
  });

  @override
  DigifitBulkTrackingResponseModel fromJson(Map<String, dynamic> json) {
    return DigifitBulkTrackingResponseModel(
      status: json['status']?.toString() ?? '',
      message: json['data']?['message']?.toString() ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': {
        'message': message,
      },
    };
  }
}
