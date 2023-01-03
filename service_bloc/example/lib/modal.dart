import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:example/serializer.dart';

part 'modal.g.dart';

abstract class GithubOrganizationDetail
    implements
        Built<GithubOrganizationDetail, GithubOrganizationDetailBuilder> {
  GithubOrganizationDetail._();

  String get login;

  int get id;

  @BuiltValueField(wireName: 'node_id')
  String get nodeId;

  String get url;

  @BuiltValueField(wireName: 'repos_url')
  String get reposUrl;

  @BuiltValueField(wireName: 'events_url')
  String get eventsUrl;

  @BuiltValueField(wireName: 'hooks_url')
  String get hooksUrl;

  @BuiltValueField(wireName: 'issues_url')
  String get issuesUrl;

  @BuiltValueField(wireName: 'members_url')
  String get membersUrl;

  @BuiltValueField(wireName: 'public_members_url')
  String get publicMembersUrl;

  @BuiltValueField(wireName: 'avatar_url')
  String get avatarUrl;

  String? get description;

  String get name;

  String? get company;

  String? get blog;

  String? get location;

  String? get email;

  @BuiltValueField(wireName: 'twitter_username')
  String? get twitterUsername;

  @BuiltValueField(wireName: 'is_verified')
  bool get isVerified;

  @BuiltValueField(wireName: 'has_organization_projects')
  bool get hasOrganizationProjects;

  @BuiltValueField(wireName: 'has_repository_projects')
  bool get hasRepositoryProjects;

  @BuiltValueField(wireName: 'public_repos')
  int get publicRepos;

  @BuiltValueField(wireName: 'public_gists')
  int get publicGists;

  int get followers;

  int get following;

  @BuiltValueField(wireName: 'html_url')
  String get htmlUrl;

  @BuiltValueField(wireName: 'created_at')
  String get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  String get updatedAt;

  String get type;

  factory GithubOrganizationDetail(
          [void Function(GithubOrganizationDetailBuilder) updates]) =
      _$GithubOrganizationDetail;

  static Serializer<GithubOrganizationDetail> get serializer =>
      _$githubOrganizationDetailSerializer;

  Map<String, dynamic> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>;

  static GithubOrganizationDetail fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith(serializer, json)!;
}
