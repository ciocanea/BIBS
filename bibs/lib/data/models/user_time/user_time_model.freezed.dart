// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_time_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserTime {

@JsonKey(name: 'id') String get userId; String get campus; String get username;@JsonKey(name: 'total_time') int get totalTime;@JsonKey(name: 'image_path') String? get imagePath;
/// Create a copy of UserTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserTimeCopyWith<UserTime> get copyWith => _$UserTimeCopyWithImpl<UserTime>(this as UserTime, _$identity);

  /// Serializes this UserTime to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserTime&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.username, username) || other.username == username)&&(identical(other.totalTime, totalTime) || other.totalTime == totalTime)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,campus,username,totalTime,imagePath);

@override
String toString() {
  return 'UserTime(userId: $userId, campus: $campus, username: $username, totalTime: $totalTime, imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class $UserTimeCopyWith<$Res>  {
  factory $UserTimeCopyWith(UserTime value, $Res Function(UserTime) _then) = _$UserTimeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String userId, String campus, String username,@JsonKey(name: 'total_time') int totalTime,@JsonKey(name: 'image_path') String? imagePath
});




}
/// @nodoc
class _$UserTimeCopyWithImpl<$Res>
    implements $UserTimeCopyWith<$Res> {
  _$UserTimeCopyWithImpl(this._self, this._then);

  final UserTime _self;
  final $Res Function(UserTime) _then;

/// Create a copy of UserTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? campus = null,Object? username = null,Object? totalTime = null,Object? imagePath = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,totalTime: null == totalTime ? _self.totalTime : totalTime // ignore: cast_nullable_to_non_nullable
as int,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UserTime implements UserTime {
  const _UserTime({@JsonKey(name: 'id') required this.userId, required this.campus, required this.username, @JsonKey(name: 'total_time') required this.totalTime, @JsonKey(name: 'image_path') this.imagePath});
  factory _UserTime.fromJson(Map<String, dynamic> json) => _$UserTimeFromJson(json);

@override@JsonKey(name: 'id') final  String userId;
@override final  String campus;
@override final  String username;
@override@JsonKey(name: 'total_time') final  int totalTime;
@override@JsonKey(name: 'image_path') final  String? imagePath;

/// Create a copy of UserTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserTimeCopyWith<_UserTime> get copyWith => __$UserTimeCopyWithImpl<_UserTime>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserTimeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserTime&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.username, username) || other.username == username)&&(identical(other.totalTime, totalTime) || other.totalTime == totalTime)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,campus,username,totalTime,imagePath);

@override
String toString() {
  return 'UserTime(userId: $userId, campus: $campus, username: $username, totalTime: $totalTime, imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class _$UserTimeCopyWith<$Res> implements $UserTimeCopyWith<$Res> {
  factory _$UserTimeCopyWith(_UserTime value, $Res Function(_UserTime) _then) = __$UserTimeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String userId, String campus, String username,@JsonKey(name: 'total_time') int totalTime,@JsonKey(name: 'image_path') String? imagePath
});




}
/// @nodoc
class __$UserTimeCopyWithImpl<$Res>
    implements _$UserTimeCopyWith<$Res> {
  __$UserTimeCopyWithImpl(this._self, this._then);

  final _UserTime _self;
  final $Res Function(_UserTime) _then;

/// Create a copy of UserTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? campus = null,Object? username = null,Object? totalTime = null,Object? imagePath = freezed,}) {
  return _then(_UserTime(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,totalTime: null == totalTime ? _self.totalTime : totalTime // ignore: cast_nullable_to_non_nullable
as int,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
