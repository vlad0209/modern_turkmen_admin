// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercises_list_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExercisesListUiState {
  List<Exercise>? get exercises;
  String get tutorialName;

  /// Create a copy of ExercisesListUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExercisesListUiStateCopyWith<ExercisesListUiState> get copyWith =>
      _$ExercisesListUiStateCopyWithImpl<ExercisesListUiState>(
          this as ExercisesListUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExercisesListUiState &&
            const DeepCollectionEquality().equals(other.exercises, exercises) &&
            (identical(other.tutorialName, tutorialName) ||
                other.tutorialName == tutorialName));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(exercises), tutorialName);

  @override
  String toString() {
    return 'ExercisesListUiState(exercises: $exercises, tutorialName: $tutorialName)';
  }
}

/// @nodoc
abstract mixin class $ExercisesListUiStateCopyWith<$Res> {
  factory $ExercisesListUiStateCopyWith(ExercisesListUiState value,
          $Res Function(ExercisesListUiState) _then) =
      _$ExercisesListUiStateCopyWithImpl;
  @useResult
  $Res call({List<Exercise>? exercises, String tutorialName});
}

/// @nodoc
class _$ExercisesListUiStateCopyWithImpl<$Res>
    implements $ExercisesListUiStateCopyWith<$Res> {
  _$ExercisesListUiStateCopyWithImpl(this._self, this._then);

  final ExercisesListUiState _self;
  final $Res Function(ExercisesListUiState) _then;

  /// Create a copy of ExercisesListUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exercises = freezed,
    Object? tutorialName = null,
  }) {
    return _then(_self.copyWith(
      exercises: freezed == exercises
          ? _self.exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<Exercise>?,
      tutorialName: null == tutorialName
          ? _self.tutorialName
          : tutorialName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ExercisesListUiState].
extension ExercisesListUiStatePatterns on ExercisesListUiState {
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
    TResult Function(_ExercisesListUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExercisesListUiState() when $default != null:
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
    TResult Function(_ExercisesListUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExercisesListUiState():
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
    TResult? Function(_ExercisesListUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExercisesListUiState() when $default != null:
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
    TResult Function(List<Exercise>? exercises, String tutorialName)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExercisesListUiState() when $default != null:
        return $default(_that.exercises, _that.tutorialName);
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
    TResult Function(List<Exercise>? exercises, String tutorialName) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExercisesListUiState():
        return $default(_that.exercises, _that.tutorialName);
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
    TResult? Function(List<Exercise>? exercises, String tutorialName)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExercisesListUiState() when $default != null:
        return $default(_that.exercises, _that.tutorialName);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ExercisesListUiState implements ExercisesListUiState {
  const _ExercisesListUiState(
      {required final List<Exercise>? exercises, required this.tutorialName})
      : _exercises = exercises;

  final List<Exercise>? _exercises;
  @override
  List<Exercise>? get exercises {
    final value = _exercises;
    if (value == null) return null;
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String tutorialName;

  /// Create a copy of ExercisesListUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExercisesListUiStateCopyWith<_ExercisesListUiState> get copyWith =>
      __$ExercisesListUiStateCopyWithImpl<_ExercisesListUiState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExercisesListUiState &&
            const DeepCollectionEquality()
                .equals(other._exercises, _exercises) &&
            (identical(other.tutorialName, tutorialName) ||
                other.tutorialName == tutorialName));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_exercises), tutorialName);

  @override
  String toString() {
    return 'ExercisesListUiState(exercises: $exercises, tutorialName: $tutorialName)';
  }
}

/// @nodoc
abstract mixin class _$ExercisesListUiStateCopyWith<$Res>
    implements $ExercisesListUiStateCopyWith<$Res> {
  factory _$ExercisesListUiStateCopyWith(_ExercisesListUiState value,
          $Res Function(_ExercisesListUiState) _then) =
      __$ExercisesListUiStateCopyWithImpl;
  @override
  @useResult
  $Res call({List<Exercise>? exercises, String tutorialName});
}

/// @nodoc
class __$ExercisesListUiStateCopyWithImpl<$Res>
    implements _$ExercisesListUiStateCopyWith<$Res> {
  __$ExercisesListUiStateCopyWithImpl(this._self, this._then);

  final _ExercisesListUiState _self;
  final $Res Function(_ExercisesListUiState) _then;

  /// Create a copy of ExercisesListUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? exercises = freezed,
    Object? tutorialName = null,
  }) {
    return _then(_ExercisesListUiState(
      exercises: freezed == exercises
          ? _self._exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<Exercise>?,
      tutorialName: null == tutorialName
          ? _self.tutorialName
          : tutorialName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
