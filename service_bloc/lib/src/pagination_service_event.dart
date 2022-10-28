part of 'pagination_service_bloc.dart';

@immutable
abstract class PaginationServiceRequested extends ServiceRequested {
  const PaginationServiceRequested();
}

@immutable
abstract class PaginationReloadServiceRequested
    extends PaginationServiceRequested {
  const PaginationReloadServiceRequested();
}
