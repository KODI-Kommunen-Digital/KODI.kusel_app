import 'package:domain/model/response_model/digifit/digifit_exercise_details_response_model.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/enum/digifit_exercise_timer_state.dart';

class DigifitExerciseDetailsState {
  bool isLoading;
  final String errorMessage;
  final List<DigifitExerciseRelatedStationsModel>
      digifitExerciseRelatedEquipmentsModel;
  final DigifitExerciseEquipmentModel? digifitExerciseEquipmentModel;
  final bool isReadyToSubmitSet;
  final int currentSetNumber;
  final int totalSetNumber;
  final bool isScannerVisible;
  final int locationId;
  final int remainingPauseSecond;
  final TimerState timerState;
  final int time;
  final bool isNetworkAvailable;

  DigifitExerciseDetailsState(
      {required this.isLoading,
      this.errorMessage = '',
      this.digifitExerciseRelatedEquipmentsModel = const [],
      this.digifitExerciseEquipmentModel,
      required this.isReadyToSubmitSet,
      required this.remainingPauseSecond,
      required this.currentSetNumber,
      required this.totalSetNumber,
      required this.isScannerVisible,
      required this.locationId,
      required this.timerState,
      required this.time,
      required this.isNetworkAvailable});

  factory DigifitExerciseDetailsState.empty() {
    return DigifitExerciseDetailsState(
        isLoading: false,
        errorMessage: '',
        digifitExerciseRelatedEquipmentsModel: [],
        digifitExerciseEquipmentModel: null,
        isReadyToSubmitSet: false,
        currentSetNumber: 0,
        totalSetNumber: 0,
        remainingPauseSecond: 0,
        isScannerVisible: true,
        locationId: 0,
        timerState: TimerState.start,
        time: 3,
        isNetworkAvailable: true);
  }

  DigifitExerciseDetailsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<DigifitExerciseRelatedStationsModel>?
        digifitExerciseRelatedEquipmentsModel,
    DigifitExerciseEquipmentModel? digifitExerciseEquipmentModel,
    bool? isReadyToSubmitSet,
    int? currentSetNumber,
    int? totalSetNumber,
    bool? isScannerVisible,
    int? remainingPauseSecond,
    int? locationId,
    TimerState? timerState,
    int? time,
    bool? isNetworkAvailable,
  }) {
    return DigifitExerciseDetailsState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        digifitExerciseRelatedEquipmentsModel:
            digifitExerciseRelatedEquipmentsModel ??
                this.digifitExerciseRelatedEquipmentsModel,
        digifitExerciseEquipmentModel:
            digifitExerciseEquipmentModel ?? this.digifitExerciseEquipmentModel,
        isReadyToSubmitSet: isReadyToSubmitSet ?? this.isReadyToSubmitSet,
        currentSetNumber: currentSetNumber ?? this.currentSetNumber,
        totalSetNumber: totalSetNumber ?? this.totalSetNumber,
        isScannerVisible: isScannerVisible ?? this.isScannerVisible,
        remainingPauseSecond: remainingPauseSecond ?? this.remainingPauseSecond,
        locationId: locationId ?? this.locationId,
        timerState: timerState ?? this.timerState,
        time: time ?? this.time,
        isNetworkAvailable: isNetworkAvailable ?? this.isNetworkAvailable);
  }
}
