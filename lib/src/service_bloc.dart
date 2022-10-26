import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'service_event.dart';
part 'service_state.dart';

abstract class ServiceBloc<ServiceRequestedEvent extends ServiceRequested,
    Response> extends Bloc<ServiceRequestedEvent, ServiceState> {
  ServiceBloc({
    EventTransformer<ServiceRequestedEvent>? eventTransformer,
  }) : super(const ServiceInitial()) {
    on<ServiceRequestedEvent>(
      onServiceRequested,
      transformer: eventTransformer ?? droppable(),
    );
  }

  Response? get data {
    final state = this.state;
    if (state is ServiceLoadSuccess<ServiceRequestedEvent, Response>) {
      return state.data;
    }

    return null;
  }

  bool get hasData => data != null;

  @protected
  FutureOr<void> onServiceRequested(
      ServiceRequestedEvent event, Emitter<ServiceState> emit) async {
    await onPreRequest(event, emit);
    await onRequest(event, emit);
    await onPostRequest(event, emit);
  }

  @mustCallSuper
  FutureOr<void> onPreRequest(
      ServiceRequestedEvent event, Emitter<ServiceState> emit) {
    emit(ServiceLoadInProgress(event: event));
  }

  FutureOr<void> onRequest(
      ServiceRequestedEvent event, Emitter<ServiceState> emit);

  FutureOr<void> onPostRequest(
      ServiceRequestedEvent event, Emitter<ServiceState> emit) {}
}
