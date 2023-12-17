import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_bloc/service_bloc.dart';

/// [ServiceBlocBuilder] handles building a widget in response to relative state.
///
/// If parameter [buildWhen] is omitted, default [buildWhen] will only return true
/// when certain parameter is set. For example [onInitial] [onLoading] [onFailure].
/// [onSuccess] is a required parameter so [buildWhen] will always return true if
/// state is [ServiceLoadSuccess]
class ServiceBlocBuilder<
    Bloc extends ServiceBloc<ServiceRequestedEvent, ResponseData>,
    ServiceRequestedEvent extends ServiceRequested,
    ResponseData> extends BlocBuilder<Bloc, ServiceState> {
  /// A constructor for creating a [ServiceBlocBuilder] with predefined state
  /// widget builder.
  ServiceBlocBuilder({
    super.key,
    super.bloc,
    BlocBuilderCondition? buildWhen,
    this.onInitial,
    this.onLoading,
    required this.onSuccess,
    this.onFailure,
    this.fallback = const SizedBox(),
  }) : super(
          buildWhen: buildWhen ??
              (previous, current) => switch (current) {
                    ServiceInitial() => onInitial != null,
                    ServiceLoadInProgress<ServiceRequestedEvent>() =>
                      onLoading != null,
                    ServiceLoadSuccess<ServiceRequestedEvent, ResponseData>() =>
                      true,
                    ServiceLoadFailure<ServiceRequestedEvent>() =>
                      onFailure != null,
                    _ => false
                  },
          builder: (context, state) => switch (state) {
            ServiceInitial() when onInitial != null =>
              onInitial(context, state),
            ServiceLoadInProgress<ServiceRequestedEvent>()
                when onLoading != null =>
              onLoading(context, state, state.event),
            ServiceLoadSuccess<ServiceRequestedEvent, ResponseData>(
              event: _,
              data: final data
            )
                when data != null =>
              onSuccess(context, state, state.event, data),
            ServiceLoadFailure<ServiceRequestedEvent>()
                when onFailure != null =>
              onFailure(context, state, state.event, state.error),
            _ => fallback,
          },
        );

  /// A widget builder which is only called when build on first time or
  /// [buildWhen] is omitted or custom [buildWhen] is passed and [onInitial] is
  /// not omitted and current state is [ServiceInitial].
  ///
  /// Otherwise, [fallback] widget will be used when build on first time or
  /// layout would not update when state is [ServiceInitial], which means layout
  /// will be preserved from previous build.
  final Widget Function(
    BuildContext context,
    ServiceInitial state,
  )? onInitial;

  /// A widget builder which is only called when [buildWhen] is omitted or
  /// custom [buildWhen] is passed and [onLoading] is not omitted and current
  /// state is [ServiceLoadInProgress].
  ///
  /// Otherwise, layout would not update when state is [ServiceInitial], which
  /// means layout will be preserved from previous build.
  final Widget Function(
    BuildContext context,
    ServiceLoadInProgress<ServiceRequestedEvent> state,
    ServiceRequestedEvent event,
  )? onLoading;

  /// A widget builder which is only called when [buildWhen] is omitted or
  /// custom [buildWhen] is passed and current state is [ServiceLoadSuccess].
  final Widget Function(
    BuildContext context,
    ServiceLoadSuccess<ServiceRequestedEvent, ResponseData> state,
    ServiceRequestedEvent event,
    ResponseData data,
  ) onSuccess;

  /// A widget builder which is only called when [buildWhen] is omitted or
  /// custom [buildWhen] is passed [onFailure] is not omitted and current state
  /// is [ServiceLoadFailure].
  ///
  /// Otherwise, layout would not update when state is [ServiceLoadFailure],
  /// which means layout will be preserved from previous build.
  final Widget Function(
    BuildContext context,
    ServiceLoadFailure<ServiceRequestedEvent> state,
    ServiceRequestedEvent event,
    dynamic error,
  )? onFailure;

  /// A fallback widget for [builder] to use when build on first time or
  /// [buildWhen] got passed but widget builder function is omitted.
  ///
  /// Please make sure, which [RenderObject] is extends by parent widget. You
  /// should the same type of [RenderObject] with [fallback].
  /// For example: [RenderBox], [RenderSliver].
  final Widget fallback;
}
