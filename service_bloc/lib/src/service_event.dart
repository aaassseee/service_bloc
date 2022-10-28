part of 'service_bloc.dart';

@immutable
abstract class ServiceEvent extends Equatable {
  const ServiceEvent();
}

@immutable
abstract class ServiceRequested extends ServiceEvent {
  const ServiceRequested();
}
