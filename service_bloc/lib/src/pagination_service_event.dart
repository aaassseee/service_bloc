part of 'pagination_service_bloc.dart';

abstract class PaginationServiceRequested extends ServiceRequested {
  const PaginationServiceRequested();
}

abstract class PaginationReloadServiceRequested
    extends PaginationServiceRequested {
  const PaginationReloadServiceRequested();
}
