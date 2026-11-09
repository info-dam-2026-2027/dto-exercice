// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      createdAt:
          const FirestoreTimestampConverter().fromJson(json['createdAt']),
    );

const _$ProductFieldMap = <String, String>{
  'id': 'id',
  'name': 'name',
  'description': 'description',
  'price': 'price',
  'createdAt': 'createdAt',
};

// ignore: unused_element
abstract class _$ProductPerFieldToJson {
  // ignore: unused_element
  static Object? id(String instance) => instance;
  // ignore: unused_element
  static Object? name(String instance) => instance;
  // ignore: unused_element
  static Object? description(String instance) => instance;
  // ignore: unused_element
  static Object? price(String instance) => instance;
  // ignore: unused_element
  static Object? createdAt(DateTime instance) =>
      const FirestoreTimestampConverter().toJson(instance);
}

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'createdAt':
          const FirestoreTimestampConverter().toJson(instance.createdAt),
    };
