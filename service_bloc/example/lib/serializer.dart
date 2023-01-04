import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:example/modal.dart';

part 'serializer.g.dart';

/// Example of how to use built_value serialization.
///
/// Declare a top level [Serializers] field called serializers. Annotate it
/// with [SerializersFor] and provide a `const` `List` of types you want to
/// be serializable.
///
/// The built_value code generator will provide the implementation. It will
/// contain serializers for all the types asked for explicitly plus all the
/// types needed transitively via fields.
///
/// You usually only need to do this once per project.
@SerializersFor([
  GithubOrganizationDetail,
])
Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

T? deserialize<T>(dynamic value) {
  final type = FullType(T);
  return serializers.deserialize(value, specifiedType: type)! as T;
}

BuiltList<T> deserializeListOf<T>(dynamic value) {
  final type = FullType(BuiltList, [FullType(T)]);
  if (!serializers.hasBuilder(type)) {
    serializers = (serializers.toBuilder()
          ..addBuilderFactory(type, () => ListBuilder<T>()))
        .build();
  }

  return serializers.deserialize(value, specifiedType: type) as BuiltList<T>;
}

dynamic serialize<T>(dynamic value) {
  final type = FullType(T);
  return serializers.serialize(value, specifiedType: type);
}

dynamic serializeListOf<T>(Iterable<T> value) {
  final type = FullType(BuiltList, [FullType(T)]);
  if (!serializers.hasBuilder(type)) {
    serializers = (serializers.toBuilder()
          ..addBuilderFactory(type, () => ListBuilder<T>()))
        .build();
  }

  return serializers.serialize(BuiltList<T>.from(value), specifiedType: type);
}
