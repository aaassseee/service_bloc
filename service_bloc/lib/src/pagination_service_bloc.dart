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

  /// Merged response data, after request processed the latest response should
  /// be merge with previous response data.
  abstract covariant ResponseData? _mergedData;

  /// Getter for merged response data.
  ResponseData? get mergedData => _mergedData;

  /// Current or last called page number.
  int _page = 0;

  /// Getter for last called page number.
  int get page => _page;

  /// The no more data flag. Used for preventing requests when there is no data
  /// left.
  bool _hasNextPage = true;

  /// Getter for no more data flag.
  bool get hasNextPage => _hasNextPage;

  /// Function for implementation of first load flag. Used for displaying
  /// loading only when first load.
  bool _isFirstLoaded = true;

  /// Getter for first load flag.
  @visibleForTesting
  bool get isFirstLoad => _isFirstLoaded;

  /// Overrode [add] function from [Bloc]
  ///
  /// * A [StateError] will be thrown if non [PaginationReloadServiceRequested]
  /// events is getting added when [_hasNextPage] is false.
  @override
  void add(PaginationServiceRequestedEvent event) {
    if (event is! PaginationReloadServiceRequested && !_hasNextPage) {
      final eventType = event.runtimeType;
      throw StateError(
        '''add($eventType) was called when hasNextPage is false.\n'''
        '''Make sure to request next page when hasNextPage is true''',
      );
    }

    super.add(event);
  }

  /// Function for handling pagination reset flow logic.
  @override
  @mustCallSuper
  FutureOr<void> onPreRequest(
      PaginationServiceRequestedEvent event, Emitter<ServiceState> emit) async {
    if (event is PaginationReloadServiceRequested) {
      onPreRequestResetData();
    } else {
      if (!_isFirstLoaded) {
        _page = updateNextPageNumber(_page, _mergedData);
      }
    }

    return super.onPreRequest(event, emit);
  }

  /// Function for implementation of resetting bloc fields when event is
  /// [PaginationReloadServiceRequested]
  FutureOr<void> onPreRequestResetData();

  /// Function for implementation of updating next page number. All page update
  /// must be implement within this function.
  int updateNextPageNumber(
      int previousPageNumber, covariant ResponseData? responseData);

  /// Function for handling pagination request flow logic.
  @override
  @protected
  FutureOr<void> onRequest(
      PaginationServiceRequestedEvent event, Emitter<ServiceState> emit) async {
    try {
      final responseData = await onPaginationRequest(event, page);
      _isFirstLoaded = false;
      _hasNextPage = await updateHasNextPage(responseData);

      final mergedData = await onMergingResponseData(_mergedData, responseData);
      _mergedData = mergedData;

      emit(ServiceLoadSuccess<PaginationServiceRequestedEvent, ResponseData>(
          event: event, data: mergedData));
    } catch (error) {
      emit(ServiceLoadFailure<PaginationServiceRequestedEvent>(
          event: event, error: error));
    }
  }

  /// Function for implementation of handling event process. All request must be
  /// call or complete within this function.
  FutureOr<ResponseData> onPaginationRequest(
      PaginationServiceRequestedEvent event, int page);

  /// Function for implementation of determinate has next page when
  /// [onPaginationRequest] receiving [ResponseData].
  FutureOr<bool> updateHasNextPage(ResponseData responseData);

  /// Function for implementation of merging response data. All data merging
  /// must be implement within this function.
  FutureOr<ResponseData> onMergingResponseData(
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

  /// Merged response data override with default empty list.
  @override
  List<ResponseData> _mergedData = [];

  /// Getter for merged response data.
  @override
  List<ResponseData> get mergedData => _mergedData;

  /// Function for resetting bloc fields when event is
  /// [PaginationReloadServiceRequested]
  @override
  @mustCallSuper
  FutureOr<void> onPreRequestResetData() {
    _page = 0;
    _mergedData = [];
    _hasNextPage = true;
    _isFirstLoaded = true;
  }

  @override
  int updateNextPageNumber(
      int previousPageNumber, List<ResponseData> responseData) {
    return previousPageNumber + 1;
  }

  /// Function for determinate has next page when [onPaginationRequest]
  /// receiving [ResponseData].
  @override
  FutureOr<bool> updateHasNextPage(List<ResponseData> responseData) {
    return responseData.isNotEmpty;
  }

  /// Function for processing response data. All data merging must be implement
  /// within this function.
  @override
  FutureOr<List<ResponseData>> onMergingResponseData(
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

  /// Merged response data override with default null.
  @override
  ResponseData? _mergedData;

  /// Getter for merged response data.
  @override
  ResponseData? get mergedData => _mergedData;

  /// Function for processing response data. All data merging must be implement
  /// within this function.
  @override
  @mustCallSuper
  FutureOr<void> onPreRequestResetData() {
    _page = 0;
    _mergedData = null;
    _hasNextPage = true;
    _isFirstLoaded = true;
  }

  @override
  int updateNextPageNumber(
      int previousPageNumber, covariant ResponseData? responseData) {
    return previousPageNumber + 1;
  }
}
