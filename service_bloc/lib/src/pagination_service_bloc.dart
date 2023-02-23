import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../service_bloc.dart';

part 'pagination_service_event.dart';

/// Type define function for page increment
typedef PageIncrement<PageType, ResponseData> = PageType Function(
    PageType previousPage, ResponseData responseData);

/// Type define function for page reset
typedef PageReset<PageType> = PageType Function();

/// Type define function for page reset
typedef PageUpdateHasNextPage<ResponseData> = bool Function(
    ResponseData responseData);

/// Base pagination class implemented with delegate structure
abstract class Pagination<PageType, ResponseData> {
  Pagination({
    required PageType initialPage,
    required this.onIncreasePage,
    required this.onResetPage,
    required this.onUpdateHasNextPage,
  })  : _initialPage = initialPage,
        _page = initialPage;

  /// Initial page number / id for pagination service.
  final PageType _initialPage;

  /// Getter for initial page number / id.
  PageType get initialPage => _initialPage;

  /// Current page number / id for pagination service.
  PageType _page;

  /// Getter for current page number / id.
  PageType get page => _page;

  /// Has next page boolean flag which is useful for preventing requests when
  /// there are no data left on server.
  bool _hasNextPage = true;

  /// Getter for has next page boolean flag.
  bool get hasNextPage => _hasNextPage;

  final PageIncrement<PageType, ResponseData> onIncreasePage;

  final PageReset<PageType> onResetPage;

  final PageUpdateHasNextPage<ResponseData> onUpdateHasNextPage;

  void _pageIncrement(ResponseData responseData) {
    _page = onIncreasePage(_page, responseData);
  }

  void _onReloadReset() {
    _resetPage();
    _hasNextPage = true;
  }

  void _resetPage() {
    _page = onResetPage();
  }

  void _updateHasNextPage(ResponseData responseData) {
    _hasNextPage = onUpdateHasNextPage(responseData);
  }
}

class NumberBasedPagination<ResponseData>
    extends Pagination<num, ResponseData> {
  NumberBasedPagination({
    super.initialPage = 0,
    PageIncrement<num, ResponseData>? onIncreasePage,
    PageReset<num>? onResetPage,
    required super.onUpdateHasNextPage,
  }) : super(
          onIncreasePage: onIncreasePage ??
              (previousPage, responseData) => previousPage + 1,
          onResetPage: onResetPage ?? () => 0,
        );
}

class CursorBasedPagination<ResponseData>
    extends Pagination<String?, ResponseData> {
  CursorBasedPagination({
    super.initialPage,
    required super.onIncreasePage,
    PageReset<String?>? onResetPage,
    required super.onUpdateHasNextPage,
  }) : super(onResetPage: onResetPage ?? () => null);
}

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
    required Pagination<PageType, ResponseData> pagination,
    required ResponseData initialData,
    super.eventTransformer,
  })  : _pagination = pagination,
        _initialData = initialData,
        _mergedData = initialData;

  /// Pagination
  final Pagination<PageType, ResponseData> _pagination;

  Pagination<PageType, ResponseData> get pagination => _pagination;

  /// Initial response data which is used for resetting the [_mergedData].
  final ResponseData _initialData;

  /// Getter for initial response data.
  ResponseData get initialData => _initialData;

  /// Merged response data which is used for storing all response data. Every
  /// page response data should be merged with [_mergedData] within
  /// [onMergingResponseData].
  ResponseData _mergedData;

  /// Getter for merged response data.
  ResponseData get mergedData => _mergedData;

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
    if (event is! PaginationReload && !_pagination.hasNextPage) {
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
        _pagination._pageIncrement(_mergedData);
      }
    }

    return super.onPreRequest(event, emit);
  }

  /// Function for implementation of resetting bloc fields when event is
  /// [PaginationReloadServiceRequested]
  @mustCallSuper
  FutureOr<void> onReloadReset() {
    _pagination._onReloadReset();
    _mergedData = onReloadResetData();
    _isFirstLoaded = true;
  }

  /// Function for implementation of resetting [_mergedData] when event is
  /// [PaginationReloadServiceRequested]
  ResponseData onReloadResetData() => initialData;

  /// Function for handling pagination request.
  @override
  @protected
  FutureOr<void> onRequest(
      PaginationServiceRequestedEvent event, Emitter<ServiceState> emit) async {
    try {
      final responseData = await onPaginationRequest(event, _pagination.page);
      _isFirstLoaded = false;
      _pagination._updateHasNextPage(responseData);

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

  /// Function for implementation of merging response data. All data merging
  /// must be done within this function.
  FutureOr<ResponseData> onMergingResponseData(
      ResponseData previousResponseData, ResponseData responseData);
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
    required super.pagination,
    super.initialData = const [],
    super.eventTransformer,
  });

  /// Function for processing response data. All data merging must be done
  /// within this function.
  @override
  FutureOr<List<ResponseData>> onMergingResponseData(
      List<ResponseData> previousResponseData,
      List<ResponseData> responseData) {
    return previousResponseData.cast<ResponseData>().toList()
      ..addAll(responseData);
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
    required super.pagination,
    required super.initialData,
    super.eventTransformer,
  });
}
