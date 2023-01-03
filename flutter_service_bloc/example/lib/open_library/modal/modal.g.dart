// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<OpenLibrarySearchResponse<Object?>>
    _$openLibrarySearchResponseSerializer =
    new _$OpenLibrarySearchResponseSerializer();
Serializer<OpenLibraryAuthorSearchResult>
    _$openLibraryAuthorSearchResultSerializer =
    new _$OpenLibraryAuthorSearchResultSerializer();
Serializer<OpenLibraryAuthorDetail> _$openLibraryAuthorDetailSerializer =
    new _$OpenLibraryAuthorDetailSerializer();

class _$OpenLibrarySearchResponseSerializer
    implements StructuredSerializer<OpenLibrarySearchResponse<Object?>> {
  @override
  final Iterable<Type> types = const [
    OpenLibrarySearchResponse,
    _$OpenLibrarySearchResponse
  ];
  @override
  final String wireName = 'OpenLibrarySearchResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, OpenLibrarySearchResponse<Object?> object,
      {FullType specifiedType = FullType.unspecified}) {
    final isUnderspecified =
        specifiedType.isUnspecified || specifiedType.parameters.isEmpty;
    if (!isUnderspecified) serializers.expectBuilder(specifiedType);
    final parameterT =
        isUnderspecified ? FullType.object : specifiedType.parameters[0];

    final result = <Object?>[
      'numFound',
      serializers.serialize(object.numFound,
          specifiedType: const FullType(int)),
      'start',
      serializers.serialize(object.start, specifiedType: const FullType(int)),
      'numFoundExact',
      serializers.serialize(object.numFoundExact,
          specifiedType: const FullType(bool)),
      'docs',
      serializers.serialize(object.result,
          specifiedType: new FullType(BuiltList, [parameterT])),
    ];

    return result;
  }

  @override
  OpenLibrarySearchResponse<Object?> deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final isUnderspecified =
        specifiedType.isUnspecified || specifiedType.parameters.isEmpty;
    if (!isUnderspecified) serializers.expectBuilder(specifiedType);
    final parameterT =
        isUnderspecified ? FullType.object : specifiedType.parameters[0];

    final result = isUnderspecified
        ? new OpenLibrarySearchResponseBuilder<Object?>()
        : serializers.newBuilder(specifiedType)
            as OpenLibrarySearchResponseBuilder<Object?>;

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'numFound':
          result.numFound = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'start':
          result.start = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'numFoundExact':
          result.numFoundExact = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'docs':
          result.result.replace(serializers.deserialize(value,
                  specifiedType: new FullType(BuiltList, [parameterT]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$OpenLibraryAuthorSearchResultSerializer
    implements StructuredSerializer<OpenLibraryAuthorSearchResult> {
  @override
  final Iterable<Type> types = const [
    OpenLibraryAuthorSearchResult,
    _$OpenLibraryAuthorSearchResult
  ];
  @override
  final String wireName = 'OpenLibraryAuthorSearchResult';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, OpenLibraryAuthorSearchResult object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'key',
      serializers.serialize(object.key, specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'alternate_names',
      serializers.serialize(object.alternateNameList,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'top_work',
      serializers.serialize(object.topWork,
          specifiedType: const FullType(String)),
      'work_count',
      serializers.serialize(object.workCount,
          specifiedType: const FullType(int)),
      'top_subjects',
      serializers.serialize(object.topSubjectList,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    Object? value;
    value = object.birthDate;
    if (value != null) {
      result
        ..add('birth_date')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  OpenLibraryAuthorSearchResult deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new OpenLibraryAuthorSearchResultBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'key':
          result.key = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'alternate_names':
          result.alternateNameList.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'birth_date':
          result.birthDate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'top_work':
          result.topWork = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'work_count':
          result.workCount = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'top_subjects':
          result.topSubjectList.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$OpenLibraryAuthorDetailSerializer
    implements StructuredSerializer<OpenLibraryAuthorDetail> {
  @override
  final Iterable<Type> types = const [
    OpenLibraryAuthorDetail,
    _$OpenLibraryAuthorDetail
  ];
  @override
  final String wireName = 'OpenLibraryAuthorDetail';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, OpenLibraryAuthorDetail object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'key',
      serializers.serialize(object.key, specifiedType: const FullType(String)),
      'alternate_names',
      serializers.serialize(object.alternateNameList,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'photos',
      serializers.serialize(object.photoIdList,
          specifiedType:
              const FullType(BuiltList, const [const FullType(int)])),
    ];
    Object? value;
    value = object.wikipedia;
    if (value != null) {
      result
        ..add('wikipedia')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.personalName;
    if (value != null) {
      result
        ..add('personal_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.title;
    if (value != null) {
      result
        ..add('title')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.birthDate;
    if (value != null) {
      result
        ..add('birth_date')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  OpenLibraryAuthorDetail deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new OpenLibraryAuthorDetailBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'wikipedia':
          result.wikipedia = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'personal_name':
          result.personalName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'key':
          result.key = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'alternate_names':
          result.alternateNameList.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'birth_date':
          result.birthDate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'photos':
          result.photoIdList.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$OpenLibrarySearchResponse<T> extends OpenLibrarySearchResponse<T> {
  @override
  final int numFound;
  @override
  final int start;
  @override
  final bool numFoundExact;
  @override
  final BuiltList<T> result;

  factory _$OpenLibrarySearchResponse(
          [void Function(OpenLibrarySearchResponseBuilder<T>)? updates]) =>
      (new OpenLibrarySearchResponseBuilder<T>()..update(updates))._build();

  _$OpenLibrarySearchResponse._(
      {required this.numFound,
      required this.start,
      required this.numFoundExact,
      required this.result})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        numFound, r'OpenLibrarySearchResponse', 'numFound');
    BuiltValueNullFieldError.checkNotNull(
        start, r'OpenLibrarySearchResponse', 'start');
    BuiltValueNullFieldError.checkNotNull(
        numFoundExact, r'OpenLibrarySearchResponse', 'numFoundExact');
    BuiltValueNullFieldError.checkNotNull(
        result, r'OpenLibrarySearchResponse', 'result');
    if (T == dynamic) {
      throw new BuiltValueMissingGenericsError(
          r'OpenLibrarySearchResponse', 'T');
    }
  }

  @override
  OpenLibrarySearchResponse<T> rebuild(
          void Function(OpenLibrarySearchResponseBuilder<T>) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OpenLibrarySearchResponseBuilder<T> toBuilder() =>
      new OpenLibrarySearchResponseBuilder<T>()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OpenLibrarySearchResponse &&
        numFound == other.numFound &&
        start == other.start &&
        numFoundExact == other.numFoundExact &&
        result == other.result;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, numFound.hashCode), start.hashCode),
            numFoundExact.hashCode),
        result.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OpenLibrarySearchResponse')
          ..add('numFound', numFound)
          ..add('start', start)
          ..add('numFoundExact', numFoundExact)
          ..add('result', result))
        .toString();
  }
}

class OpenLibrarySearchResponseBuilder<T>
    implements
        Builder<OpenLibrarySearchResponse<T>,
            OpenLibrarySearchResponseBuilder<T>> {
  _$OpenLibrarySearchResponse<T>? _$v;

  int? _numFound;
  int? get numFound => _$this._numFound;
  set numFound(int? numFound) => _$this._numFound = numFound;

  int? _start;
  int? get start => _$this._start;
  set start(int? start) => _$this._start = start;

  bool? _numFoundExact;
  bool? get numFoundExact => _$this._numFoundExact;
  set numFoundExact(bool? numFoundExact) =>
      _$this._numFoundExact = numFoundExact;

  ListBuilder<T>? _result;
  ListBuilder<T> get result => _$this._result ??= new ListBuilder<T>();
  set result(ListBuilder<T>? result) => _$this._result = result;

  OpenLibrarySearchResponseBuilder();

  OpenLibrarySearchResponseBuilder<T> get _$this {
    final $v = _$v;
    if ($v != null) {
      _numFound = $v.numFound;
      _start = $v.start;
      _numFoundExact = $v.numFoundExact;
      _result = $v.result.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OpenLibrarySearchResponse<T> other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OpenLibrarySearchResponse<T>;
  }

  @override
  void update(void Function(OpenLibrarySearchResponseBuilder<T>)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OpenLibrarySearchResponse<T> build() => _build();

  _$OpenLibrarySearchResponse<T> _build() {
    _$OpenLibrarySearchResponse<T> _$result;
    try {
      _$result = _$v ??
          new _$OpenLibrarySearchResponse<T>._(
              numFound: BuiltValueNullFieldError.checkNotNull(
                  numFound, r'OpenLibrarySearchResponse', 'numFound'),
              start: BuiltValueNullFieldError.checkNotNull(
                  start, r'OpenLibrarySearchResponse', 'start'),
              numFoundExact: BuiltValueNullFieldError.checkNotNull(
                  numFoundExact, r'OpenLibrarySearchResponse', 'numFoundExact'),
              result: result.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'result';
        result.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'OpenLibrarySearchResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$OpenLibraryAuthorSearchResult extends OpenLibraryAuthorSearchResult {
  @override
  final String key;
  @override
  final String type;
  @override
  final String name;
  @override
  final BuiltList<String> alternateNameList;
  @override
  final String? birthDate;
  @override
  final String topWork;
  @override
  final int workCount;
  @override
  final BuiltList<String> topSubjectList;

  factory _$OpenLibraryAuthorSearchResult(
          [void Function(OpenLibraryAuthorSearchResultBuilder)? updates]) =>
      (new OpenLibraryAuthorSearchResultBuilder()..update(updates))._build();

  _$OpenLibraryAuthorSearchResult._(
      {required this.key,
      required this.type,
      required this.name,
      required this.alternateNameList,
      this.birthDate,
      required this.topWork,
      required this.workCount,
      required this.topSubjectList})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        key, r'OpenLibraryAuthorSearchResult', 'key');
    BuiltValueNullFieldError.checkNotNull(
        type, r'OpenLibraryAuthorSearchResult', 'type');
    BuiltValueNullFieldError.checkNotNull(
        name, r'OpenLibraryAuthorSearchResult', 'name');
    BuiltValueNullFieldError.checkNotNull(alternateNameList,
        r'OpenLibraryAuthorSearchResult', 'alternateNameList');
    BuiltValueNullFieldError.checkNotNull(
        topWork, r'OpenLibraryAuthorSearchResult', 'topWork');
    BuiltValueNullFieldError.checkNotNull(
        workCount, r'OpenLibraryAuthorSearchResult', 'workCount');
    BuiltValueNullFieldError.checkNotNull(
        topSubjectList, r'OpenLibraryAuthorSearchResult', 'topSubjectList');
  }

  @override
  OpenLibraryAuthorSearchResult rebuild(
          void Function(OpenLibraryAuthorSearchResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OpenLibraryAuthorSearchResultBuilder toBuilder() =>
      new OpenLibraryAuthorSearchResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OpenLibraryAuthorSearchResult &&
        key == other.key &&
        type == other.type &&
        name == other.name &&
        alternateNameList == other.alternateNameList &&
        birthDate == other.birthDate &&
        topWork == other.topWork &&
        workCount == other.workCount &&
        topSubjectList == other.topSubjectList;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, key.hashCode), type.hashCode),
                            name.hashCode),
                        alternateNameList.hashCode),
                    birthDate.hashCode),
                topWork.hashCode),
            workCount.hashCode),
        topSubjectList.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OpenLibraryAuthorSearchResult')
          ..add('key', key)
          ..add('type', type)
          ..add('name', name)
          ..add('alternateNameList', alternateNameList)
          ..add('birthDate', birthDate)
          ..add('topWork', topWork)
          ..add('workCount', workCount)
          ..add('topSubjectList', topSubjectList))
        .toString();
  }
}

class OpenLibraryAuthorSearchResultBuilder
    implements
        Builder<OpenLibraryAuthorSearchResult,
            OpenLibraryAuthorSearchResultBuilder> {
  _$OpenLibraryAuthorSearchResult? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<String>? _alternateNameList;
  ListBuilder<String> get alternateNameList =>
      _$this._alternateNameList ??= new ListBuilder<String>();
  set alternateNameList(ListBuilder<String>? alternateNameList) =>
      _$this._alternateNameList = alternateNameList;

  String? _birthDate;
  String? get birthDate => _$this._birthDate;
  set birthDate(String? birthDate) => _$this._birthDate = birthDate;

  String? _topWork;
  String? get topWork => _$this._topWork;
  set topWork(String? topWork) => _$this._topWork = topWork;

  int? _workCount;
  int? get workCount => _$this._workCount;
  set workCount(int? workCount) => _$this._workCount = workCount;

  ListBuilder<String>? _topSubjectList;
  ListBuilder<String> get topSubjectList =>
      _$this._topSubjectList ??= new ListBuilder<String>();
  set topSubjectList(ListBuilder<String>? topSubjectList) =>
      _$this._topSubjectList = topSubjectList;

  OpenLibraryAuthorSearchResultBuilder();

  OpenLibraryAuthorSearchResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _type = $v.type;
      _name = $v.name;
      _alternateNameList = $v.alternateNameList.toBuilder();
      _birthDate = $v.birthDate;
      _topWork = $v.topWork;
      _workCount = $v.workCount;
      _topSubjectList = $v.topSubjectList.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OpenLibraryAuthorSearchResult other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OpenLibraryAuthorSearchResult;
  }

  @override
  void update(void Function(OpenLibraryAuthorSearchResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OpenLibraryAuthorSearchResult build() => _build();

  _$OpenLibraryAuthorSearchResult _build() {
    _$OpenLibraryAuthorSearchResult _$result;
    try {
      _$result = _$v ??
          new _$OpenLibraryAuthorSearchResult._(
              key: BuiltValueNullFieldError.checkNotNull(
                  key, r'OpenLibraryAuthorSearchResult', 'key'),
              type: BuiltValueNullFieldError.checkNotNull(
                  type, r'OpenLibraryAuthorSearchResult', 'type'),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'OpenLibraryAuthorSearchResult', 'name'),
              alternateNameList: alternateNameList.build(),
              birthDate: birthDate,
              topWork: BuiltValueNullFieldError.checkNotNull(
                  topWork, r'OpenLibraryAuthorSearchResult', 'topWork'),
              workCount: BuiltValueNullFieldError.checkNotNull(
                  workCount, r'OpenLibraryAuthorSearchResult', 'workCount'),
              topSubjectList: topSubjectList.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'alternateNameList';
        alternateNameList.build();

        _$failedField = 'topSubjectList';
        topSubjectList.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'OpenLibraryAuthorSearchResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$OpenLibraryAuthorDetail extends OpenLibraryAuthorDetail {
  @override
  final String? wikipedia;
  @override
  final String? personalName;
  @override
  final String key;
  @override
  final BuiltList<String> alternateNameList;
  @override
  final String name;
  @override
  final String? title;
  @override
  final String? birthDate;
  @override
  final BuiltList<int> photoIdList;

  factory _$OpenLibraryAuthorDetail(
          [void Function(OpenLibraryAuthorDetailBuilder)? updates]) =>
      (new OpenLibraryAuthorDetailBuilder()..update(updates))._build();

  _$OpenLibraryAuthorDetail._(
      {this.wikipedia,
      this.personalName,
      required this.key,
      required this.alternateNameList,
      required this.name,
      this.title,
      this.birthDate,
      required this.photoIdList})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        key, r'OpenLibraryAuthorDetail', 'key');
    BuiltValueNullFieldError.checkNotNull(
        alternateNameList, r'OpenLibraryAuthorDetail', 'alternateNameList');
    BuiltValueNullFieldError.checkNotNull(
        name, r'OpenLibraryAuthorDetail', 'name');
    BuiltValueNullFieldError.checkNotNull(
        photoIdList, r'OpenLibraryAuthorDetail', 'photoIdList');
  }

  @override
  OpenLibraryAuthorDetail rebuild(
          void Function(OpenLibraryAuthorDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OpenLibraryAuthorDetailBuilder toBuilder() =>
      new OpenLibraryAuthorDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OpenLibraryAuthorDetail &&
        wikipedia == other.wikipedia &&
        personalName == other.personalName &&
        key == other.key &&
        alternateNameList == other.alternateNameList &&
        name == other.name &&
        title == other.title &&
        birthDate == other.birthDate &&
        photoIdList == other.photoIdList;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc($jc(0, wikipedia.hashCode),
                                personalName.hashCode),
                            key.hashCode),
                        alternateNameList.hashCode),
                    name.hashCode),
                title.hashCode),
            birthDate.hashCode),
        photoIdList.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OpenLibraryAuthorDetail')
          ..add('wikipedia', wikipedia)
          ..add('personalName', personalName)
          ..add('key', key)
          ..add('alternateNameList', alternateNameList)
          ..add('name', name)
          ..add('title', title)
          ..add('birthDate', birthDate)
          ..add('photoIdList', photoIdList))
        .toString();
  }
}

class OpenLibraryAuthorDetailBuilder
    implements
        Builder<OpenLibraryAuthorDetail, OpenLibraryAuthorDetailBuilder> {
  _$OpenLibraryAuthorDetail? _$v;

  String? _wikipedia;
  String? get wikipedia => _$this._wikipedia;
  set wikipedia(String? wikipedia) => _$this._wikipedia = wikipedia;

  String? _personalName;
  String? get personalName => _$this._personalName;
  set personalName(String? personalName) => _$this._personalName = personalName;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  ListBuilder<String>? _alternateNameList;
  ListBuilder<String> get alternateNameList =>
      _$this._alternateNameList ??= new ListBuilder<String>();
  set alternateNameList(ListBuilder<String>? alternateNameList) =>
      _$this._alternateNameList = alternateNameList;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _birthDate;
  String? get birthDate => _$this._birthDate;
  set birthDate(String? birthDate) => _$this._birthDate = birthDate;

  ListBuilder<int>? _photoIdList;
  ListBuilder<int> get photoIdList =>
      _$this._photoIdList ??= new ListBuilder<int>();
  set photoIdList(ListBuilder<int>? photoIdList) =>
      _$this._photoIdList = photoIdList;

  OpenLibraryAuthorDetailBuilder();

  OpenLibraryAuthorDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _wikipedia = $v.wikipedia;
      _personalName = $v.personalName;
      _key = $v.key;
      _alternateNameList = $v.alternateNameList.toBuilder();
      _name = $v.name;
      _title = $v.title;
      _birthDate = $v.birthDate;
      _photoIdList = $v.photoIdList.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OpenLibraryAuthorDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OpenLibraryAuthorDetail;
  }

  @override
  void update(void Function(OpenLibraryAuthorDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OpenLibraryAuthorDetail build() => _build();

  _$OpenLibraryAuthorDetail _build() {
    _$OpenLibraryAuthorDetail _$result;
    try {
      _$result = _$v ??
          new _$OpenLibraryAuthorDetail._(
              wikipedia: wikipedia,
              personalName: personalName,
              key: BuiltValueNullFieldError.checkNotNull(
                  key, r'OpenLibraryAuthorDetail', 'key'),
              alternateNameList: alternateNameList.build(),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'OpenLibraryAuthorDetail', 'name'),
              title: title,
              birthDate: birthDate,
              photoIdList: photoIdList.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'alternateNameList';
        alternateNameList.build();

        _$failedField = 'photoIdList';
        photoIdList.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'OpenLibraryAuthorDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
