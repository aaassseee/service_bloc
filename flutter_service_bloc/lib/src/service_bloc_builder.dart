import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [ServiceBlocBuilder] handles building a widget in response to relative state.
///
/// If parameter [buildWhen] is omitted, default [buildWhen] will only return true
/// when certain parameter is set. For example [onInitial] [onLoading] [onFailed].
/// [onSuccess] is a required parameter so [buildWhen] will always return true if
/// state is [ServiceLoadSuccess]
import 'package:service_bloc/service_bloc.dart';

class ServiceBlocBuilder<
    Bloc extends ServiceBloc<ServiceRequestedEvent, Response>,
    ServiceRequestedEvent extends ServiceRequested,
    Response> extends BlocBuilder<Bloc, ServiceState> {
  final Widget Function(
    BuildContext context,
    ServiceInitial state,
  )? onInitial;

  final Widget Function(
    BuildContext context,
    ServiceLoadInProgress<ServiceRequestedEvent> state,
    ServiceRequestedEvent event,
  )? onLoading;

  final Widget Function(
    BuildContext context,
    ServiceLoadSuccess<ServiceRequestedEvent, Response> state,
    ServiceRequestedEvent event,
    Response response,
  ) onSuccess;

  final Widget Function(
    BuildContext context,
    ServiceLoadFailure<ServiceRequestedEvent> state,
    ServiceRequestedEvent event,
    dynamic error,
  )? onFailed;

  final Widget? fallback;

  ServiceBlocBuilder({
    Key? key,
    Bloc? bloc,
    this.onInitial,
    this.onLoading,
    required this.onSuccess,
    this.onFailed,
    this.fallback,
  }) : super(
          key: key,
          bloc: bloc,
          buildWhen: (previous, current) {
            if (current is ServiceInitial) {
              return onInitial != null;
            }

            if (current is ServiceLoadInProgress<ServiceRequestedEvent>) {
              return onLoading != null;
            }

            if (current
                is ServiceLoadSuccess<ServiceRequestedEvent, Response>) {
              return true;
            }

            if (current is ServiceLoadFailure<ServiceRequestedEvent>) {
              return onFailed != null;
            }

            return false;
          },
          builder: (context, state) {
            if (state is ServiceInitial) {
              if (onInitial == null) {
                return fallback ?? Container();
              }
              return onInitial(context, state);
            }

            if (state is ServiceLoadInProgress<ServiceRequestedEvent>) {
              if (onLoading == null) {
                return fallback ?? Container();
              }
              return onLoading(context, state, state.event);
            }

            if (state is ServiceLoadSuccess<ServiceRequestedEvent, Response>) {
              final data = state.data;
              if (data == null) {
                return fallback ?? Container();
              }

              return onSuccess(context, state, state.event, data);
            }

            if (state is ServiceLoadFailure<ServiceRequestedEvent>) {
              if (onFailed == null) {
                return fallback ?? Container();
              }
              return onFailed(context, state, state.event, state.error);
            }

            return fallback ?? Container();
          },
        );
}
