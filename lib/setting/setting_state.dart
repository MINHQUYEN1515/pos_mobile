part of 'setting_cubit.dart';

class SettingState extends Equatable {
  final LoadStatus loadDataStatus;

  const SettingState({
    this.loadDataStatus = LoadStatus.initial,
  });

  @override
  List<Object?> get props => [
        loadDataStatus,
      ];

  SettingState copyWith({
    LoadStatus? loadDataStatus,
  }) {
    return SettingState(
      loadDataStatus: loadDataStatus ?? this.loadDataStatus,
    );
  }
}
