import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../service_bloc.dart';

part 'pagination_service_event.dart';

/// Base class for pagination service implement with bloc architecture.
///
/// Each [PaginationServiceBloc] should create a unique event class extending
/// [PaginationServiceRequested]
///
/// Each [PaginationServiceBloc] should only return a single base type as
/// response type.
abstract class PaginationServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData,
        PageType>
    extends ServiceBloc<PaginationServiceRequestedEvent, ResponseData> {
  /// Constructor for creating [PaginationServiceBloc].
  ///
  /// Parameter [eventTransformer] can be used for handing complex concurrent
  /// event with different handling strategies.
  /// Check out [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)
  /// for more detail.
  PaginationServiceBloc({
    required PageType initialPage,
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  })  : _page = initialPage,
        super(eventTransformer: eventTransformer);

  /// Current page number / id for pagination service.
  PageType _page;

  /// Getter for current page number / id.
  PageType get page => _page;

  /// Has next page boolean flag which is useful for preventing requests when
  /// there are no data left on server.
  bool _hasNextPage = true;

  /// Getter for has next page boolean flag.
  bool get hasNextPage => _hasNextPage;

  /// Merged response data which is used for storing all response data. Every
  /// page response data should be merged with [_mergedData] within
  /// [onMergingResponseData].
  abstract covariant ResponseData? _mergedData;

  /// Getter for merged response data.
  ResponseData? get mergedData => _mergedData;

  /// Is first loaded boolean flag which is useful for page incrementation when
  /// [PaginationServiceRequested] is added.
  bool _isFirstLoaded = true;

  /// Getter for is first loaded boolean flag
  @visibleForTesting
  bool get isFirstLoaded => _isFirstLoaded;

  /// Overrode [add] function from [Bloc] to prevent
  ///
  /// * A [StateError] will be thrown if non [PaginationReloadServiceRequested]
  /// events is getting added when [_hasNextPage] is false.
  @override
  void add(PaginationServiceRequestedEvent event) {
    // if request is not a reload request and there is no more data in server.
    if (event is! PaginationReload && !_hasNextPage) {
      final eventType = event.runtimeType;
      throw StateError(
        '''add($eventType) was called when hasNextPage is false.\n'''
        '''Make sure to request next page when hasNextPage is true''',
      );
    }

    super.add(event);
  }

  /// Function for handling reset data or page increment before request.
  @override
  @mustCallSuper
  FutureOr<void> onPreRequest(
      PaginationServiceRequestedEvent event, Emitter<ServiceState> emit) async {
    if (event is PaginationReload) {
      onReloadReset();
    } else {
      if (!_isFirstLoaded) {
        _page = incrementPageNumber(_page, _mergedData);
      }
    }

    return super.onPreRequest(event, emit);
  }

  /// Function for implementation of resetting bloc fields when event is
  /// [PaginationReloadServiceRequested]
  @mustCallSuper
  FutureOr<void> onReloadReset() {
    _page = onReloadResetPageNumber();
    _mergedData = onReloadResetData();
    _hasNextPage = true;
    _isFirstLoaded = true;
  }

  /// Function for implementation of resetting [_page] when event is
  /// [PaginationReloadServiceRequested].
  PageType onReloadResetPageNumber();

  /// Function for implementation of resetting [_mergedData] when event is
  /// [PaginationReloadServiceRequested]
  ResponseData? onReloadResetData();

  /// Function for implementation of increment page number before second
  /// request. Page increment must be done within this function.
  PageType incrementPageNumber(
      PageType previousPage, covariant ResponseData? responseData);

  /// Function for handling pagination request.
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
      PaginationServiceRequestedEvent event, PageType page);

  /// Function for implementation of determinate has next page when
  /// [onPaginationRequest] receiving [ResponseData].
  FutureOr<bool> updateHasNextPage(ResponseData responseData);

  /// Function for implementation of merging response data. All data merging
  /// must be done within this function.
  FutureOr<ResponseData> onMergingResponseData(
      covariant ResponseData? previousResponseData, ResponseData responseData);
}

/// Base class for pagination list service implement with bloc architecture.
///
/// Each [PaginationListServiceBloc] should create a unique event class
/// extending [PaginationServiceRequested]
///
/// Each [PaginationListServiceBloc] should only return list of single base type
/// as response type.
///
/// [ResponseData] should be the base type of a list of response data.
///
/// [ResponseData] should also not be any kind of [Iterable] because this
/// class already handled for you. Except your response is a nested list.
abstract class PaginationListServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData,
        PageType>
    extends PaginationServiceBloc<PaginationServiceRequestedEvent,
        List<ResponseData>, PageType> {
  /// Constructor for creating [PaginationListServiceBloc].
  ///
  /// Parameter [eventTransformer] can be used for handing complex concurrent
  /// event with different handling strategies.
  /// Check out [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)
  /// for more detail.
  PaginationListServiceBloc({
    required PageType initialPage,
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(initialPage: initialPage, eventTransformer: eventTransformer);

  /// Merged response data override with default empty list.
  @override
  List<ResponseData> _mergedData = [];

  /// Getter for merged response data.
  @override
  List<ResponseData> get mergedData => _mergedData;

  /// Function for resetting [_mergedData] when event is
  /// [PaginationReloadServiceRequested]
  @override
  List<ResponseData> onReloadResetData() => [];

  /// Function for determinate has next page when [onPaginationRequest]
  /// receiving [ResponseData].
  @override
  FutureOr<bool> updateHasNextPage(List<ResponseData> responseData) {
    return responseData.isNotEmpty;
  }

  /// Function for processing response data. All data merging must be done
  /// within this function.
  @override
  FutureOr<List<ResponseData>> onMergingResponseData(
      List<ResponseData> previousResponseData,
      List<ResponseData> responseData) {
    return previousResponseData.toList()..addAll(responseData);
  }
}

/// (Rare case)
/// Base class for pagination object service implement with bloc architecture.
///
/// Each [PaginationObjectServiceBloc] should create a unique event class
/// extending [PaginationServiceRequested]
///
/// Each [PaginationObjectServiceBloc] should only return a single base type as
/// response type.
///
/// [ResponseData] should be an object holding two or more array data.
abstract class PaginationObjectServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData,
        PageType>
    extends PaginationServiceBloc<PaginationServiceRequestedEvent, ResponseData,
        PageType> {
  /// Constructor for creating [PaginationObjectServiceBloc].
  ///
  /// Parameter [eventTransformer] can be used for handing complex concurrent
  /// event with different handling strategies.
  /// Check out [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)
  /// for more detail.
  PaginationObjectServiceBloc({
    required PageType initialPage,
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(initialPage: initialPage, eventTransformer: eventTransformer);

  /// Merged response data override with default null.
  @override
  ResponseData? _mergedData;

  /// Function for resetting [_mergedData] when event is
  /// [PaginationReloadServiceRequested]
  @override
  ResponseData? onReloadResetData() => null;
}

/// Base class for number based pagination list service implement with bloc
/// architecture.
///
/// Each [NumberBasedPaginationListServiceBloc] should create a unique event
/// class extending [PaginationServiceRequested]
///
/// Each [NumberBasedPaginationListServiceBloc] should only return list of
/// single base type as response type.
///
/// [ResponseData] should be the base type of a list of response data.
///
/// [ResponseData] should also not be any kind of [Iterable] because this
/// class already handled for you. Except your response is a nested list.
abstract class NumberBasedPaginationListServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends PaginationListServiceBloc<PaginationServiceRequestedEvent,
        ResponseData, num> {
  /// Constructor for creating [NumberBasedPaginationListServiceBloc].
  ///
  /// Parameter [eventTransformer] can be used for handing complex concurrent
  /// event with different handling strategies.
  /// Check out [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)
  /// for more detail.
  NumberBasedPaginationListServiceBloc({
    num initialPage = 0,
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(initialPage: initialPage, eventTransformer: eventTransformer);

  /// Function for resetting [_page] when event is
  /// [PaginationReloadServiceRequested].
  @override
  num onReloadResetPageNumber() => 0;
}

/// Base class for number based pagination object service implement with bloc
/// architecture.
///
/// Each [NumberBasedPaginationObjectServiceBloc] should create a unique event
/// class extending [PaginationServiceRequested]
///
/// Each [NumberBasedPaginationObjectServiceBloc] should only return a single
/// base type as response type.
///
/// [ResponseData] should be an object holding two or more array data.
abstract class NumberBasedPaginationObjectServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends PaginationObjectServiceBloc<PaginationServiceRequestedEvent,
        ResponseData, num> {
  /// Constructor for creating [NumberBasedPaginationObjectServiceBloc].
  ///
  /// Parameter [eventTransformer] can be used for handing complex concurrent
  /// event with different handling strategies.
  /// Check out [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)
  /// for more detail.
  NumberBasedPaginationObjectServiceBloc({
    num initialPage = 0,
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(initialPage: initialPage, eventTransformer: eventTransformer);

  /// Function for resetting [_page] when event is
  /// [PaginationReloadServiceRequested].
  @override
  num onReloadResetPageNumber() => 0;
}

/// Base class for page based pagination list service implement with bloc
/// architecture.
///
/// Each [PageBasedPaginationListServiceBloc] should create a unique event class
/// extending [PaginationServiceRequested]
///
/// Each [PageBasedPaginationListServiceBloc] should only return list of single
/// base type as response type.
///
/// [ResponseData] should be the base type of a list of response data.
///
/// [ResponseData] should also not be any kind of [Iterable] because this
/// class already handled for you. Except your response is a nested list.
abstract class PageBasedPaginationListServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends NumberBasedPaginationListServiceBloc<
        PaginationServiceRequestedEvent, ResponseData> {
  /// Constructor for creating [PageBasedPaginationListServiceBloc].
  ///
  /// Parameter [eventTransformer] can be used for handing complex concurrent
  /// event with different handling strategies.
  /// Check out [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)
  /// for more detail.
  PageBasedPaginationListServiceBloc({
    int initialPage = 0,
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(initialPage: initialPage, eventTransformer: eventTransformer);

  /// Function for increment page number before second request. Page increment
  /// must be done within this function.
  @override
  num incrementPageNumber(
      num previousPage, covariant List<ResponseData>? responseData) {
    return previousPage + 1;
  }
}

/// Base class for page based pagination object service implement with bloc
/// architecture.
///
/// Each [PageBasedPaginationObjectServiceBloc] should create a unique event
/// class extending [PaginationServiceRequested]
///
/// Each [PageBasedPaginationObjectServiceBloc] should only return a single base
/// type as response type.
///
/// [ResponseData] should be an object holding two or more array data.
abstract class PageBasedPaginationObjectServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends NumberBasedPaginationObjectServiceBloc<
        PaginationServiceRequestedEvent, ResponseData> {
  /// Constructor for creating [PageBasedPaginationObjectServiceBloc].
  ///
  /// Parameter [eventTransformer] can be used for handing complex concurrent
  /// event with different handling strategies.
  /// Check out [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)
  /// for more detail.
  PageBasedPaginationObjectServiceBloc({
    num initialPage = 0,
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(initialPage: initialPage, eventTransformer: eventTransformer);

  /// Function for increment page number before second request. Page increment
  /// must be done within this function.
  @override
  num incrementPageNumber(
      num previousPage, covariant ResponseData? responseData) {
    return previousPage + 1;
  }
}

/// Base class for cursor based pagination list service implement with bloc
/// architecture.
///
/// Each [CursorBasedPaginationListServiceBloc] should create a unique event
/// class extending [PaginationServiceRequested]
///
/// Each [CursorBasedPaginationListServiceBloc] should only return list of
/// single base type as response type.
///
/// [ResponseData] should be the base type of a list of response data.
///
/// [ResponseData] should also not be any kind of [Iterable] because this
/// class already handled for you. Except your response is a nested list.
abstract class CursorBasedPaginationListServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends PaginationListServiceBloc<PaginationServiceRequestedEvent,
        ResponseData, String?> {
  /// Constructor for creating [CursorBasedPaginationListServiceBloc].
  ///
  /// Parameter [eventTransformer] can be used for handing complex concurrent
  /// event with different handling strategies.
  /// Check out [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)
  /// for more detail.
  CursorBasedPaginationListServiceBloc({
    String? initialPage,
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(initialPage: initialPage, eventTransformer: eventTransformer);

  /// Function for resetting [_page] when event is
  /// [PaginationReloadServiceRequested].
  @override
  String? onReloadResetPageNumber() => null;
}

/// Base class for cursor base pagination object service implement with bloc
/// architecture.
///
/// Each [CursorBasedPaginationObjectServiceBloc] should create a unique event
/// class extending [PaginationServiceRequested]
///
/// Each [CursorBasedPaginationObjectServiceBloc] should only return a single
/// base type as response type.
///
/// [ResponseData] should be an object holding two or more array data.
abstract class CursorBasedPaginationObjectServiceBloc<
        PaginationServiceRequestedEvent extends PaginationServiceRequested,
        ResponseData>
    extends PaginationObjectServiceBloc<PaginationServiceRequestedEvent,
        ResponseData, String?> {
  /// Constructor for creating [CursorBasedPaginationObjectServiceBloc].
  ///
  /// Parameter [eventTransformer] can be used for handing complex concurrent
  /// event with different handling strategies.
  /// Check out [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)
  /// for more detail.
  CursorBasedPaginationObjectServiceBloc({
    String? initialPage,
    EventTransformer<PaginationServiceRequestedEvent>? eventTransformer,
  }) : super(initialPage: initialPage, eventTransformer: eventTransformer);

  /// Function for resetting [_page] when event is
  /// [PaginationReloadServiceRequested].
  @override
  String? onReloadResetPageNumber() => null;
}
