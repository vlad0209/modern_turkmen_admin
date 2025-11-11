// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseUiState {
  Exercise? get exercise;
  String get tutorialName;

  /// Create a copy of ExerciseUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExerciseUiStateCopyWith<ExerciseUiState> get copyWith =>
      _$ExerciseUiStateCopyWithImpl<ExerciseUiState>(
          this as ExerciseUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExerciseUiState &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise) &&
            (identical(other.tutorialName, tutorialName) ||
                other.tutorialName == tutorialName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exercise, tutorialName);

  @override
  String toString() {
    return 'ExerciseUiState(exercise: $exercise, tutorialName: $tutorialName)';
  }
}

/// @nodoc
abstract mixin class $ExerciseUiStateCopyWith<$Res> {
  factory $ExerciseUiStateCopyWith(
          ExerciseUiState value, $Res Function(ExerciseUiState) _then) =
      _$ExerciseUiStateCopyWithImpl;
  @useResult
  $Res call({Exercise? exercise, String tutorialName});

  $ExerciseCopyWith<$Res>? get exercise;
}

/// @nodoc
class _$ExerciseUiStateCopyWithImpl<$Res>
    implements $ExerciseUiStateCopyWith<$Res> {
  _$ExerciseUiStateCopyWithImpl(this._self, this._then);

  final ExerciseUiState _self;
  final $Res Function(ExerciseUiState) _then;

  /// Create a copy of ExerciseUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exercise = freezed,
    Object? tutorialName = null,
  }) {
    return _then(_self.copyWith(
      exercise: freezed == exercise
          ? _self.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as Exercise?,
      tutorialName: null == tutorialName
          ? _self.tutorialName
          : tutorialName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of ExerciseUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExerciseCopyWith<$Res>? get exercise {
    if (_self.exercise == null) {
      return null;
    }

    return $ExerciseCopyWith<$Res>(_self.exercise!, (value) {
      return _then(_self.copyWith(exercise: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ExerciseUiState].
extension ExerciseUiStatePatterns on ExerciseUiState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ExerciseUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExerciseUiState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ExerciseUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExerciseUiState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ExerciseUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExerciseUiState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(Exercise? exercise, String tutorialName)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExerciseUiState() when $default != null:
        return $default(_that.exercise, _that.tutorialName);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(Exercise? exercise, String tutorialName) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExerciseUiState():
        return $default(_that.exercise, _that.tutorialName);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(Exercise? exercise, String tutorialName)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExerciseUiState() when $default != null:
        return $default(_that.exercise, _that.tutorialName);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ExerciseUiState implements ExerciseUiState {
  const _ExerciseUiState({required this.exercise, required this.tutorialName});

  @override
  final Exercise? exercise;
  @override
  final String tutorialName;

  /// Create a copy of ExerciseUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExerciseUiStateCopyWith<_ExerciseUiState> get copyWith =>
      __$ExerciseUiStateCopyWithImpl<_ExerciseUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExerciseUiState &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise) &&
            (identical(other.tutorialName, tutorialName) ||
                other.tutorialName == tutorialName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exercise, tutorialName);

  @override
  String toString() {
    return 'ExerciseUiState(exercise: $exercise, tutorialName: $tutorialName)';
  }
}

/// @nodoc
abstract mixin class _$ExerciseUiStateCopyWith<$Res>
    implements $ExerciseUiStateCopyWith<$Res> {
  factory _$ExerciseUiStateCopyWith(
          _ExerciseUiState value, $Res Function(_ExerciseUiState) _then) =
      __$ExerciseUiStateCopyWithImpl;
  @override
  @useResult
  $Res call({Exercise? exercise, String tutorialName});

  @override
  $ExerciseCopyWith<$Res>? get exercise;
}

/// @nodoc
class __$ExerciseUiStateCopyWithImpl<$Res>
    implements _$ExerciseUiStateCopyWith<$Res> {
  __$ExerciseUiStateCopyWithImpl(this._self, this._then);

  final _ExerciseUiState _self;
  final $Res Function(_ExerciseUiState) _then;

  /// Create a copy of ExerciseUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? exercise = freezed,
    Object? tutorialName = null,
  }) {
    return _then(_ExerciseUiState(
      exercise: freezed == exercise
          ? _self.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as Exercise?,
      tutorialName: null == tutorialName
          ? _self.tutorialName
          : tutorialName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of ExerciseUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExerciseCopyWith<$Res>? get exercise {
    if (_self.exercise == null) {
      return null;
    }

    return $ExerciseCopyWith<$Res>(_self.exercise!, (value) {
      return _then(_self.copyWith(exercise: value));
    });
  }
}

// dart format on
