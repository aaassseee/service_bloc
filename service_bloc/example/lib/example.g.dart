// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GithubOrganizationDetail> _$githubOrganizationDetailSerializer =
    new _$GithubOrganizationDetailSerializer();

class _$GithubOrganizationDetailSerializer
    implements StructuredSerializer<GithubOrganizationDetail> {
  @override
  final Iterable<Type> types = const [
    GithubOrganizationDetail,
    _$GithubOrganizationDetail
  ];
  @override
  final String wireName = 'GithubOrganizationDetail';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, GithubOrganizationDetail object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'login',
      serializers.serialize(object.login,
          specifiedType: const FullType(String)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'node_id',
      serializers.serialize(object.nodeId,
          specifiedType: const FullType(String)),
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
      'repos_url',
      serializers.serialize(object.reposUrl,
          specifiedType: const FullType(String)),
      'events_url',
      serializers.serialize(object.eventsUrl,
          specifiedType: const FullType(String)),
      'hooks_url',
      serializers.serialize(object.hooksUrl,
          specifiedType: const FullType(String)),
      'issues_url',
      serializers.serialize(object.issuesUrl,
          specifiedType: const FullType(String)),
      'members_url',
      serializers.serialize(object.membersUrl,
          specifiedType: const FullType(String)),
      'public_members_url',
      serializers.serialize(object.publicMembersUrl,
          specifiedType: const FullType(String)),
      'avatar_url',
      serializers.serialize(object.avatarUrl,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'is_verified',
      serializers.serialize(object.isVerified,
          specifiedType: const FullType(bool)),
      'has_organization_projects',
      serializers.serialize(object.hasOrganizationProjects,
          specifiedType: const FullType(bool)),
      'has_repository_projects',
      serializers.serialize(object.hasRepositoryProjects,
          specifiedType: const FullType(bool)),
      'public_repos',
      serializers.serialize(object.publicRepos,
          specifiedType: const FullType(int)),
      'public_gists',
      serializers.serialize(object.publicGists,
          specifiedType: const FullType(int)),
      'followers',
      serializers.serialize(object.followers,
          specifiedType: const FullType(int)),
      'following',
      serializers.serialize(object.following,
          specifiedType: const FullType(int)),
      'html_url',
      serializers.serialize(object.htmlUrl,
          specifiedType: const FullType(String)),
      'created_at',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(String)),
      'updated_at',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.company;
    if (value != null) {
      result
        ..add('company')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.blog;
    if (value != null) {
      result
        ..add('blog')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.location;
    if (value != null) {
      result
        ..add('location')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.email;
    if (value != null) {
      result
        ..add('email')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.twitterUsername;
    if (value != null) {
      result
        ..add('twitter_username')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  GithubOrganizationDetail deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GithubOrganizationDetailBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'login':
          result.login = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'node_id':
          result.nodeId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'repos_url':
          result.reposUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'events_url':
          result.eventsUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'hooks_url':
          result.hooksUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'issues_url':
          result.issuesUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'members_url':
          result.membersUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'public_members_url':
          result.publicMembersUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'avatar_url':
          result.avatarUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'company':
          result.company = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'blog':
          result.blog = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'location':
          result.location = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'twitter_username':
          result.twitterUsername = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'is_verified':
          result.isVerified = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'has_organization_projects':
          result.hasOrganizationProjects = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'has_repository_projects':
          result.hasRepositoryProjects = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'public_repos':
          result.publicRepos = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'public_gists':
          result.publicGists = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'followers':
          result.followers = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'following':
          result.following = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'html_url':
          result.htmlUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$GithubOrganizationDetail extends GithubOrganizationDetail {
  @override
  final String login;
  @override
  final int id;
  @override
  final String nodeId;
  @override
  final String url;
  @override
  final String reposUrl;
  @override
  final String eventsUrl;
  @override
  final String hooksUrl;
  @override
  final String issuesUrl;
  @override
  final String membersUrl;
  @override
  final String publicMembersUrl;
  @override
  final String avatarUrl;
  @override
  final String? description;
  @override
  final String name;
  @override
  final String? company;
  @override
  final String? blog;
  @override
  final String? location;
  @override
  final String? email;
  @override
  final String? twitterUsername;
  @override
  final bool isVerified;
  @override
  final bool hasOrganizationProjects;
  @override
  final bool hasRepositoryProjects;
  @override
  final int publicRepos;
  @override
  final int publicGists;
  @override
  final int followers;
  @override
  final int following;
  @override
  final String htmlUrl;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final String type;

  factory _$GithubOrganizationDetail(
          [void Function(GithubOrganizationDetailBuilder)? updates]) =>
      (new GithubOrganizationDetailBuilder()..update(updates))._build();

  _$GithubOrganizationDetail._(
      {required this.login,
      required this.id,
      required this.nodeId,
      required this.url,
      required this.reposUrl,
      required this.eventsUrl,
      required this.hooksUrl,
      required this.issuesUrl,
      required this.membersUrl,
      required this.publicMembersUrl,
      required this.avatarUrl,
      this.description,
      required this.name,
      this.company,
      this.blog,
      this.location,
      this.email,
      this.twitterUsername,
      required this.isVerified,
      required this.hasOrganizationProjects,
      required this.hasRepositoryProjects,
      required this.publicRepos,
      required this.publicGists,
      required this.followers,
      required this.following,
      required this.htmlUrl,
      required this.createdAt,
      required this.updatedAt,
      required this.type})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        login, r'GithubOrganizationDetail', 'login');
    BuiltValueNullFieldError.checkNotNull(
        id, r'GithubOrganizationDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(
        nodeId, r'GithubOrganizationDetail', 'nodeId');
    BuiltValueNullFieldError.checkNotNull(
        url, r'GithubOrganizationDetail', 'url');
    BuiltValueNullFieldError.checkNotNull(
        reposUrl, r'GithubOrganizationDetail', 'reposUrl');
    BuiltValueNullFieldError.checkNotNull(
        eventsUrl, r'GithubOrganizationDetail', 'eventsUrl');
    BuiltValueNullFieldError.checkNotNull(
        hooksUrl, r'GithubOrganizationDetail', 'hooksUrl');
    BuiltValueNullFieldError.checkNotNull(
        issuesUrl, r'GithubOrganizationDetail', 'issuesUrl');
    BuiltValueNullFieldError.checkNotNull(
        membersUrl, r'GithubOrganizationDetail', 'membersUrl');
    BuiltValueNullFieldError.checkNotNull(
        publicMembersUrl, r'GithubOrganizationDetail', 'publicMembersUrl');
    BuiltValueNullFieldError.checkNotNull(
        avatarUrl, r'GithubOrganizationDetail', 'avatarUrl');
    BuiltValueNullFieldError.checkNotNull(
        name, r'GithubOrganizationDetail', 'name');
    BuiltValueNullFieldError.checkNotNull(
        isVerified, r'GithubOrganizationDetail', 'isVerified');
    BuiltValueNullFieldError.checkNotNull(hasOrganizationProjects,
        r'GithubOrganizationDetail', 'hasOrganizationProjects');
    BuiltValueNullFieldError.checkNotNull(hasRepositoryProjects,
        r'GithubOrganizationDetail', 'hasRepositoryProjects');
    BuiltValueNullFieldError.checkNotNull(
        publicRepos, r'GithubOrganizationDetail', 'publicRepos');
    BuiltValueNullFieldError.checkNotNull(
        publicGists, r'GithubOrganizationDetail', 'publicGists');
    BuiltValueNullFieldError.checkNotNull(
        followers, r'GithubOrganizationDetail', 'followers');
    BuiltValueNullFieldError.checkNotNull(
        following, r'GithubOrganizationDetail', 'following');
    BuiltValueNullFieldError.checkNotNull(
        htmlUrl, r'GithubOrganizationDetail', 'htmlUrl');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'GithubOrganizationDetail', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'GithubOrganizationDetail', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        type, r'GithubOrganizationDetail', 'type');
  }

  @override
  GithubOrganizationDetail rebuild(
          void Function(GithubOrganizationDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GithubOrganizationDetailBuilder toBuilder() =>
      new GithubOrganizationDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GithubOrganizationDetail &&
        login == other.login &&
        id == other.id &&
        nodeId == other.nodeId &&
        url == other.url &&
        reposUrl == other.reposUrl &&
        eventsUrl == other.eventsUrl &&
        hooksUrl == other.hooksUrl &&
        issuesUrl == other.issuesUrl &&
        membersUrl == other.membersUrl &&
        publicMembersUrl == other.publicMembersUrl &&
        avatarUrl == other.avatarUrl &&
        description == other.description &&
        name == other.name &&
        company == other.company &&
        blog == other.blog &&
        location == other.location &&
        email == other.email &&
        twitterUsername == other.twitterUsername &&
        isVerified == other.isVerified &&
        hasOrganizationProjects == other.hasOrganizationProjects &&
        hasRepositoryProjects == other.hasRepositoryProjects &&
        publicRepos == other.publicRepos &&
        publicGists == other.publicGists &&
        followers == other.followers &&
        following == other.following &&
        htmlUrl == other.htmlUrl &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        type == other.type;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            $jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc(0, login.hashCode), id.hashCode), nodeId.hashCode), url.hashCode), reposUrl.hashCode), eventsUrl.hashCode), hooksUrl.hashCode), issuesUrl.hashCode), membersUrl.hashCode), publicMembersUrl.hashCode),
                                                                                avatarUrl.hashCode),
                                                                            description.hashCode),
                                                                        name.hashCode),
                                                                    company.hashCode),
                                                                blog.hashCode),
                                                            location.hashCode),
                                                        email.hashCode),
                                                    twitterUsername.hashCode),
                                                isVerified.hashCode),
                                            hasOrganizationProjects.hashCode),
                                        hasRepositoryProjects.hashCode),
                                    publicRepos.hashCode),
                                publicGists.hashCode),
                            followers.hashCode),
                        following.hashCode),
                    htmlUrl.hashCode),
                createdAt.hashCode),
            updatedAt.hashCode),
        type.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GithubOrganizationDetail')
          ..add('login', login)
          ..add('id', id)
          ..add('nodeId', nodeId)
          ..add('url', url)
          ..add('reposUrl', reposUrl)
          ..add('eventsUrl', eventsUrl)
          ..add('hooksUrl', hooksUrl)
          ..add('issuesUrl', issuesUrl)
          ..add('membersUrl', membersUrl)
          ..add('publicMembersUrl', publicMembersUrl)
          ..add('avatarUrl', avatarUrl)
          ..add('description', description)
          ..add('name', name)
          ..add('company', company)
          ..add('blog', blog)
          ..add('location', location)
          ..add('email', email)
          ..add('twitterUsername', twitterUsername)
          ..add('isVerified', isVerified)
          ..add('hasOrganizationProjects', hasOrganizationProjects)
          ..add('hasRepositoryProjects', hasRepositoryProjects)
          ..add('publicRepos', publicRepos)
          ..add('publicGists', publicGists)
          ..add('followers', followers)
          ..add('following', following)
          ..add('htmlUrl', htmlUrl)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('type', type))
        .toString();
  }
}

class GithubOrganizationDetailBuilder
    implements
        Builder<GithubOrganizationDetail, GithubOrganizationDetailBuilder> {
  _$GithubOrganizationDetail? _$v;

  String? _login;
  String? get login => _$this._login;
  set login(String? login) => _$this._login = login;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nodeId;
  String? get nodeId => _$this._nodeId;
  set nodeId(String? nodeId) => _$this._nodeId = nodeId;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _reposUrl;
  String? get reposUrl => _$this._reposUrl;
  set reposUrl(String? reposUrl) => _$this._reposUrl = reposUrl;

  String? _eventsUrl;
  String? get eventsUrl => _$this._eventsUrl;
  set eventsUrl(String? eventsUrl) => _$this._eventsUrl = eventsUrl;

  String? _hooksUrl;
  String? get hooksUrl => _$this._hooksUrl;
  set hooksUrl(String? hooksUrl) => _$this._hooksUrl = hooksUrl;

  String? _issuesUrl;
  String? get issuesUrl => _$this._issuesUrl;
  set issuesUrl(String? issuesUrl) => _$this._issuesUrl = issuesUrl;

  String? _membersUrl;
  String? get membersUrl => _$this._membersUrl;
  set membersUrl(String? membersUrl) => _$this._membersUrl = membersUrl;

  String? _publicMembersUrl;
  String? get publicMembersUrl => _$this._publicMembersUrl;
  set publicMembersUrl(String? publicMembersUrl) =>
      _$this._publicMembersUrl = publicMembersUrl;

  String? _avatarUrl;
  String? get avatarUrl => _$this._avatarUrl;
  set avatarUrl(String? avatarUrl) => _$this._avatarUrl = avatarUrl;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _company;
  String? get company => _$this._company;
  set company(String? company) => _$this._company = company;

  String? _blog;
  String? get blog => _$this._blog;
  set blog(String? blog) => _$this._blog = blog;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _twitterUsername;
  String? get twitterUsername => _$this._twitterUsername;
  set twitterUsername(String? twitterUsername) =>
      _$this._twitterUsername = twitterUsername;

  bool? _isVerified;
  bool? get isVerified => _$this._isVerified;
  set isVerified(bool? isVerified) => _$this._isVerified = isVerified;

  bool? _hasOrganizationProjects;
  bool? get hasOrganizationProjects => _$this._hasOrganizationProjects;
  set hasOrganizationProjects(bool? hasOrganizationProjects) =>
      _$this._hasOrganizationProjects = hasOrganizationProjects;

  bool? _hasRepositoryProjects;
  bool? get hasRepositoryProjects => _$this._hasRepositoryProjects;
  set hasRepositoryProjects(bool? hasRepositoryProjects) =>
      _$this._hasRepositoryProjects = hasRepositoryProjects;

  int? _publicRepos;
  int? get publicRepos => _$this._publicRepos;
  set publicRepos(int? publicRepos) => _$this._publicRepos = publicRepos;

  int? _publicGists;
  int? get publicGists => _$this._publicGists;
  set publicGists(int? publicGists) => _$this._publicGists = publicGists;

  int? _followers;
  int? get followers => _$this._followers;
  set followers(int? followers) => _$this._followers = followers;

  int? _following;
  int? get following => _$this._following;
  set following(int? following) => _$this._following = following;

  String? _htmlUrl;
  String? get htmlUrl => _$this._htmlUrl;
  set htmlUrl(String? htmlUrl) => _$this._htmlUrl = htmlUrl;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  GithubOrganizationDetailBuilder();

  GithubOrganizationDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _login = $v.login;
      _id = $v.id;
      _nodeId = $v.nodeId;
      _url = $v.url;
      _reposUrl = $v.reposUrl;
      _eventsUrl = $v.eventsUrl;
      _hooksUrl = $v.hooksUrl;
      _issuesUrl = $v.issuesUrl;
      _membersUrl = $v.membersUrl;
      _publicMembersUrl = $v.publicMembersUrl;
      _avatarUrl = $v.avatarUrl;
      _description = $v.description;
      _name = $v.name;
      _company = $v.company;
      _blog = $v.blog;
      _location = $v.location;
      _email = $v.email;
      _twitterUsername = $v.twitterUsername;
      _isVerified = $v.isVerified;
      _hasOrganizationProjects = $v.hasOrganizationProjects;
      _hasRepositoryProjects = $v.hasRepositoryProjects;
      _publicRepos = $v.publicRepos;
      _publicGists = $v.publicGists;
      _followers = $v.followers;
      _following = $v.following;
      _htmlUrl = $v.htmlUrl;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GithubOrganizationDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GithubOrganizationDetail;
  }

  @override
  void update(void Function(GithubOrganizationDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GithubOrganizationDetail build() => _build();

  _$GithubOrganizationDetail _build() {
    final _$result = _$v ??
        new _$GithubOrganizationDetail._(
            login: BuiltValueNullFieldError.checkNotNull(
                login, r'GithubOrganizationDetail', 'login'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'GithubOrganizationDetail', 'id'),
            nodeId: BuiltValueNullFieldError.checkNotNull(
                nodeId, r'GithubOrganizationDetail', 'nodeId'),
            url: BuiltValueNullFieldError.checkNotNull(
                url, r'GithubOrganizationDetail', 'url'),
            reposUrl: BuiltValueNullFieldError.checkNotNull(
                reposUrl, r'GithubOrganizationDetail', 'reposUrl'),
            eventsUrl: BuiltValueNullFieldError.checkNotNull(
                eventsUrl, r'GithubOrganizationDetail', 'eventsUrl'),
            hooksUrl: BuiltValueNullFieldError.checkNotNull(
                hooksUrl, r'GithubOrganizationDetail', 'hooksUrl'),
            issuesUrl: BuiltValueNullFieldError.checkNotNull(
                issuesUrl, r'GithubOrganizationDetail', 'issuesUrl'),
            membersUrl: BuiltValueNullFieldError.checkNotNull(membersUrl, r'GithubOrganizationDetail', 'membersUrl'),
            publicMembersUrl: BuiltValueNullFieldError.checkNotNull(publicMembersUrl, r'GithubOrganizationDetail', 'publicMembersUrl'),
            avatarUrl: BuiltValueNullFieldError.checkNotNull(avatarUrl, r'GithubOrganizationDetail', 'avatarUrl'),
            description: description,
            name: BuiltValueNullFieldError.checkNotNull(name, r'GithubOrganizationDetail', 'name'),
            company: company,
            blog: blog,
            location: location,
            email: email,
            twitterUsername: twitterUsername,
            isVerified: BuiltValueNullFieldError.checkNotNull(isVerified, r'GithubOrganizationDetail', 'isVerified'),
            hasOrganizationProjects: BuiltValueNullFieldError.checkNotNull(hasOrganizationProjects, r'GithubOrganizationDetail', 'hasOrganizationProjects'),
            hasRepositoryProjects: BuiltValueNullFieldError.checkNotNull(hasRepositoryProjects, r'GithubOrganizationDetail', 'hasRepositoryProjects'),
            publicRepos: BuiltValueNullFieldError.checkNotNull(publicRepos, r'GithubOrganizationDetail', 'publicRepos'),
            publicGists: BuiltValueNullFieldError.checkNotNull(publicGists, r'GithubOrganizationDetail', 'publicGists'),
            followers: BuiltValueNullFieldError.checkNotNull(followers, r'GithubOrganizationDetail', 'followers'),
            following: BuiltValueNullFieldError.checkNotNull(following, r'GithubOrganizationDetail', 'following'),
            htmlUrl: BuiltValueNullFieldError.checkNotNull(htmlUrl, r'GithubOrganizationDetail', 'htmlUrl'),
            createdAt: BuiltValueNullFieldError.checkNotNull(createdAt, r'GithubOrganizationDetail', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt, r'GithubOrganizationDetail', 'updatedAt'),
            type: BuiltValueNullFieldError.checkNotNull(type, r'GithubOrganizationDetail', 'type'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
