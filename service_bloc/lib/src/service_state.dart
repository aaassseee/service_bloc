part of 'service_bloc.dart';

/// Base state for [ServiceBloc]. Every state which is used in [ServiceBloc] and
/// including extended [ServiceBloc] class must use this class as base state class.
@immutable
abstract class ServiceState extends Equatable {
  const ServiceState();
}

/// Initial state when [ServiceBloc] created by constructor. Default initial
/// state of [ServiceBloc] should be only appear once.
class ServiceInitial extends ServiceState {
  const ServiceInitial();

  @override
  List<Object?> get props => [];
}

/// Processing state when [ServiceBloc] is handling event. This state can be
/// used for displaying loading on screen.
///
/// The parameter [event] means which event made this state.
class ServiceLoadInProgress<ServiceRequestedEvent extends ServiceRequested>
    extends ServiceState {
  const ServiceLoadInProgress({required this.event});

  final ServiceRequestedEvent event;

  @override
  List<Object?> get props => [event];

  @override
  String toString() {
    return 'ServiceLoadInProgress{event: $event}';
  }
}

/// Base response state for [ServiceBloc]. Every response state which is used in
/// [ServiceBloc] and including extended [ServiceBloc] class must use this class
/// as base response state class.
///
/// The parameter [event] means which event made this response state.
@immutable
abstract class ServiceResponseState<
    ServiceRequestedEvent extends ServiceRequested> extends ServiceState {
  const ServiceResponseState({required this.event});

  final ServiceRequestedEvent event;
}

/// Success response state when [ServiceBloc] processed event without error. This
/// state can be used for displaying data with custom view.
///
/// The parameter [event] means which event made this state.
class ServiceLoadSuccess<ServiceRequestedEvent extends ServiceRequested,
    ResponseData> extends ServiceResponseState<ServiceRequestedEvent> {
  const ServiceLoadSuccess({
    required super.event,
    required this.data,
  });

  final ResponseData data;

  @override
  List<Object?> get props => [
        event,
        data,
      ];

  @override
  String toString() {
    return 'ServiceLoadSuccess{event: $event, data: $data}';
  }
}

/// Failure response state when [ServiceBloc] processed event with error. This
/// state can be used for displaying error dialog with custom view.
///
/// The parameter [event] means which event made this state.
class ServiceLoadFailure<ServiceRequestedEvent extends ServiceRequested>
    extends ServiceResponseState<ServiceRequestedEvent> {
  const ServiceLoadFailure({
    required super.event,
    this.error,
  });

  final dynamic error;

  @override
  List<Object?> get props => [
        event,
        error,
      ];

  @override
  String toString() {
    return 'ServiceLoadFailure{event: $event, error: $error}';
  }
}
