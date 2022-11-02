import 'package:example/github/bloc/service_bloc.dart';
import 'package:example/github/modal/modal.dart';
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
