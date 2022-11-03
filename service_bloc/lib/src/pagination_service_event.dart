part of 'pagination_service_bloc.dart';

/// Base event for [PaginationServiceBloc]. Every event which is used in
/// [PaginationServiceBloc] and including extended [PaginationServiceBloc] class
/// must use this class as base event class.
@immutable
abstract class PaginationServiceRequested extends ServiceRequested {
  const PaginationServiceRequested();
}

/// Base reload event for [PaginationServiceBloc]. Every reload event which is
/// used in [PaginationServiceBloc] and including extended
/// [PaginationServiceBloc] class must use this class as base event class.
@immutable
abstract class PaginationReloadServiceRequested
    extends PaginationServiceRequested {
  const PaginationReloadServiceRequested();
}
