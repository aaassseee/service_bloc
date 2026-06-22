part of 'service_bloc.dart';

/// Base state for [ServiceBloc]. Every state which is used in [ServiceBloc] and
/// including extended [ServiceBloc] class must use this class as base state class.
@immutable
abstract class ServiceState<ResponseData> extends Equatable {
  const ServiceState({required this.data});

  final ResponseData data;
}

/// Initial state when [ServiceBloc] created by constructor. Default initial
/// state of [ServiceBloc] should be only appear once.
class ServiceInitial<ResponseData> extends ServiceState<ResponseData> {
  const ServiceInitial({required super.data});

  @override
  List<Object?> get props => [data];
}

/// Processing state when [ServiceBloc] is handling event. This state can be
/// used for displaying loading on screen.
///
/// The parameter [event] means which event made this state.
class ServiceLoadInProgress<ServiceRequestedEvent extends ServiceRequested,
    ResponseData> extends ServiceState {
  const ServiceLoadInProgress({
    required this.event,
    required super.data,
  });

  final ServiceRequestedEvent event;

  @override
  List<Object?> get props => [
        event,
        data,
      ];

  @override
  String toString() {
    return 'ServiceLoadInProgress{event: $event, data: $data}';
  }
}

/// Base response state for [ServiceBloc]. Every response state which is used in
/// [ServiceBloc] and including extended [ServiceBloc] class must use this class
/// as base response state class.
///
/// The parameter [event] means which event made this response state.
@immutable
abstract class ServiceResponseState<
    ServiceRequestedEvent extends ServiceRequested,
    ResponseData> extends ServiceState<ResponseData> {
  const ServiceResponseState({
    required this.event,
    required super.data,
  });

  final ServiceRequestedEvent event;
}

/// Success response state when [ServiceBloc] processed event without error. This
/// state can be used for displaying data with custom view.
///
/// The parameter [event] means which event made this state.
class ServiceLoadSuccess<ServiceRequestedEvent extends ServiceRequested,
        ResponseData>
    extends ServiceResponseState<ServiceRequestedEvent, ResponseData> {
  const ServiceLoadSuccess({
    required super.event,
    required super.data,
  });

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
class ServiceLoadFailure<ServiceRequestedEvent extends ServiceRequested,
        ResponseData>
    extends ServiceResponseState<ServiceRequestedEvent, ResponseData> {
  const ServiceLoadFailure({
    required super.event,
    required super.data,
    this.error,
  });

  final dynamic error;

  @override
  List<Object?> get props => [
        event,
        data,
        error,
      ];

  @override
  String toString() {
    return 'ServiceLoadFailure{event: $event, data: $data, error: $error}';
  }
}
