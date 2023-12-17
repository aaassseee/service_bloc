import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../service_bloc.dart';

part 'pagination_service_event.dart';

/// Type define function for increase page.
typedef PageIncrement<PageType, ResponseData> = PageType Function(
    PageType previousPage, ResponseData responseData);

/// Type define function for rest page.
typedef PageReset<PageType> = PageType Function();

/// Type define function for update has next page boolean.
typedef PageUpdateHasNextPage<ResponseData> = bool Function(
    ResponseData responseData);

/// Base pagination class implemented with delegate class style. [Pagination]
/// handles all page modification.
abstract class Pagination<PageType, ResponseData> {
  /// Constructor for creating a [Pagination]
  ///
  /// {@template pagination_constructor}
  /// [initialPage] used when first [PaginationServiceRequested] or
  /// [_reloadResetPage] before request when [PaginationServiceRequested] with
  /// [PaginationReload].
  ///
  /// [onIncreasePage] handles next page increment when
  /// [PaginationServiceRequested] without [PaginationReload] is added after first
  /// call.
  ///
  /// [onReloadResetPage] handles reset page when [PaginationServiceRequested] with
  /// [PaginationReload] is added.
  ///
  /// [onUpdateHasNextPage] handles updating is pagination still have data left
  /// after each [PaginationServiceRequested] is completed.
  /// {@endtemplate}
  Pagination({
    required PageType initialPage,
    required this.onIncreasePage,
    required this.onReloadResetPage,
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

  /// Injection function for implementing page increment.
  final PageIncrement<PageType, ResponseData> onIncreasePage;

  /// Injection function for implementing reload page reset.
  final PageReset<PageType> onReloadResetPage;

  /// Injection function for implementing update has next page.
  final PageUpdateHasNextPage<ResponseData> onUpdateHasNextPage;

  /// Private function for internal use when [PaginationServiceBloc.onPreRequest]
  /// second service call.
  void _pageIncrement(ResponseData responseData) {
    _page = onIncreasePage(page, responseData);
  }

  /// Private function for reset page data when [PaginationServiceBloc] with
  /// [PaginationReload].
  void _onReloadReset() {
    _reloadResetPage();
    _hasNextPage = true;
  }

  /// Private function for reset page when [_onReloadReset] is called.
  void _reloadResetPage() {
    _page = onReloadResetPage();
  }

  /// Private function for update has next page when request is completed.
  void _updateHasNextPage(ResponseData responseData) {
    _hasNextPage = onUpdateHasNextPage(responseData);
  }
}

/// Number based pagination class implemented with delegate class style.
/// [NumberBasedPagination] handles all number based page modification.
class NumberBasedPagination<ResponseData>
    extends Pagination<num, ResponseData> {
  /// Constructor for creating a [NumberBasedPagination]
  ///
  /// {@macro pagination_constructor}
  NumberBasedPagination({
    super.initialPage = 0,
    PageIncrement<num, ResponseData>? onIncreasePage,
    PageReset<num>? onResetPage,
    required super.onUpdateHasNextPage,
  }) : super(
          onIncreasePage: onIncreasePage ??
              (previousPage, responseData) => previousPage + 1,
          onReloadResetPage: onResetPage ?? () => 0,
        );
}

/// Cursor based pagination class implemented with delegate class style.
/// [CursorBasedPagination] handles all cursor based page modification.
class CursorBasedPagination<ResponseData>
    extends Pagination<String?, ResponseData> {
  /// Constructor for creating a [CursorBasedPagination]
  ///
  /// {@macro pagination_constructor}
  CursorBasedPagination({
    super.initialPage,
    required super.onIncreasePage,
    PageReset<String?>? onResetPage,
    required super.onUpdateHasNextPage,
  }) : super(onReloadResetPage: onResetPage ?? () => null);
}

/// Type define function for migrate pagination response data.
typedef PaginationResponseDataMigration<ResponseData> = FutureOr<ResponseData>
    Function(ResponseData previousResponseData, ResponseData responseData);

/// Type define function for reset pagination response data.
typedef PaginationResponseDataReset<ResponseData> = FutureOr<ResponseData>
    Function();

/// Base pagination response data holder and processor.
/// [PaginationResponseData] handles storing data and process data.
abstract class PaginationResponseData<ResponseData> {
  /// Constructor for creating pagination response data.
  ///
  /// {@template pagination_response_data_constructor}
  /// [initialData] used when initial or [_reloadResetResponseData]
  /// before request when [PaginationServiceRequested] with [PaginationReload].
  ///
  /// [onMergingResponseData] handles data migration when any request complete
  /// without error.
  ///
  /// [onReloadResetResponseData] handles reset response data when
  /// [PaginationServiceRequested] with [PaginationReload] is added.
  /// {@endtemplate}
  PaginationResponseData({
    required ResponseData initialData,
    required this.onMergingResponseData,
    PaginationResponseDataReset? onReloadResetResponseData,
  })  : _initialData = initialData,
        _mergedData = initialData,
        onReloadResetResponseData = (onReloadResetResponseData ??
            () => initialData) as ResponseData Function();

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

  /// Function for implementation of merging response data. All data merging
  /// must be done within this function.
  final PaginationResponseDataMigration<ResponseData> onMergingResponseData;

  /// Function for implementation of resetting [_mergedData] when event is
  /// [PaginationReloadServiceRequested]
  final PaginationResponseDataReset<ResponseData> onReloadResetResponseData;

  /// Function for merging response data. All data merging must be done within
  /// this function.
  FutureOr<void> _mergeResponseData(ResponseData responseData) async {
    _mergedData = await onMergingResponseData(_mergedData, responseData);
  }

  /// Function for resetting [_mergedData] when event is
  /// [PaginationReloadServiceRequested]
  FutureOr<void> _reloadResetResponseData() async {
    _mergedData = await onReloadResetResponseData();
  }
}

/// List pagination response data holder and processor.
/// [PaginationListResponseData] handles storing list response data and process
/// list response data.
class PaginationListResponseData<ResponseData>
    extends PaginationResponseData<List<ResponseData>> {
  /// Constructor for creating list pagination response data.
  ///
  /// {@macro pagination_response_data_constructor}
  PaginationListResponseData({
    super.initialData = const [],
    PaginationResponseDataMigration<List<ResponseData>>? onMergingResponseData,
    super.onReloadResetResponseData,
  }) : super(
            onMergingResponseData: onMergingResponseData ??
                (previousResponseData, responseData) =>
                    previousResponseData.cast<ResponseData>().toList()
                      ..addAll(responseData));
}

/// Object pagination response data holder and processor.
/// [PaginationObjectResponseData] handles storing object response data and
/// process object response data.
class PaginationObjectResponseData<ResponseData>
    extends PaginationResponseData<ResponseData> {
  /// Constructor for creating object pagination response data.
  ///
  /// {@macro pagination_response_data_constructor}
  PaginationObjectResponseData({
    required super.initialData,
    required super.onMergingResponseData,
    super.onReloadResetResponseData,
  });
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
    required PaginationResponseData<ResponseData> paginationResponseData,
    super.eventTransformer,
  })  : _pagination = pagination,
        _paginationResponseData = paginationResponseData;

  /// Pagination which is used to handle page store, modify and reset.
  final Pagination<PageType, ResponseData> _pagination;

  /// Getter for pagination.
  Pagination<PageType, ResponseData> get pagination => _pagination;

  /// Pagination response data which is used to handle response data
  /// store, migration and reset.
  final PaginationResponseData<ResponseData> _paginationResponseData;

  /// Getter for pagination response data.
  PaginationResponseData<ResponseData> get paginationResponseData =>
      _paginationResponseData;

  /// Is first loaded boolean flag which is useful for page incrementation when
  /// [PaginationServiceRequested] is added.
  bool _isFirstLoaded = true;

  /// Getter for is first loaded boolean flag
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
        _pagination._pageIncrement(_paginationResponseData.mergedData);
      }
    }

    return super.onPreRequest(event, emit);
  }

  /// Function for implementation of resetting bloc fields when event is
  /// [PaginationReloadServiceRequested]
  @mustCallSuper
  FutureOr<void> onReloadReset() {
    _pagination._onReloadReset();
    _paginationResponseData._reloadResetResponseData();
    _isFirstLoaded = true;
  }

  /// Function for handling pagination request.
  @override
  @protected
  FutureOr<void> onRequest(
      PaginationServiceRequestedEvent event, Emitter<ServiceState> emit) async {
    try {
      final responseData = await onPaginationRequest(event, _pagination.page);
      _isFirstLoaded = false;
      _pagination._updateHasNextPage(responseData);

      await _paginationResponseData._mergeResponseData(responseData);

      emit(ServiceLoadSuccess<PaginationServiceRequestedEvent, ResponseData>(
          event: event, data: _paginationResponseData.mergedData));
    } catch (error) {
      emit(ServiceLoadFailure<PaginationServiceRequestedEvent>(
          event: event, error: error));
    }
  }

  /// Function for implementation of handling event process. All request must be
  /// call or complete within this function.
  FutureOr<ResponseData> onPaginationRequest(
      PaginationServiceRequestedEvent event, PageType page);
}
