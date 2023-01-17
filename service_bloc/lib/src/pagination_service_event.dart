part of 'pagination_service_bloc.dart';

/// Base event for [PaginationServiceBloc]. Every event which is used in
/// [PaginationServiceBloc] and including extended [PaginationServiceBloc] class
/// must use this class as base event class.
@immutable
abstract class PaginationServiceRequested extends ServiceRequested {
  const PaginationServiceRequested();
}

/// mixin class for only [PaginationServiceRequested] which allows
/// [PaginationServiceRequested] having a reload action before service request.
mixin PaginationReload on PaginationServiceRequested {}
