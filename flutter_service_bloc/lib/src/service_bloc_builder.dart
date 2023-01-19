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
    Key? key,
    Bloc? bloc,
    BlocBuilderCondition? buildWhen,
    this.onInitial,
    this.onLoading,
    required this.onSuccess,
    this.onFailure,
    this.fallback = const SizedBox(),
  }) : super(
          key: key,
          bloc: bloc,
          buildWhen: buildWhen ??
              (previous, current) {
                if (current is ServiceInitial) {
                  return onInitial != null;
                }

                if (current is ServiceLoadInProgress<ServiceRequestedEvent>) {
                  return onLoading != null;
                }

                if (current is ServiceLoadSuccess<ServiceRequestedEvent,
                    ResponseData>) {
                  return true;
                }

                if (current is ServiceLoadFailure<ServiceRequestedEvent>) {
                  return onFailure != null;
                }

                return false;
              },
          builder: (context, state) {
            if (state is ServiceInitial) {
              if (onInitial == null) {
                return fallback;
              }
              return onInitial(context, state);
            }

            if (state is ServiceLoadInProgress<ServiceRequestedEvent>) {
              if (onLoading == null) {
                return fallback;
              }
              return onLoading(context, state, state.event);
            }

            if (state
                is ServiceLoadSuccess<ServiceRequestedEvent, ResponseData>) {
              final data = state.data;
              if (data == null) {
                return fallback;
              }

              return onSuccess(context, state, state.event, data);
            }

            if (state is ServiceLoadFailure<ServiceRequestedEvent>) {
              if (onFailure == null) {
                return fallback;
              }
              return onFailure(context, state, state.event, state.error);
            }

            return fallback;
          },
        );

  /// A widget builder which is only called when build on first time or
  /// [buildWhen] is omitted or custom [buildWhen] is passed and [onInitial] is
  /// not omitted and current state is [ServiceInitial].
  ///
  /// Otherwise, [fallback] widget will be used when build on first time or
  /// layout would not update when state is [ServiceInitial], which means layout
  /// will be preserved from previous build.
  final Widget Function(BuildContext context, ServiceInitial state)? onInitial;

  /// A widget builder which is only called when [buildWhen] is omitted or
  /// custom [buildWhen] is passed and [onLoading] is not omitted and current
  /// state is [ServiceLoadInProgress].
  ///
  /// Otherwise, layout would not update when state is [ServiceInitial], which
  /// means layout will be preserved from previous build.
  final Widget Function(
      BuildContext context,
      ServiceLoadInProgress<ServiceRequestedEvent> state,
      ServiceRequestedEvent event)? onLoading;

  /// A widget builder which is only called when [buildWhen] is omitted or
  /// custom [buildWhen] is passed and current state is [ServiceLoadSuccess].
  final Widget Function(
      BuildContext context,
      ServiceLoadSuccess<ServiceRequestedEvent, ResponseData> state,
      ServiceRequestedEvent event,
      ResponseData data) onSuccess;

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
      dynamic error)? onFailure;

  /// A fallback widget for [builder] to use when build on first time or
  /// [buildWhen] got passed but widget builder function is omitted.
  ///
  /// Please make sure, which [RenderObject] is extends by parent widget. You
  /// should the same type of [RenderObject] with [fallback].
  /// For example: [RenderBox], [RenderSliver].
  final Widget fallback;
}
