import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'service_event.dart';

part 'service_state.dart';

/// Base class for service calling implement with bloc architecture.
///
/// Each [ServiceBloc] should create a unique event class extending
/// [ServiceRequestedEvent]
///
/// Each [ServiceBloc] should only return a single base type as response type.
abstract class ServiceBloc<ServiceRequestedEvent extends ServiceRequested,
    ResponseData> extends Bloc<ServiceRequestedEvent, ServiceState> {
  /// Constructor for creating [ServiceBloc].
  ///
  /// Parameter [eventTransformer] can be used for handing complex concurrent
  /// event with different handling strategies.
  /// Check out [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)
  /// for more detail.
  ServiceBloc({
    EventTransformer<ServiceRequestedEvent>? eventTransformer,
  }) : super(const ServiceInitial()) {
    on<ServiceRequestedEvent>(
      onServiceRequested,
      transformer: eventTransformer ?? droppable(),
    );
  }

  /// Quick shortcut for getting data if state is now [ServiceLoadSuccess].
  /// Otherwise, return null.
  ResponseData? get data {
    final state = this.state;
    if (state is ServiceLoadSuccess<ServiceRequestedEvent, ResponseData>) {
      return state.data;
    }

    return null;
  }

  /// Quick shortcut for checking
  bool get hasData => data != null;

  /// Function for handling [ServiceEvent] when use add event to [ServiceBloc].
  @protected
  FutureOr<void> onServiceRequested(
      ServiceRequestedEvent event, Emitter<ServiceState> emit) async {
    await onPreRequest(event, emit);
    await onRequest(event, emit);
    await onPostRequest(event, emit);
  }

  /// Function for handling custom action before any event is getting process.
  /// Default emitting [ServiceLoadInProgress].
  @mustCallSuper
  FutureOr<void> onPreRequest(
      ServiceRequestedEvent event, Emitter<ServiceState> emit) {
    emit(ServiceLoadInProgress(event: event));
  }

  /// Function for implementation of handling event process. All request must be
  /// call or complete within this function.
  FutureOr<void> onRequest(
      ServiceRequestedEvent event, Emitter<ServiceState> emit);

  /// Function for handling custom action after event getting processed.
  FutureOr<void> onPostRequest(
      ServiceRequestedEvent event, Emitter<ServiceState> emit) {}
}
