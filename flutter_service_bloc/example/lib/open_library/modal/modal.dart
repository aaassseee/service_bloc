import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:example/serializer.dart';

part 'modal.g.dart';

mixin OpenLibrarySearchBaseResponse<T> {
  int get numFound;

  int get start;

  bool get numFoundExact;

  @BuiltValueField(wireName: 'docs')
  T get result;
}

abstract class OpenLibrarySearchResponse<T>
    with
        OpenLibrarySearchBaseResponse<BuiltList<T>>
    implements
        Built<OpenLibrarySearchResponse<T>,
            OpenLibrarySearchResponseBuilder<T>> {
  OpenLibrarySearchResponse._();

  factory OpenLibrarySearchResponse(
          [void Function(OpenLibrarySearchResponseBuilder<T>) updates]) =
      _$OpenLibrarySearchResponse<T>;

  static Serializer<OpenLibrarySearchResponse> get serializer =>
      _$openLibrarySearchResponseSerializer;

  Map<String, dynamic> toJson() {
    Serializers genericSerializers = (serializers.toBuilder()
          ..addBuilderFactory(
              FullType(OpenLibrarySearchBaseResponse, [FullType(T)]),
              () => OpenLibrarySearchResponseBuilder<T>())
          ..addBuilderFactory(
              FullType(BuiltList, [FullType(T)]), () => ListBuilder<T>()))
        .build();
    return genericSerializers.serializeWith(
        OpenLibrarySearchResponse.serializer, this) as Map<String, dynamic>;
  }

  static OpenLibrarySearchResponse<T> fromJson<T>(Map<String, dynamic> json) {
    final Serializers genericSerializers = (serializers.toBuilder()
          ..addBuilderFactory(
              FullType(OpenLibrarySearchResponse, [FullType(T)]),
              () => OpenLibrarySearchResponseBuilder<T>())
          ..addBuilderFactory(
              FullType(BuiltList, [FullType(T)]), () => ListBuilder<T>()))
        .build();
    return genericSerializers.deserialize(json,
            specifiedType: FullType(OpenLibrarySearchResponse, [FullType(T)]))
        as OpenLibrarySearchResponse<T>;
  }
}

abstract class OpenLibraryAuthorSearchResult
    implements
        Built<OpenLibraryAuthorSearchResult,
            OpenLibraryAuthorSearchResultBuilder> {
  OpenLibraryAuthorSearchResult._();

  String get key;

  String get type;

  String get name;

  @BuiltValueField(wireName: 'alternate_names')
  BuiltList<String> get alternateNameList;

  @BuiltValueField(wireName: 'birth_date')
  String? get birthDate;

  @BuiltValueField(wireName: 'top_work')
  String get topWork;

  @BuiltValueField(wireName: 'work_count')
  int get workCount;

  @BuiltValueField(wireName: 'top_subjects')
  BuiltList<String> get topSubjectList;

  factory OpenLibraryAuthorSearchResult(
          [void Function(OpenLibraryAuthorSearchResultBuilder) updates]) =
      _$OpenLibraryAuthorSearchResult;

  static Serializer<OpenLibraryAuthorSearchResult> get serializer =>
      _$openLibraryAuthorSearchResultSerializer;

  Map<String, dynamic> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>;

  static OpenLibraryAuthorSearchResult fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith(serializer, json)!;
}

abstract class OpenLibraryAuthorDetail
    implements Built<OpenLibraryAuthorDetail, OpenLibraryAuthorDetailBuilder> {
  OpenLibraryAuthorDetail._();

  String? get wikipedia;

  @BuiltValueField(wireName: 'personal_name')
  String? get personalName;

  String get key;

  @BuiltValueField(wireName: 'alternate_names')
  BuiltList<String> get alternateNameList;

  String get name;

  String? get title;

  @BuiltValueField(wireName: 'birth_date')
  String? get birthDate;

  @BuiltValueField(wireName: 'photos')
  BuiltList<int> get photoIdList;

  factory OpenLibraryAuthorDetail(
          [void Function(OpenLibraryAuthorDetailBuilder) updates]) =
      _$OpenLibraryAuthorDetail;

  static Serializer<OpenLibraryAuthorDetail> get serializer =>
      _$openLibraryAuthorDetailSerializer;

  Map<String, dynamic> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>;

  static OpenLibraryAuthorDetail fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith(serializer, json)!;
}
