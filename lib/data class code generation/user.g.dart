// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  isActive: json['isActive'] as bool? ?? false,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'isActive': instance.isActive,
};
