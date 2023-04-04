import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_bloc/service_bloc.dart';

/// [ServiceBlocListener] handles callback in response to relative state.
///
/// If parameter [listenWhen] is omitted, default [listenWhen] will only return
/// true when certain parameter is set. For example [onInitial] [onLoading]
/// [onResponded] [onSucceed] [onFailure].
class ServiceBlocListener<
    Bloc extends ServiceBloc<ServiceRequestedEvent, ResponseData>,
    ServiceRequestedEvent extends ServiceRequested,
    ResponseData> extends BlocListener<Bloc, ServiceState> {
  /// A constructor for creating a [ServiceBlocListener] with predefined state
  /// callback.
  ServiceBlocListener({
    Key? key,
    Bloc? bloc,
    BlocListenerCondition<ServiceState>? listenWhen,
    this.onInitial,
    this.onLoading,
    this.onResponded,
    this.onSuccess,
    this.onFailure,
    Widget? child,
  }) : super(
          key: key,
          bloc: bloc,
          listenWhen: listenWhen ??
              (previous, current) {
                if (current is ServiceInitial) {
                  return onInitial != null;
                }

                if (current is ServiceLoadInProgress<ServiceRequestedEvent>) {
                  return onLoading != null;
                }

                if (current is ServiceLoadSuccess<ServiceRequestedEvent,
                    ResponseData>) {
                  return onResponded != null || onSuccess != null;
                }

                if (current is ServiceLoadFailure<ServiceRequestedEvent>) {
                  return onResponded != null || onFailure != null;
                }

                return false;
              },
          listener: (context, state) {
            if (state is ServiceInitial) {
              if (onInitial != null) {
                onInitial(context, state);
              }
              return;
            }

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
                  is ServiceLoadSuccess<ServiceRequestedEvent, ResponseData>) {
                final data = state.data;
                if (onSuccess != null) {
                  onSuccess(context, state, state.event, data);
                }
                return;
              }

              if (state is ServiceLoadFailure<ServiceRequestedEvent>) {
                if (onFailure != null) {
                  onFailure(context, state, state.event, state.error);
                }
                return;
              }
            }
          },
          child: child,
        );

  /// A function which is only called when [listenWhen] is omitted or custom
  /// [listenWhen] is passed, [onInitial] is not omitted and current state is
  /// [ServiceInitial].
  final Function(BuildContext context, ServiceInitial state)? onInitial;

  /// A function which is only called when [listenWhen] is omitted or custom
  /// [listenWhen] is passed, [onLoading] is not omitted and current state is
  /// [ServiceLoadInProgress].
  final Function(
      BuildContext context,
      ServiceLoadInProgress<ServiceRequestedEvent> state,
      ServiceRequestedEvent event)? onLoading;

  /// A function which is only called when [listenWhen] is omitted or custom
  /// [listenWhen] is passed and [onResponded] is not omitted and current state is
  /// [ServiceResponseState].
  final Function(
      BuildContext context,
      ServiceResponseState<ServiceRequestedEvent> state,
      ServiceRequestedEvent event)? onResponded;

  /// A function which is only called when [listenWhen] is omitted or custom
  /// [listenWhen] is passed and [onSucceed] is not omitted and current state is
  /// [ServiceLoadSuccess].
  final Function(
      BuildContext context,
      ServiceLoadSuccess<ServiceRequestedEvent, ResponseData> state,
      ServiceRequestedEvent event,
      ResponseData data)? onSuccess;

  /// A function which is only called when [listenWhen] is omitted or custom
  /// [listenWhen] is passed and [onFailure] is not omitted and current state is
  /// [ServiceLoadFailure].
  final Function(
      BuildContext context,
      ServiceLoadFailure<ServiceRequestedEvent> state,
      ServiceRequestedEvent event,
      dynamic error)? onFailure;
}
