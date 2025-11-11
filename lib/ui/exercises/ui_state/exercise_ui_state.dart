import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/exercise/exercise.dart';

part 'exercise_ui_state.freezed.dart';

@freezed
abstract class ExerciseUiState with _$ExerciseUiState {
  const factory ExerciseUiState({
    required Exercise? exercise,
    required String tutorialName,
  }) = _ExerciseUiState;
}