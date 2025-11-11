import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/exercise/exercise.dart';

part 'exercises_list_ui_state.freezed.dart';

@freezed
abstract class ExercisesListUiState with _$ExercisesListUiState {
  const factory ExercisesListUiState({
    required List<Exercise>? exercises,
    required String tutorialName,
  }) = _ExercisesListUiState;
}