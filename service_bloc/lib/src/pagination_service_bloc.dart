import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../service_bloc.dart';

part 'pagination_service_event.dart';

abstract class PaginationServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends ServiceBloc<PaginationServiceRequestedEvent, ResponseData> {
  int _page = 0;

  int get page => _page;

  abstract covariant ResponseData? _responseData;

  ResponseData? get responseData => _responseData;

  bool _isEmptyReturned = false;

  bool get isEmptyReturned => _isEmptyReturned;

  bool get isFirstLoad;

  PaginationServiceBloc({
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(eventTransformer: eventTransformer);

  @override
  FutureOr<void> onPreRequest(
      PaginationServiceRequestedEvent event, Emitter<ServiceState> emit) {
    if (event is PaginationReloadServiceRequested) {
      onPreRequestReset();
    }

    return super.onPreRequest(event, emit);
  }

  FutureOr<void> onPreRequestReset();

  @override
  @protected
  FutureOr<void> onRequest(
      PaginationServiceRequestedEvent event, Emitter<ServiceState> emit) async {
    try {
      final responseData = await onPaginationRequest(event, page);
      if (await isEmptyPage(responseData)) {
        _isEmptyReturned = true;
        _responseData ??= responseData;
        emit(ServiceLoadSuccess<PaginationServiceRequestedEvent, ResponseData>(
            event: event, data: _responseData ?? responseData));
        return;
      }

      final processedResponseData =
          await onProcessResponseData(_responseData, responseData);
      _responseData = processedResponseData;
      _page += 1;

      emit(ServiceLoadSuccess<PaginationServiceRequestedEvent, ResponseData>(
          event: event, data: processedResponseData));
    } catch (error) {
      emit(ServiceLoadFailure<PaginationServiceRequestedEvent>(
          event: event, error: error));
    }
  }

  FutureOr<ResponseData> onPaginationRequest(
      PaginationServiceRequestedEvent event, int page);

  FutureOr<bool> isEmptyPage(ResponseData responseData);

  FutureOr<ResponseData> onProcessResponseData(
      covariant ResponseData? previousResponseData, ResponseData responseData);
}

abstract class PaginationListServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends PaginationServiceBloc<PaginationServiceRequestedEvent,
        List<ResponseData>> {
  PaginationListServiceBloc({
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(eventTransformer: eventTransformer);

  @override
  List<ResponseData> _responseData = [];

  @override
  List<ResponseData> get responseData => _responseData;

  @override
  bool get isFirstLoad => responseData.isEmpty;

  @override
  FutureOr<void> onPreRequestReset() {
    _page = 0;
    _responseData = [];
    _isEmptyReturned = false;
  }

  @override
  FutureOr<bool> isEmptyPage(List<ResponseData> responseData) {
    return responseData.isEmpty;
  }

  @override
  FutureOr<List<ResponseData>> onProcessResponseData(
      List<ResponseData> previousResponseData,
      List<ResponseData> responseData) {
    return previousResponseData.toList()..addAll(responseData);
  }
}

abstract class PaginationObjectServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends PaginationServiceBloc<PaginationServiceRequestedEvent,
        ResponseData> {
  PaginationObjectServiceBloc({
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(eventTransformer: eventTransformer);

  @override
  ResponseData? _responseData;

  @override
  ResponseData? get responseData => _responseData;

  @override
  bool get isFirstLoad => responseData == null;

  @override
  FutureOr<void> onPreRequestReset() {
    _page = 0;
    _responseData = null;
    _isEmptyReturned = false;
  }
}
