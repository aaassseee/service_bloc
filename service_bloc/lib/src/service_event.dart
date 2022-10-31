part of 'service_bloc.dart';

/// Base event for [ServiceBloc]. Every event which is used in [ServiceBloc] and
/// including extended [ServiceBloc] class must use this class as base event
/// class.
@immutable
abstract class ServiceEvent extends Equatable {
  const ServiceEvent();
}

/// Base request event for [ServiceBloc]. Every request event which is used in
/// [ServiceBloc] and including extended [ServiceBloc] class must use this class
/// as base request event class.
@immutable
abstract class ServiceRequested extends ServiceEvent {
  const ServiceRequested();
}
