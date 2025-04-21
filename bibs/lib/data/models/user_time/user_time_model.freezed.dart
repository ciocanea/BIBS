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

 String get id; String get campus; String get username; int get time;
/// Create a copy of UserTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserTimeCopyWith<UserTime> get copyWith => _$UserTimeCopyWithImpl<UserTime>(this as UserTime, _$identity);

  /// Serializes this UserTime to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserTime&&(identical(other.id, id) || other.id == id)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.username, username) || other.username == username)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,campus,username,time);

@override
String toString() {
  return 'UserTime(id: $id, campus: $campus, username: $username, time: $time)';
}


}

/// @nodoc
abstract mixin class $UserTimeCopyWith<$Res>  {
  factory $UserTimeCopyWith(UserTime value, $Res Function(UserTime) _then) = _$UserTimeCopyWithImpl;
@useResult
$Res call({
 String id, String campus, String username, int time
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? campus = null,Object? username = null,Object? time = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UserTime implements UserTime {
  const _UserTime({required this.id, required this.campus, required this.username, required this.time});
  factory _UserTime.fromJson(Map<String, dynamic> json) => _$UserTimeFromJson(json);

@override final  String id;
@override final  String campus;
@override final  String username;
@override final  int time;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserTime&&(identical(other.id, id) || other.id == id)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.username, username) || other.username == username)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,campus,username,time);

@override
String toString() {
  return 'UserTime(id: $id, campus: $campus, username: $username, time: $time)';
}


}

/// @nodoc
abstract mixin class _$UserTimeCopyWith<$Res> implements $UserTimeCopyWith<$Res> {
  factory _$UserTimeCopyWith(_UserTime value, $Res Function(_UserTime) _then) = __$UserTimeCopyWithImpl;
@override @useResult
$Res call({
 String id, String campus, String username, int time
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? campus = null,Object? username = null,Object? time = null,}) {
  return _then(_UserTime(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
