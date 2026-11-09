// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt:
          const FirestoreTimestampConverter().fromJson(json['createdAt']),
    );

const _$CategoryFieldMap = <String, String>{
  'id': 'id',
  'title': 'title',
  'description': 'description',
  'createdAt': 'createdAt',
};

// ignore: unused_element
abstract class _$CategoryPerFieldToJson {
  // ignore: unused_element
  static Object? id(String instance) => instance;
  // ignore: unused_element
  static Object? title(String instance) => instance;
  // ignore: unused_element
  static Object? description(String instance) => instance;
  // ignore: unused_element
  static Object? createdAt(DateTime instance) =>
      const FirestoreTimestampConverter().toJson(instance);
}

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'createdAt':
          const FirestoreTimestampConverter().toJson(instance.createdAt),
    };
