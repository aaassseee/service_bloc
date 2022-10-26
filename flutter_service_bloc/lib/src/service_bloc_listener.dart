import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_bloc/service_bloc.dart';

class ServiceBlocListener<
    Bloc extends ServiceBloc<ServiceRequestedEvent, Response>,
    ServiceRequestedEvent extends ServiceRequested,
    Response> extends BlocListener<Bloc, ServiceState> {
  final Function(
    BuildContext context,
    ServiceLoadInProgress<ServiceRequestedEvent> state,
    ServiceRequestedEvent event,
  )? onLoading;

  final Function(
    BuildContext context,
    ServiceResponseState<ServiceRequestedEvent> state,
    ServiceRequestedEvent event,
  )? onResponded;

  final Function(
    BuildContext context,
    ServiceLoadSuccess<ServiceRequestedEvent, Response> state,
    ServiceRequestedEvent event,
    Response? response,
  )? onSucceed;

  final Function(
    BuildContext context,
    ServiceLoadFailure<ServiceRequestedEvent> state,
    ServiceRequestedEvent event,
    dynamic error,
  )? onFailed;

  ServiceBlocListener({
    Key? key,
    Bloc? bloc,
    BlocListenerCondition<ServiceState>? listenWhen,
    this.onLoading,
    this.onResponded,
    this.onSucceed,
    this.onFailed,
    Widget? child,
  }) : super(
          key: key,
          bloc: bloc,
          listenWhen: listenWhen,
          listener: (context, state) {
            if (state is ServiceLoadInProgress<ServiceRequestedEvent>) {
              if (onLoading != null) {
                onLoading(context, state, state.event);
              }
              return;
            }

            if (state is ServiceResponseState<ServiceRequestedEvent>) {
              if (onResponded != null) {
                onResponded(context, state, state.event);
              }

              if (state
                  is ServiceLoadSuccess<ServiceRequestedEvent, Response>) {
                final data = state.data;
                if (onSucceed != null) {
                  onSucceed(context, state, state.event, data);
                }
                return;
              }

              if (state is ServiceLoadFailure<ServiceRequestedEvent>) {
                if (onFailed != null) {
                  onFailed(context, state, state.event, state.error);
                }
                return;
              }
            }
          },
          child: child,
        );
}
