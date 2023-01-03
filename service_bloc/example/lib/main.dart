import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:example/modal.dart';
import 'package:http/http.dart';
import 'package:service_bloc/service_bloc.dart';

void main() async {
  final organizationDetailServiceBloc = GithubOrganisationDetailServiceBloc();
  organizationDetailServiceBloc
      .add(GithubOrganisationDetailServiceRequested(name: 'flutter'));
  await for (final state in organizationDetailServiceBloc.stream) {
    if (state is! ServiceResponseState) continue;

    if (state is ServiceLoadSuccess<GithubOrganisationDetailServiceRequested,
        GithubOrganizationDetail>) {
      print('response: ${state.data}');
    }

    if (state is ServiceLoadFailure) {
      print('error: ${state.error}');
    }

    break;
  }
}

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
