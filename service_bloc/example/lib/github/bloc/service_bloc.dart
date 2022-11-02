import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:example/github/modal/modal.dart';
import 'package:http/http.dart';
import 'package:service_bloc/service_bloc.dart';

class GithubOrganisationDetailServiceRequested extends ServiceRequested {
  const GithubOrganisationDetailServiceRequested({required this.name})
      : assert(name.length > 0);

  final String name;

  @override
  List<Object?> get props => [name];
}

class GithubOrganisationDetailServiceBloc extends ServiceBloc<
    GithubOrganisationDetailServiceRequested, GithubOrganizationDetail> {
  @override
  FutureOr<void> onRequest(GithubOrganisationDetailServiceRequested event,
      Emitter<ServiceState> emit) async {
    try {
      final response =
          await get(Uri.parse('https://api.github.com/orgs/${event.name}'));
      final organizationDetail =
          GithubOrganizationDetail.fromJson(json.decode(response.body));
      emit(ServiceLoadSuccess(event: event, data: organizationDetail));
    } catch (error) {
      emit(ServiceLoadFailure(event: event, error: error));
    }
  }
}
