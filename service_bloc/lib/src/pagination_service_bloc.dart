import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../service_bloc.dart';

part 'pagination_service_event.dart';

/// Base class for pagination service calling implement with bloc architecture.
///
/// Each [PaginationServiceBloc] should create a unique event class extending
/// [PaginationServiceRequested]
///
/// Each [PaginationServiceBloc] should only return a single base type as
/// response type.
abstract class PaginationServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends ServiceBloc<PaginationServiceRequestedEvent, ResponseData> {
  /// Constructor for creating [PaginationServiceBloc].
  ///
  /// Parameter [eventTransformer] can be used for handing complex concurrent
  /// event with different handling strategies.
  /// Check out [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)
  /// for more detail.
  PaginationServiceBloc({
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(eventTransformer: eventTransformer);

  /// Current or last called page number.
  int _page = 0;

  /// Getter for last called page number.
  int get page => _page;

  /// Merged response data, after request processed the latest response should
  /// be merge with previous response data.
  abstract covariant ResponseData? _responseData;

  /// Getter for merges response data.
  ResponseData? get responseData => _responseData;

  /// The no more data flag. Used for preventing requests when there is no data
  /// left.
  bool _isEmptyReturned = false;

  /// Getter for no more data flag.
  bool get isEmptyReturned => _isEmptyReturned;

  /// Function for implementation of first load flag. Used for displaying
  /// loading only when first load.
  bool get isFirstLoad;

  /// Function for handling pagination reset flow logic.
  @override
  @mustCallSuper
  FutureOr<void> onPreRequest(
      PaginationServiceRequestedEvent event, Emitter<ServiceState> emit) {
    if (event is PaginationReloadServiceRequested) {
      onPreRequestReset();
    }

    return super.onPreRequest(event, emit);
  }

  /// Function for implementation of resetting bloc fields when event is
  /// [PaginationReloadServiceRequested]
  FutureOr<void> onPreRequestReset();

  /// Function for handling pagination request flow logic.
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

  /// Function for implementation of handling event process. All request must be
  /// call or complete within this function.
  FutureOr<ResponseData> onPaginationRequest(
      PaginationServiceRequestedEvent event, int page);

  /// Function for implementation of determinate is empty page (aka. no more data)
  /// when [onPaginationRequest] receiving [ResponseData].
  FutureOr<bool> isEmptyPage(ResponseData responseData);

  /// Function for implementation of processing response data. All data merging
  /// must be implement within this function.
  FutureOr<ResponseData> onProcessResponseData(
      covariant ResponseData? previousResponseData, ResponseData responseData);
}

/// Base class for pagination list service calling implement with bloc
/// architecture.
///
/// Each [PaginationListServiceBloc] should create a unique event class
/// extending [PaginationServiceRequested]
///
/// Each [PaginationListServiceBloc] should only return list of single base type
/// as response type.
///
/// [ResponseData] should be a base type of list of response data.
/// [ResponseData] also should not be with any kind of [Iterable] because this
/// class already handled for you. Except your response try is nested list.
abstract class PaginationListServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends PaginationServiceBloc<PaginationServiceRequestedEvent,
        List<ResponseData>> {
  /// Constructor for creating [PaginationListServiceBloc].
  ///
  /// Parameter [eventTransformer] can be used for handing complex concurrent
  /// event with different handling strategies.
  /// Check out [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)
  /// for more detail.
  PaginationListServiceBloc({
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(eventTransformer: eventTransformer);

  /// Merges response data override with default empty list.
  @override
  List<ResponseData> _responseData = [];

  /// Getter for merges response data.
  @override
  List<ResponseData> get responseData => _responseData;

  /// The first load flag. Used for displaying loading only when first load.
  @override
  bool get isFirstLoad => responseData.isEmpty;

  /// Function for resetting bloc fields when event is
  /// [PaginationReloadServiceRequested]
  @override
  FutureOr<void> onPreRequestReset() {
    _page = 0;
    _responseData = [];
    _isEmptyReturned = false;
  }

  /// Function for determinate is empty page (aka. no more data)
  /// when [onPaginationRequest] receiving [ResponseData].
  @override
  FutureOr<bool> isEmptyPage(List<ResponseData> responseData) {
    return responseData.isEmpty;
  }

  /// Function for processing response data. All data merging must be implement
  /// within this function.
  @override
  FutureOr<List<ResponseData>> onProcessResponseData(
      List<ResponseData> previousResponseData,
      List<ResponseData> responseData) {
    return previousResponseData.toList()..addAll(responseData);
  }
}

/// (Rare special case)
/// Base class for pagination object service calling implement with bloc
/// architecture.
///
/// Each [PaginationObjectServiceBloc] should create a unique event class
/// extending [PaginationServiceRequested]
///
/// Each [PaginationObjectServiceBloc] should only return a single base type as
/// response type.
///
/// [ResponseData] should be an object holding two or more array
abstract class PaginationObjectServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends PaginationServiceBloc<PaginationServiceRequestedEvent,
        ResponseData> {
  /// Constructor for creating [PaginationObjectServiceBloc].
  ///
  /// Parameter [eventTransformer] can be used for handing complex concurrent
  /// event with different handling strategies.
  /// Check out [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)
  /// for more detail.
  PaginationObjectServiceBloc({
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(eventTransformer: eventTransformer);

  /// Merges response data override with default null.
  @override
  ResponseData? _responseData;

  /// Getter for merges response data.
  @override
  ResponseData? get responseData => _responseData;

  /// The first load flag. Used for displaying loading only when first load.
  @override
  bool get isFirstLoad => responseData == null;

  /// Function for processing response data. All data merging must be implement
  /// within this function.
  @override
  FutureOr<void> onPreRequestReset() {
    _page = 0;
    _responseData = null;
    _isEmptyReturned = false;
  }
}
