part of 'service_bloc.dart';

@immutable
abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {
  const ServiceInitial();
}

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

abstract class ServiceResponseState<
    ServiceRequestedEvent extends ServiceRequested> extends ServiceState {
  const ServiceResponseState({required this.event});

  final ServiceRequestedEvent event;
}

class ServiceLoadSuccess<ServiceRequestedEvent extends ServiceRequested,
    Response> extends ServiceResponseState<ServiceRequestedEvent> {
  const ServiceLoadSuccess({
    required ServiceRequestedEvent event,
    required this.data,
  }) : super(event: event);

  final Response data;

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

class ServiceLoadFailure<ServiceRequestedEvent extends ServiceRequested>
    extends ServiceResponseState<ServiceRequestedEvent> {
  const ServiceLoadFailure({
    required ServiceRequestedEvent event,
    this.error,
  }) : super(event: event);

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
