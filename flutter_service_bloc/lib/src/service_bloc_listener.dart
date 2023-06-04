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
              (previous, current) => switch (current) {
                    ServiceInitial() => onInitial != null,
                    ServiceLoadInProgress<ServiceRequestedEvent>() =>
                      onLoading != null,
                    ServiceLoadSuccess<ServiceRequestedEvent, ResponseData>() =>
                      onResponded != null || onSuccess != null,
                    ServiceLoadFailure<ServiceRequestedEvent>() =>
                      onResponded != null || onFailure != null,
                    _ => false,
                  },
          listener: (context, state) => switch (state) {
            ServiceInitial() when onInitial != null =>
              onInitial(context, state),
            ServiceLoadInProgress<ServiceRequestedEvent>(event: final event)
                when onLoading != null =>
              onLoading(context, state, event),
            ServiceResponseState<ServiceRequestedEvent>(event: final event)
                when onResponded != null =>
              onResponded(context, state, event),
            ServiceLoadSuccess<ServiceRequestedEvent, ResponseData>(
              event: final event,
              data: final data
            )
                when onSuccess != null =>
              onSuccess(context, state, event, data),
            ServiceLoadFailure<ServiceRequestedEvent>(
              event: final event,
              error: final error
            )
                when onFailure != null =>
              onFailure(context, state, event, error),
            _ => () {},
          },
          child: child,
        );

  /// A function which is only called when [listenWhen] is omitted or custom
  /// [listenWhen] is passed, [onInitial] is not omitted and current state is
  /// [ServiceInitial].
  final Function(
    BuildContext context,
    ServiceInitial state,
  )? onInitial;

  /// A function which is only called when [listenWhen] is omitted or custom
  /// [listenWhen] is passed, [onLoading] is not omitted and current state is
  /// [ServiceLoadInProgress].
  final Function(
    BuildContext context,
    ServiceLoadInProgress<ServiceRequestedEvent> state,
    ServiceRequestedEvent event,
  )? onLoading;

  /// A function which is only called when [listenWhen] is omitted or custom
  /// [listenWhen] is passed and [onResponded] is not omitted and current state is
  /// [ServiceResponseState].
  final Function(
    BuildContext context,
    ServiceResponseState<ServiceRequestedEvent> state,
    ServiceRequestedEvent event,
  )? onResponded;

  /// A function which is only called when [listenWhen] is omitted or custom
  /// [listenWhen] is passed and [onSucceed] is not omitted and current state is
  /// [ServiceLoadSuccess].
  final Function(
    BuildContext context,
    ServiceLoadSuccess<ServiceRequestedEvent, ResponseData> state,
    ServiceRequestedEvent event,
    ResponseData data,
  )? onSuccess;

  /// A function which is only called when [listenWhen] is omitted or custom
  /// [listenWhen] is passed and [onFailure] is not omitted and current state is
  /// [ServiceLoadFailure].
  final Function(
    BuildContext context,
    ServiceLoadFailure<ServiceRequestedEvent> state,
    ServiceRequestedEvent event,
    dynamic error,
  )? onFailure;
}
