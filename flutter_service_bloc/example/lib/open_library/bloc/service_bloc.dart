import 'dart:async';

import 'package:example/open_library/modal/modal.dart';
import 'package:example/open_library/repository/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_service_bloc/flutter_service_bloc.dart';

class OpenLibraryAuthorSearchServiceRequested
    extends PaginationServiceRequested {
  const OpenLibraryAuthorSearchServiceRequested(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [
        keyword,
      ];
}

class OpenLibraryAuthorSearchReloadServiceRequested
    extends OpenLibraryAuthorSearchServiceRequested with PaginationReload {
  const OpenLibraryAuthorSearchReloadServiceRequested(super.keyword);
}

class OpenLibraryAuthorSearchServiceBloc extends PaginationServiceBloc<
    OpenLibraryAuthorSearchServiceRequested,
    List<OpenLibraryAuthorSearchResult>,
    num> {
  OpenLibraryAuthorSearchServiceBloc(this.repository)
      : super(
          pagination: NumberBasedPagination(
            onUpdateHasNextPage: (responseData) => responseData.isNotEmpty,
          ),
          paginationResponseData: PaginationListResponseData(),
        );

  final OpenLibraryRepository repository;

  @override
  FutureOr<List<OpenLibraryAuthorSearchResult>> onPaginationRequest(
      OpenLibraryAuthorSearchServiceRequested event, num page) async {
    final response = await repository.searchAuthor(
        keyword: event.keyword, pageNo: page.toInt());
    return response.toList();
  }
}

class OpenLibraryAuthorDetailServiceRequested extends ServiceRequested {
  const OpenLibraryAuthorDetailServiceRequested(this.authorKey);

  final String authorKey;

  @override
  List<Object?> get props => [authorKey];
}

class OpenLibraryAuthorDetailServiceBloc extends ServiceBloc<
    OpenLibraryAuthorDetailServiceRequested, OpenLibraryAuthorDetail> {
  OpenLibraryAuthorDetailServiceBloc(this.repository);

  final OpenLibraryRepository repository;

  @override
  FutureOr<void> onRequest(OpenLibraryAuthorDetailServiceRequested event,
      Emitter<ServiceState> emit) async {
    try {
      final response =
          await repository.fetchAuthorDetail(authorKey: event.authorKey);
      emit(ServiceLoadSuccess(event: event, data: response));
    } catch (error) {
      emit(ServiceLoadFailure(event: event, error: error));
    }
  }
}
