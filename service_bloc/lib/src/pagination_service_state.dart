part of 'pagination_service_bloc.dart';

/// Base state for [PaginationServiceBloc]. Every state which is used in
/// [PaginationServiceBloc] and including extended [PaginationServiceBloc] class
/// must use this class as base state class.
@immutable
abstract class PaginationServiceState {}

/// Initial state when [PaginationServiceBloc] created by constructor. Default
/// initial state of [PaginationServiceBloc] should be only appear once.
class PaginationServiceInitial<ResponseData> extends ServiceState<ResponseData>
    implements PaginationServiceState {
  const PaginationServiceInitial({required super.data});

  @override
  List<Object?> get props => [data];
}

/// Processing state when [PaginationServiceBloc] is handling event. This state
/// can be used for displaying loading on screen.
///
/// The parameter [event] means which event made this state.
class PaginationServiceLoadInProgress<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends ServiceLoadInProgress<PaginationServiceRequestedEvent, ResponseData>
    implements PaginationServiceState {
  const PaginationServiceLoadInProgress({
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
    return 'PaginationServiceLoadInProgress{event: $event, data: $data}';
  }
}

/// Base response state for [PaginationServiceBloc]. Every response state which
/// is used in [PaginationServiceBloc] and including extended [PaginationServiceBloc]
/// class must use this class as base response state class.
///
/// The parameter [event] means which event made this response state.
@immutable
abstract class PaginationServiceResponseState<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends ServiceResponseState<PaginationServiceRequestedEvent, ResponseData>
    implements PaginationServiceState {
  const PaginationServiceResponseState({
    required super.event,
    required super.data,
  });
}

/// Success response state when [PaginationServiceBloc] processed event without
/// error. This state can be used for displaying data with custom view.
///
/// The parameter [event] means which event made this state.
class PaginationServiceLoadSuccess<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends ServiceLoadSuccess<PaginationServiceRequestedEvent, ResponseData>
    implements
        PaginationServiceResponseState<PaginationServiceRequestedEvent,
            ResponseData> {
  const PaginationServiceLoadSuccess({
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
    return 'PaginationServiceLoadSuccess{event: $event, data: $data}';
  }
}

/// Failure response state when [PaginationServiceBloc] processed event with error.
/// This state can be used for displaying error dialog with custom view.
///
/// The parameter [event] means which event made this state.
class PaginationServiceLoadFailure<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends ServiceLoadFailure<PaginationServiceRequestedEvent, ResponseData>
    implements
        PaginationServiceResponseState<PaginationServiceRequestedEvent,
            ResponseData> {
  const PaginationServiceLoadFailure({
    required super.event,
    required super.data,
    super.error,
  });

  @override
  List<Object?> get props => [
        event,
        data,
        error,
      ];

  @override
  String toString() {
    return 'PaginationServiceLoadFailure{event: $event, error: $error, data: $data}';
  }
}
